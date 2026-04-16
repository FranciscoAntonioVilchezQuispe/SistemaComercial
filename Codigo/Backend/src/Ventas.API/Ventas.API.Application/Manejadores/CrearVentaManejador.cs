using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Eventos;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Nucleo.Comun.Domain;
using Nucleo.Comun.Domain.Enums;
using System.Linq;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Nucleo.Comun.Domain.Helpers;
using Nucleo.Comun.Domain.Constants;

namespace Ventas.API.Application.Manejadores
{
    public class CrearVentaManejador : IRequestHandler<CrearVentaComando, VentaDto>
    {
        private readonly IVentasDbContext _context;
        private readonly IVentaRepositorio _ventaRepositorio;
        private readonly IMediator _mediator;

        public CrearVentaManejador(IVentasDbContext context, IVentaRepositorio ventaRepositorio, IMediator mediator)
        {
            _context = context;
            _ventaRepositorio = ventaRepositorio;
            _mediator = mediator;
        }

        public async Task<VentaDto> Handle(CrearVentaComando request, CancellationToken cancellationToken)
        {
            var dto = request.Venta;

            // 0. Obtener Porcentaje IGV dinámicamente de BD
            var impuestoRef = await _context.ImpuestosRef
                .FirstOrDefaultAsync(x => x.CodigoSunat == FiscalConstants.CODIGO_TRIBUTO_IGV, cancellationToken);
            decimal porcentajeIgv = impuestoRef?.Porcentaje ?? FiscalConstants.PORCENTAJE_IGV;

            // 0.1 Validar Relación Tipo Documento vs Tipo Comprobante (Regla SUNAT)
            var clienteInfo = await _context.Clientes
                .Where(c => c.Id == dto.IdCliente || (dto.IdCliente <= 0 && c.NumeroDocumento == "00000000"))
                .Select(c => new { c.Id, c.IdTipoDocumento })
                .FirstOrDefaultAsync(cancellationToken);

            if (clienteInfo != null)
            {
                var codigoDocumento = await _context.TiposDocumentoRef
                    .Where(td => td.Id == clienteInfo.IdTipoDocumento)
                    .Select(td => td.Codigo)
                    .FirstOrDefaultAsync(cancellationToken);

                if (!string.IsNullOrEmpty(codigoDocumento))
                {
                    var reglasConfiguradas = await _context.ReglasDocumentoRef
                        .Where(r => r.CodigoDocumento == codigoDocumento && r.Activado)
                        .Select(r => r.IdTipoComprobante)
                        .ToListAsync(cancellationToken);

                    if (reglasConfiguradas.Any() && !reglasConfiguradas.Contains(dto.IdTipoComprobante))
                    {
                        var nombreComprobante = await _context.TiposComprobanteRef
                            .Where(tc => tc.Id == dto.IdTipoComprobante)
                            .Select(tc => tc.Nombre)
                            .FirstOrDefaultAsync(cancellationToken) ?? "Comprobante Desconocido";
                        
                        throw new AppException("SUNAT_VALIDATION", $"El tipo de documento del cliente no permite emitir {nombreComprobante}.");
                    }
                }
            }

            // 1. Obtener siguiente correlativo de forma atómica
            long numeroDocumento = await _ventaRepositorio.ObtenerSiguienteCorrelativoAsync(dto.IdAlmacen, dto.IdTipoComprobante, dto.Serie);

            // 1.1 Obtener configuración fiscal de todos los productos en la venta
            var idsProductos = dto.Detalles.Select(d => d.IdProducto).Distinct().ToList();
            var productosConfig = await _context.ProductosRef
                .Where(p => idsProductos.Contains(p.Id))
                .Join(_context.TiposAfectacionIgvRef, 
                    p => p.IdTipoAfectacionIgv, 
                    a => a.Id, 
                    (p, a) => new { p.Id, a.CodigoSunat, a.EsGravado, a.EsExonerado, a.EsInafecto, a.EsGratuito })
                .ToDictionaryAsync(x => x.Id, x => x, cancellationToken);

            // 2. Mapear a Entidad e implementar cálculos de negocio (SUNAT)
            var detalles = new List<DetalleVenta>();
            decimal subtotalGravado = 0;
            decimal subtotalExonerado = 0;
            decimal subtotalInafecto = 0;
            decimal totalImpuesto = 0;
            decimal totalGratuito = 0;

            foreach (var d in dto.Detalles)
            {
                // Obtener configuración fiscal real del producto
                if (!productosConfig.TryGetValue(d.IdProducto, out var config))
                {
                    throw new AppException("PRODUCTO_VALIDACION", $"No se encontró la configuración fiscal para el producto ID: {d.IdProducto}");
                }

                string afectacion = config.CodigoSunat;
                bool esGravado = config.EsGravado;
                bool esGratuito = config.EsGratuito;
                
                decimal tasa = esGravado ? porcentajeIgv : 0m;
                
                // Cálculo de Precio Unitario Base (Desglosando IGV si es gravado)
                decimal precioUnitarioBase = esGravado 
                    ? Math.Round(d.PrecioUnitario / (1 + (tasa / 100)), 4)
                    : d.PrecioUnitario;

                // Valor Item = (Base * Cantidad) - Descuento
                decimal subtotalLineaOriginal = precioUnitarioBase * d.Cantidad;
                decimal valorItem = Math.Round(subtotalLineaOriginal - d.DescuentoItem, 2);
                
                // Impuesto Item
                decimal impuestoItem = esGravado
                    ? Math.Round(valorItem * (tasa / 100), 2)
                    : 0;

                // Total Item
                decimal totalItem = valorItem + impuestoItem;

                // Consistencia de Tributo (Catalogo 05)
                string codigoTributo = afectacion switch
                {
                    var a when a.StartsWith("1") => FiscalConstants.CODIGO_TRIBUTO_IGV, // IGV
                    var a when a.StartsWith("2") => "9997", // EXO
                    var a when a.StartsWith("3") => "9998", // INA
                    var a when a == "40" => "9995",         // EXP
                    _ => FiscalConstants.CODIGO_TRIBUTO_IGV
                };

                detalles.Add(new DetalleVenta
                {
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    DescripcionProducto = d.DescripcionProducto,
                    Cantidad = d.Cantidad,
                    PrecioUnitario = d.PrecioUnitario,
                    PrecioListaOriginal = d.PrecioListaOriginal ?? d.PrecioUnitario,
                    PrecioUnitarioBase = precioUnitarioBase,
                    DescuentoItem = d.DescuentoItem,
                    ValorItem = valorItem,
                    PorcentajeImpuesto = tasa,
                    ImpuestoItem = impuestoItem,
                    TotalItem = totalItem,
                    CodigoAfectacionIgv = afectacion,
                    CodigoTributo = codigoTributo
                });

                // Acumuladores de cabecera
                if (esGratuito) 
                {
                    totalGratuito += totalItem;
                }
                else
                {
                    if (esGravado) subtotalGravado += valorItem;
                    else if (config.EsExonerado) subtotalExonerado += valorItem;
                    else subtotalInafecto += valorItem;

                    totalImpuesto += impuestoItem;
                }
            }

            // Totales de cabecera
            var subtotalTotal = subtotalGravado + subtotalExonerado + subtotalInafecto;
            var totalVenta = subtotalTotal + totalImpuesto - dto.TotalDescuentoGlobal;
            
            var totalPagado = dto.Pagos?.Sum(p => p.MontoPago) ?? 0;
            var saldoPendiente = totalVenta - totalPagado;
            
            // Determinar estado de pago
            long idEstadoPago = (long)EstadoPago.Pendiente;
            if (saldoPendiente <= 0) idEstadoPago = (long)EstadoPago.Pagado;
            else if (totalPagado > 0) idEstadoPago = (long)EstadoPago.Parcial;

            var venta = new Venta
            {
                IdEmpresa = dto.IdEmpresa > 0 ? dto.IdEmpresa : 1,
                IdAlmacen = dto.IdAlmacen,
                IdCaja = dto.IdCaja,
                IdCliente = dto.IdCliente,
                IdUsuarioVendedor = dto.IdUsuarioVendedor > 0 ? dto.IdUsuarioVendedor : 1,
                IdCotizacionOrigen = dto.IdCotizacionOrigen,
                IdTipoComprobante = dto.IdTipoComprobante,
                Serie = dto.Serie,
                Numero = numeroDocumento,
                FechaEmision = dto.FechaEmision == default ? DateTimeHelper.ObtenerAhoraLima() : dto.FechaEmision,
                FechaVencimientoPago = dto.FechaVencimientoPago,
                IdEstado = (long)EstadoVenta.Completada,
                Moneda = string.IsNullOrWhiteSpace(dto.Moneda) ? "PEN" : dto.Moneda,
                TipoCambio = dto.TipoCambio > 0 ? dto.TipoCambio : 1.0m,
                
                // Persistencia de Totales según Normas SUNAT
                SubtotalGravado = Math.Round(subtotalGravado, 2),
                SubtotalExonerado = Math.Round(subtotalExonerado, 2),
                SubtotalInafecto = Math.Round(subtotalInafecto, 2),
                TotalImpuesto = Math.Round(totalImpuesto, 2),
                TotalDescuentoGlobal = dto.TotalDescuentoGlobal,
                TotalVenta = Math.Round(totalVenta, 2),
                TotalGratuito = Math.Round(totalGratuito, 2),
                
                SaldoPendiente = Math.Round(saldoPendiente < 0 ? 0 : saldoPendiente, 2),
                IdEstadoPago = idEstadoPago,
                Observaciones = dto.Observaciones,
                Detalles = detalles,
                
                // ID de Operación: Default a 0101 si no viene (Mapeo a Venta Interna)
                IdTipoOperacion = dto.IdTipoOperacion > 0 ? dto.IdTipoOperacion : (long?)null, 
                
                Pagos = dto.Pagos?.Select(p => new Pago
                {
                    IdMetodoPago = p.IdMetodoPago,
                    MontoPago = p.MontoPago,
                    ReferenciaPago = p.ReferenciaPago,
                    FechaPago = p.FechaPago == default ? DateTimeHelper.ObtenerAhoraLima() : p.FechaPago
                }).ToList() ?? new List<Pago>()
            };

            // Cliente "Público General" Fallback
            if (venta.IdCliente <= 0)
            {
                venta.IdCliente = clienteInfo?.Id ?? 1;
            }

            // 3. Persistir Venta
            _context.Ventas.Add(venta);
            await _context.SaveChangesAsync(cancellationToken);

            // 4. Publicar evento para actualizar inventario
            var evento = new VentaCreadaEvento(
                venta.Id,
                venta.IdAlmacen,
                venta.IdTipoComprobante,
                venta.Serie ?? string.Empty,
                venta.Numero.ToString(),
                venta.FechaEmision,
                venta.Detalles.Select(d => new VentaItemDetalle(d.IdProducto, d.Cantidad)).ToList()
            );
            await _mediator.Publish(evento, cancellationToken);

            // 5. Retornar DTO Actualizado
            dto.Id = venta.Id;
            dto.Numero = venta.Numero;
            dto.SaldoPendiente = venta.SaldoPendiente;
            dto.IdEstadoPago = venta.IdEstadoPago;
            dto.IdEstado = venta.IdEstado;
            dto.SubtotalGravado = venta.SubtotalGravado;
            dto.SubtotalExonerado = venta.SubtotalExonerado;
            dto.SubtotalInafecto = venta.SubtotalInafecto;
            dto.TotalImpuesto = venta.TotalImpuesto;
            dto.TotalVenta = venta.TotalVenta;
            
            return dto;
        }
    }
}
