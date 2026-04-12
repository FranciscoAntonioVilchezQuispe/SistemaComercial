using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Domain.Enums;

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

            // 2. Mapear a Entidad
            var nota = new NotaCreditoCompra
            {
                Serie = dto.Serie,
                Numero = dto.Numero,
                TipoComprobante = "07",
                IdCompraReferencia = dto.IdCompraReferencia,
                SerieReferencia = compra.SerieComprobante,
                NumeroReferencia = compra.NumeroComprobante,
                TipoDocReferencia = "01", // TODO: Obtener del TipoComprobante de la compra
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                IdProveedor = compra.IdProveedor,
                ProveedorTipoDoc = compra.Proveedor.IdTipoDocumento == (long)TipoDocumentoIdentidad.DNI ? ((long)TipoDocumentoIdentidad.DNI).ToString() : ((long)TipoDocumentoIdentidad.RUC).ToString(),
                ProveedorNroDoc = compra.Proveedor.NumeroDocumento,
                ProveedorRazonSocial = compra.Proveedor.RazonSocial,
                
                Subtotal = dto.Subtotal,
                Igv = dto.Igv,
                Total = dto.Total,
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                Estado = "PENDIENTE",
                IdEstado = (long)EstadoDocumento.Registrado, // Registrado
                
                Detalles = dto.Detalles.Select(d => new NotaCreditoDetalleCompra
                {
                    IdCompraDetalle = d.IdCompraDetalle,
                    IdProducto = d.IdProducto,
                    Descripcion = d.Descripcion,
                    UnidadMedida = d.UnidadMedida,
                    Cantidad = d.Cantidad,
                    PrecioUnitario = d.PrecioUnitario,
                    Subtotal = d.Subtotal,
                    Igv = d.Igv,
                    Total = d.Total
                }).ToList()
            };

            // 3. Persistir Nota
            _context.NotasCredito.Add(nota);
            
            // 3.1 Actualizar Compra de Referencia (v1.0)
            compra.IdEstado = (long)EstadoDocumento.AnuladoNotaCredito;
            compra.IdNotaCredito = nota.Id;
            compra.TipoAnulacion = "nota_credito";
            compra.FechaAnulacion = DateTime.UtcNow;
            compra.MotivoAnulacion = nota.MotivoSustento;
            compra.Observaciones += $"\n[ANULACIÓN NC] {DateTime.UtcNow}: Nota {nota.Serie}-{nota.Numero} generada.";

            _context.Compras.Update(compra);

            // 3.2 Liberar Orden de Compra si existe referencia (v1.0)
            var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.CompraId == compra.Id, cancellationToken);
            if (orden != null)
            {
                _logger.LogInformation("Liberando Orden de Compra {CodigoOrden} por emisión de NC en Compra {CompraId}", orden.CodigoOrden, compra.Id);
                orden.CompraId = null;
                orden.IdEstado = (long)EstadoOrdenCompra.Aprobada;
                orden.Observaciones += $"\n[LIBERACIÓN POR NC] {DateTime.UtcNow}: Nota {nota.Serie}-{nota.Numero} generada.";
                _context.OrdenesCompra.Update(orden);
            }

            await _context.SaveChangesAsync(cancellationToken);

            // 4. Inventario (Nota de Crédito Compra es SALIDA de stock del almacén por devolución)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = compra.IdAlmacen;

                    // Buscar el tipo de comprobante por serie para obtener su ID
                    var serieObj = await _context.SeriesComprobantesRef
                        .FirstOrDefaultAsync(s => s.Serie == nota.Serie, cancellationToken);
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
            return dto;
        }
    }
}
