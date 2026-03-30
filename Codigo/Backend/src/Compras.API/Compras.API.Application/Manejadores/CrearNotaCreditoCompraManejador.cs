using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Microsoft.Extensions.Logging;

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

            // 1. Validar compra de referencia
            var compra = await _context.Compras
                .Include(c => c.Detalles)
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
                
                IdProveedor = dto.IdProveedor,
                ProveedorTipoDoc = dto.ProveedorTipoDoc,
                ProveedorNroDoc = dto.ProveedorNroDoc,
                ProveedorRazonSocial = dto.ProveedorRazonSocial,
                
                Subtotal = dto.Subtotal,
                Igv = dto.Igv,
                Total = dto.Total,
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                Estado = "PENDIENTE",
                
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
            await _context.SaveChangesAsync(cancellationToken);

            // 4. Inventario (Nota de Crédito Compra es SALIDA de stock del almacén por devolución)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    // TODO: Obtener AlmacenId dinámico del detalle de compra original
                    long idAlmacen = 1;

                    var success = await _inventarioServicio.RegistrarSalidaNotaCreditoAsync(
                        det.IdProducto,
                        idAlmacen,
                        det.Cantidad,
                        nota.Id,
                        nota.Serie,
                        nota.Numero);

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
