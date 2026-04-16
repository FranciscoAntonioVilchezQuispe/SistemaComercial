using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;
using Nucleo.Comun.Domain.Helpers;
using Nucleo.Comun.Domain.Constants;

namespace Ventas.API.Application.Manejadores
{
    public class CrearNotaDebitoManejador : IRequestHandler<CrearNotaDebitoComando, NotaDebitoDto>
    {
        private readonly IVentasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CrearNotaDebitoManejador> _logger;

        public CrearNotaDebitoManejador(
            IVentasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<CrearNotaDebitoManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<NotaDebitoDto> Handle(CrearNotaDebitoComando request, CancellationToken cancellationToken)
        {
            var dto = request.Nota;

            // 1. Validar que la venta de referencia exista y cargar cliente
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.Detalles)
                .FirstOrDefaultAsync(v => v.Id == dto.IdVentaReferencia, cancellationToken);
            
            if (venta == null)
                throw new Exception("La venta de referencia no existe.");

            // 2. Obtener Porcentaje IGV dinámicamente de BD
            var impuesto = await _context.ImpuestosRef.FirstOrDefaultAsync(x => x.CodigoSunat == FiscalConstants.CODIGO_TRIBUTO_IGV, cancellationToken);
            decimal porcentajeIgv = impuesto?.Porcentaje ?? FiscalConstants.PORCENTAJE_IGV;

            // 2.1 Obtener Tipo Documento del Cliente para SUNAT (Evitar nulos del DTO)
            var tipoDocCliente = await _context.TiposDocumentoRef.FirstOrDefaultAsync(x => x.Id == venta.Cliente.IdTipoDocumento, cancellationToken);
            string codigoTipoDocCliente = tipoDocCliente?.Codigo ?? "1"; // DNI por defecto

            // 3. Obtener correlativo de serie
            var serieObj = await _context.SeriesComprobantes
                .FirstOrDefaultAsync(s => s.Serie == dto.Serie, cancellationToken);

            if (serieObj == null)
                throw new Exception($"La serie seleccionada ({dto.Serie}) no existe o no está configurada.");

            serieObj.CorrelativoActual += 1;
            long nuevoNumero = serieObj.CorrelativoActual;

            // 4. Mapear a Entidad y Calcular dinámicamente
            decimal tSubtotal = 0;
            decimal tIgv = 0;
            decimal tTotal = 0;
            var detallesNota = new List<NotaDebitoDetalle>();
            int contadorItem = 1;

            foreach (var detDto in dto.Detalles)
            {
                var ventaDetOri = venta.Detalles.FirstOrDefault(d => d.Id == detDto.IdVentaDetalle);
                
                // Recálculo seguro en backend
                decimal cant = detDto.Cantidad > 0 ? detDto.Cantidad : (ventaDetOri?.Cantidad ?? 1);
                decimal pu = ventaDetOri?.PrecioUnitario ?? detDto.PrecioUnitario;
                
                decimal valItem = pu / (1 + (porcentajeIgv / 100));
                decimal subtotalLinea = valItem * cant;
                decimal igvLinea = Math.Round(subtotalLinea * (porcentajeIgv / 100), 2);
                subtotalLinea = Math.Round(subtotalLinea, 2);
                decimal totalLinea = subtotalLinea + igvLinea;

                tSubtotal += subtotalLinea;
                tIgv += igvLinea;
                tTotal += totalLinea;

                detallesNota.Add(new NotaDebitoDetalle
                {
                    IdVentaDetalle = detDto.IdVentaDetalle,
                    IdProducto = detDto.IdProducto,
                    Descripcion = detDto.Descripcion ?? ventaDetOri?.DescripcionProducto ?? "Desconocido",
                    UnidadMedida = detDto.UnidadMedida ?? "NIU",
                    Cantidad = cant,
                    PrecioUnitario = pu,
                    ValorItem = valItem,
                    PrecioUnitarioBase = pu,
                    PorcentajeImpuesto = porcentajeIgv,
                    Subtotal = subtotalLinea,
                    Igv = igvLinea,
                    Total = totalLinea,
                    IdAfectacionIgv = ventaDetOri?.IdAfectacionIgv, // Heredar
                    IdTributo = ventaDetOri?.IdTributo,
                    IdUnidadMedida = ventaDetOri?.IdUnidadMedida,
                    NumeroLinea = contadorItem++
                });
            }

            var tipocomp = await _context.TiposComprobanteRef.FirstOrDefaultAsync(x => x.Id == venta.IdTipoComprobante);

            var nota = new NotaDebito
            {
                Serie = dto.Serie,
                Numero = nuevoNumero, // Asignado por BE
                TipoComprobante = "08",
                IdVentaReferencia = dto.IdVentaReferencia,
                SerieReferencia = venta.Serie,
                NumeroReferencia = venta.Numero,
                TipoDocReferencia = tipocomp?.Codigo ?? "01",
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                // Usar datos de la venta original/base de datos (Flujo robusto)
                IdEmpresa = venta.IdEmpresa,
                IdTipoOperacion = venta.IdTipoOperacion,
                ClienteTipoDoc = codigoTipoDocCliente,
                ClienteNroDoc = venta.Cliente.NumeroDocumento,
                ClienteRazonSocial = venta.Cliente.RazonSocial,
                
                SubtotalGravado = tSubtotal,
                Subtotal = tSubtotal,
                Igv = tIgv,
                Total = tTotal,
                Moneda = venta.Moneda,
                TipoCambio = venta.TipoCambio,
                PorcentajeIgv = porcentajeIgv,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = DateTimeHelper.ObtenerAhoraLima(),
                Estado = "PENDIENTE",
                IdEstadoCpe = "PENDIENTE",
                IdEstado = (long)EstadoDocumento.Registrado, // Registrado
                
                Detalles = detallesNota
            };

            // 5. Persistir Nota
            _context.NotasDebito.Add(nota);
            
            // 5.1 Vincular con Venta (v1.0)
            venta.IdEstado = (long)EstadoDocumento.AnuladoNotaDebito;
            venta.IdNotaDebito = nota.Id;
            venta.TipoAnulacion = "nota_debito";
            venta.FechaAnulacion = DateTimeHelper.ObtenerAhoraLima();
            venta.MotivoAnulacion = nota.MotivoSustento;
            venta.Observaciones += $"\n[NOTA DÉBITO] {DateTimeHelper.ObtenerAhoraLima()}: Nota {nota.Serie}-{nota.Numero} generada.";

            _context.Ventas.Update(venta);
            await _context.SaveChangesAsync(cancellationToken);

            // 6. Actualizar Inventario si afecta stock
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = venta.IdAlmacen; 

                    var success = await _inventarioServicio.RegistrarSalidaNotaDebitoAsync(
                        det.IdProducto, 
                        idAlmacen, 
                        det.Cantidad, 
                        nota.Id, 
                        nota.Serie, 
                        nota.Numero.ToString(),
                        serieObj.IdTipoComprobante ?? 0,
                        nota.FechaEmision);

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar salida en inventario para ND {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock por Nota de Débito.");
                    }
                }
            }

            // Devolver DTO poblado
            dto.Id = nota.Id;
            dto.Numero = nota.Numero;
            dto.Subtotal = tSubtotal;
            dto.Igv = tIgv;
            dto.Total = tTotal;
            dto.ClienteNroDoc = nota.ClienteNroDoc;
            dto.ClienteRazonSocial = nota.ClienteRazonSocial;

            return dto;
        }
    }
}
