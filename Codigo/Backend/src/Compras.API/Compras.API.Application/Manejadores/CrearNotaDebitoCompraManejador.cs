using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Microsoft.Extensions.Logging;

namespace Compras.API.Application.Manejadores
{
    public class CrearNotaDebitoCompraManejador : IRequestHandler<CrearNotaDebitoCompraComando, NotaDebitoCompraDto>
    {
        private readonly IComprasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;
        private readonly ILogger<CrearNotaDebitoCompraManejador> _logger;

        public CrearNotaDebitoCompraManejador(
            IComprasDbContext context, 
            IInventarioServicio inventarioServicio,
            ILogger<CrearNotaDebitoCompraManejador> logger)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
            _logger = logger;
        }

        public async Task<NotaDebitoCompraDto> Handle(CrearNotaDebitoCompraComando request, CancellationToken cancellationToken)
        {
            var dto = request.Nota;

            // 1. Validar compra de referencia
            var compra = await _context.Compras
                .FirstOrDefaultAsync(c => c.Id == dto.IdCompraReferencia, cancellationToken);
            
            if (compra == null)
                throw new Exception("La compra de referencia no existe.");

            // 2. Mapear a Entidad
            var nota = new NotaDebitoCompra
            {
                Serie = dto.Serie,
                Numero = dto.Numero,
                TipoComprobante = "08",
                IdCompraReferencia = dto.IdCompraReferencia,
                SerieReferencia = compra.SerieComprobante,
                NumeroReferencia = compra.NumeroComprobante,
                TipoDocReferencia = "01",
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
                
                Detalles = dto.Detalles.Select(d => new NotaDebitoDetalleCompra
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
            _context.NotasDebito.Add(nota);
            await _context.SaveChangesAsync(cancellationToken);

            // 4. Inventario (Nota de Débito Compra es ENTRADA de stock)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    // TODO: Obtener AlmacenId dinámico
                    long idAlmacen = 1;

                    var success = await _inventarioServicio.RegistrarEntradaNotaDebitoAsync(
                        det.IdProducto,
                        idAlmacen,
                        det.Cantidad,
                        det.PrecioUnitario,
                        nota.Id,
                        nota.Serie,
                        nota.Numero);

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar entrada en inventario para ND Compra {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock para el producto {det.Descripcion}.");
                    }
                }
            }

            dto.Id = nota.Id;
            return dto;
        }
    }
}
