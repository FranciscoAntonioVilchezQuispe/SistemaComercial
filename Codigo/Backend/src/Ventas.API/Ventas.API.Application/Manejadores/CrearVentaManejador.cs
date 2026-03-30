using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Eventos;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Nucleo.Comun.Domain.Enums;

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

            // 1. Obtener siguiente correlativo de forma atómica
            long numeroDocumento = await _ventaRepositorio.ObtenerSiguienteCorrelativoAsync(dto.IdAlmacen, dto.IdTipoComprobante, dto.Serie);

            // 2. Mapear a Entidad e implementar cálculos de negocio (SUNAT)
            var detalles = new List<DetalleVenta>();
            decimal subtotalGravado = 0;
            decimal subtotalExonerado = 0;
            decimal subtotalInafecto = 0;
            decimal totalImpuesto = 0;

            foreach (var d in dto.Detalles)
            {
                // Regla: Porcentaje de impuesto viene del backend o config (hardcoded 18% para Gravados temporalmente)
                decimal porcentajeImpuesto = d.CodigoAfectacionIgv == "10" ? 18.0m : 0m;
                
                // Cálculo de Precio Unitario Base (Sin IGV)
                decimal precioUnitarioBase = d.CodigoAfectacionIgv == "10" 
                    ? d.PrecioUnitario / (1 + (porcentajeImpuesto / 100))
                    : d.PrecioUnitario;

                // Valor Item = (Base * Cantidad) - Descuento
                decimal valorItem = (precioUnitarioBase * d.Cantidad) - d.DescuentoItem;
                
                // Impuesto Item
                decimal impuestoItem = d.CodigoAfectacionIgv == "10"
                    ? valorItem * (porcentajeImpuesto / 100)
                    : 0;

                // Total Item
                decimal totalItem = valorItem + impuestoItem;

                // Consistencia de Tributo (Catalogo 05)
                string codigoTributo = d.CodigoAfectacionIgv switch
                {
                    "10" => "1000", // IGV
                    "20" => "9997", // EXO
                    "30" => "9998", // INA
                    "40" => "9995", // EXP
                    _ => "1000"
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
                    PorcentajeImpuesto = porcentajeImpuesto,
                    ImpuestoItem = impuestoItem,
                    TotalItem = totalItem,
                    CodigoAfectacionIgv = d.CodigoAfectacionIgv,
                    CodigoTributo = codigoTributo
                });

                // Acumuladores para cabecera
                if (d.CodigoAfectacionIgv == "10") subtotalGravado += valorItem;
                else if (d.CodigoAfectacionIgv == "20") subtotalExonerado += valorItem;
                else subtotalInafecto += valorItem;

                totalImpuesto += impuestoItem;
            }

            var totalVenta = subtotalGravado + subtotalExonerado + subtotalInafecto + totalImpuesto - dto.TotalDescuentoGlobal;
            var totalPagado = dto.Pagos?.Sum(p => p.MontoPago) ?? 0;
            var saldoPendiente = totalVenta - totalPagado;
            
            // Determinar estado de pago (Tabla 13)
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
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                FechaVencimientoPago = dto.FechaVencimientoPago,
                IdEstado = (long)EstadoVenta.Completada,
                Moneda = string.IsNullOrWhiteSpace(dto.Moneda) ? "PEN" : dto.Moneda,
                TipoCambio = dto.TipoCambio > 0 ? dto.TipoCambio : 1.0m,
                SubtotalGravado = Math.Round(subtotalGravado, 2),
                SubtotalExonerado = Math.Round(subtotalExonerado, 2),
                SubtotalInafecto = Math.Round(subtotalInafecto, 2),
                TotalImpuesto = Math.Round(totalImpuesto, 2),
                TotalDescuentoGlobal = dto.TotalDescuentoGlobal,
                TotalVenta = Math.Round(totalVenta, 2),
                SaldoPendiente = Math.Round(saldoPendiente < 0 ? 0 : saldoPendiente, 2),
                IdEstadoPago = idEstadoPago,
                Observaciones = dto.Observaciones,
                Detalles = detalles,
                Pagos = dto.Pagos?.Select(p => new Pago
                {
                    IdMetodoPago = p.IdMetodoPago,
                    MontoPago = p.MontoPago,
                    ReferenciaPago = p.ReferenciaPago,
                    FechaPago = p.FechaPago == default ? DateTime.UtcNow : p.FechaPago
                }).ToList() ?? new List<Pago>()
            };

            // Manejar Cliente "Público General" si Id es 0
            if (venta.IdCliente <= 0)
            {
                var clienteDefault = await _context.Clientes
                    .FirstOrDefaultAsync(c => c.NumeroDocumento == "00000000", cancellationToken);
                if (clienteDefault != null) venta.IdCliente = clienteDefault.Id;
                else venta.IdCliente = 1; 
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
                venta.Detalles.Select(d => new VentaItemDetalle(d.IdProducto, d.Cantidad)).ToList()
            );
            await _mediator.Publish(evento, cancellationToken);

            // 5. Retornar DTO Actualizado
            dto.Id = venta.Id;
            dto.Numero = venta.Numero;
            dto.SaldoPendiente = venta.SaldoPendiente;
            dto.IdEstadoPago = venta.IdEstadoPago;
            dto.IdEstado = venta.IdEstado;
            
            return dto;
        }
    }
}
