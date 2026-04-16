using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;
using Nucleo.Comun.Domain.Helpers;
using Nucleo.Comun.Domain.Constants;

namespace Compras.API.Application.Manejadores
{
    public class CrearNotaCreditoCompraManejador : IRequestHandler<CrearNotaCreditoCompraComando, NotaCreditoCompraDto>
    {
        private readonly IComprasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CrearNotaCreditoCompraManejador> _logger;

        public CrearNotaCreditoCompraManejador(
            IComprasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<CrearNotaCreditoCompraManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<NotaCreditoCompraDto> Handle(CrearNotaCreditoCompraComando request, CancellationToken cancellationToken)
        {
            var dto = request.Nota;

            // 1. Validar compra de referencia (incluyendo proveedor)
            var compra = await _context.Compras
                .Include(c => c.Detalles)
                .Include(c => c.Proveedor)
                .FirstOrDefaultAsync(c => c.Id == dto.IdCompraReferencia, cancellationToken);
            
            if (compra == null)
                throw new Exception("La compra de referencia no existe.");

            // 2. Obtener Porcentaje IGV dinámicamente o usar constante
            decimal porcentajeIgv = FiscalConstants.PORCENTAJE_IGV;

            // 3. Obtener correlativo automático por serie
            var serieObj = await _context.SeriesComprobantesRef
                .FirstOrDefaultAsync(s => s.Serie == dto.Serie, cancellationToken);

            if (serieObj == null)
                throw new Exception($"La serie seleccionada ({dto.Serie}) no existe o no está configurada.");

            serieObj.CorrelativoActual += 1;
            string nuevoNumero = serieObj.CorrelativoActual.ToString().PadLeft(8, '0');

            // 4. Mapear a Entidad y Recalcular Totales
            decimal tSubtotal = 0;
            decimal tIgv = 0;
            decimal tTotal = 0;

            var detallesNota = new List<NotaCreditoDetalleCompra>();
            foreach (var detDto in dto.Detalles)
            {
                var compraDetOri = compra.Detalles.FirstOrDefault(d => d.Id == detDto.IdCompraDetalle);
                
                decimal cant = detDto.Cantidad > 0 ? detDto.Cantidad : (compraDetOri?.Cantidad ?? 0);
                decimal pu = compraDetOri?.PrecioUnitarioCompra ?? detDto.PrecioUnitario;
                
                decimal subtotalLinea = Math.Round(cant * pu / (1 + (porcentajeIgv / 100)), 2);
                decimal totalLinea = Math.Round(cant * pu, 2);
                decimal igvLinea = totalLinea - subtotalLinea;

                tSubtotal += subtotalLinea;
                tIgv += igvLinea;
                tTotal += totalLinea;

                detallesNota.Add(new NotaCreditoDetalleCompra
                {
                    IdCompraDetalle = detDto.IdCompraDetalle,
                    IdProducto = detDto.IdProducto,
                    Descripcion = detDto.Descripcion ?? compraDetOri?.Descripcion ?? "Desconocido",
                    UnidadMedida = detDto.UnidadMedida ?? "NIU",
                    Cantidad = cant,
                    PrecioUnitario = pu,
                    Subtotal = subtotalLinea,
                    Igv = igvLinea,
                    Total = totalLinea
                });
            }

            var tipocomp = await _context.TiposComprobanteRef.FirstOrDefaultAsync(x => x.Codigo == "01"); // Factura por defecto para referencia

            var nota = new NotaCreditoCompra
            {
                Serie = dto.Serie,
                Numero = nuevoNumero,
                TipoComprobante = "07",
                IdCompraReferencia = dto.IdCompraReferencia,
                SerieReferencia = compra.SerieComprobante,
                NumeroReferencia = compra.NumeroComprobante,
                TipoDocReferencia = tipocomp?.Codigo ?? "01",
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                IdProveedor = compra.IdProveedor,
                ProveedorTipoDoc = compra.Proveedor.IdTipoDocumento.ToString(),
                ProveedorNroDoc = compra.Proveedor.NumeroDocumento,
                ProveedorRazonSocial = compra.Proveedor.RazonSocial,
                
                Subtotal = tSubtotal,
                Igv = tIgv,
                Total = tTotal,
                Moneda = compra.Moneda,
                TipoCambio = compra.TipoCambio,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = DateTimeHelper.ObtenerAhoraLima(),
                Estado = "PENDIENTE",
                IdEstado = (long)EstadoDocumento.Registrado,
                
                Detalles = detallesNota
            };

            // 5. Persistir Nota
            _context.NotasCredito.Add(nota);
            
            // 5.1 Actualizar Compra de Referencia
            compra.IdEstado = (long)EstadoDocumento.AnuladoNotaCredito;
            compra.IdNotaCredito = nota.Id;
            compra.TipoAnulacion = "nota_credito";
            compra.FechaAnulacion = DateTimeHelper.ObtenerAhoraLima();
            compra.MotivoAnulacion = nota.MotivoSustento;
            compra.Observaciones += $"\n[ANULACIÓN NC] {DateTimeHelper.ObtenerAhoraLima()}: Nota {nota.Serie}-{nota.Numero} generada.";

            _context.Compras.Update(compra);

            // 5.2 Liberar Orden de Compra si existe referencia
            var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.CompraId == compra.Id, cancellationToken);
            if (orden != null)
            {
                orden.CompraId = null;
                orden.IdEstado = (long)EstadoOrdenCompra.Aprobada;
                orden.Observaciones += $"\n[LIBERACIÓN POR NC] {DateTimeHelper.ObtenerAhoraLima()}: Nota {nota.Serie}-{nota.Numero} generada.";
                _context.OrdenesCompra.Update(orden);
            }

            await _context.SaveChangesAsync(cancellationToken);

            // 6. Inventario (Nota de Crédito Compra es SALIDA de stock del almacén por devolución)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = compra.IdAlmacen;
                    long idTipoComprobante = serieObj?.IdTipoComprobante ?? 0;

                    var success = await _inventarioServicio.RegistrarSalidaNotaCreditoAsync(
                        det.IdProducto,
                        idAlmacen,
                        det.Cantidad,
                        nota.Id,
                        nota.Serie,
                        nota.Numero,
                        idTipoComprobante);

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar salida en inventario para NC Compra {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock para el producto {det.Descripcion}.");
                    }
                }
            }

            dto.Id = nota.Id;
            dto.Numero = nota.Numero;
            dto.Total = tTotal;
            return dto;
        }
    }
}
