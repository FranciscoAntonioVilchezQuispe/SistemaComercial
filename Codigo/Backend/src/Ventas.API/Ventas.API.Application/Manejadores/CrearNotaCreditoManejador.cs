using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;

namespace Ventas.API.Application.Manejadores
{
    public class CrearNotaCreditoManejador : IRequestHandler<CrearNotaCreditoComando, NotaCreditoDto>
    {
        private readonly IVentasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CrearNotaCreditoManejador> _logger;

        public CrearNotaCreditoManejador(
            IVentasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<CrearNotaCreditoManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<NotaCreditoDto> Handle(CrearNotaCreditoComando request, CancellationToken cancellationToken)
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
            var impuesto = await _context.ImpuestosRef.FirstOrDefaultAsync(x => x.CodigoSunat == "1000", cancellationToken);
            decimal porcentajeIgv = impuesto?.Porcentaje ?? 18.00m;

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
            var detallesNota = new List<NotaCreditoDetalle>();

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

                detallesNota.Add(new NotaCreditoDetalle
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
                    IdAfectacionIgv = ventaDetOri?.IdAfectacionIgv, // Hedar la afectación original
                    IdTributo = ventaDetOri?.IdTributo,
                    IdUnidadMedida = ventaDetOri?.IdUnidadMedida
                });
            }

            var tipocomp = await _context.TiposComprobanteRef.FirstOrDefaultAsync(x => x.Id == venta.IdTipoComprobante);

            var nota = new NotaCredito
            {
                Serie = dto.Serie,
                Numero = nuevoNumero, // Asignado por BE
                TipoComprobante = "07",
                IdVentaReferencia = dto.IdVentaReferencia,
                SerieReferencia = venta.Serie,
                NumeroReferencia = venta.Numero,
                TipoDocReferencia = tipocomp?.Codigo ?? "01",
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                // Ignorar datos del cliente del dto parcialmente y usar venta original
                ClienteTipoDoc = dto.ClienteTipoDoc,
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
                FechaEmision = DateTime.UtcNow,
                Estado = "PENDIENTE",
                IdEstadoCpe = "PENDIENTE",
                
                Detalles = detallesNota
            };

            // 5. Persistir Nota
            _context.NotasCredito.Add(nota);
            await _context.SaveChangesAsync(cancellationToken);

            // 6. Actualizar Inventario si afecta stock (Nota de Crédito = Reingreso de mercadería)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = venta.IdAlmacen; 

                    var success = await _inventarioServicio.RegistrarEntradaNotaCreditoAsync(
                        det.IdProducto, 
                        idAlmacen, 
                        det.Cantidad, 
                        nota.Id, 
                        nota.Serie, 
                        nota.Numero.ToString());

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar entrada en inventario para NC {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock para el producto {det.Descripcion}.");
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
