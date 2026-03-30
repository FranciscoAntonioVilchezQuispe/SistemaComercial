using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Microsoft.Extensions.Logging;

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

            // 1. Validar que la venta de referencia exista
            var venta = await _context.Ventas
                .Include(v => v.Detalles)
                .FirstOrDefaultAsync(v => v.Id == dto.IdVentaReferencia, cancellationToken);
            
            if (venta == null)
                throw new Exception("La venta de referencia no existe.");

            // 2. Mapear a Entidad
            var nota = new NotaCredito
            {
                Serie = dto.Serie,
                Numero = dto.Numero,
                TipoComprobante = "07",
                IdVentaReferencia = dto.IdVentaReferencia,
                SerieReferencia = venta.Serie,
                NumeroReferencia = venta.Numero,
                TipoDocReferencia = "01", // TODO: Obtener dinámico del TipoComprobante de la venta
                IdTipoNota = dto.IdTipoNota,
                MotivoSustento = dto.MotivoSustento,
                
                ClienteTipoDoc = dto.ClienteTipoDoc,
                ClienteNroDoc = dto.ClienteNroDoc,
                ClienteRazonSocial = dto.ClienteRazonSocial,
                
                Subtotal = dto.Subtotal,
                Igv = dto.Igv,
                Total = dto.Total,
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                
                AfectaStock = dto.AfectaStock,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                Estado = "PENDIENTE",
                
                Detalles = dto.Detalles.Select(d => new NotaCreditoDetalle
                {
                    IdVentaDetalle = d.IdVentaDetalle,
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

            // 4. Actualizar Inventario si afecta stock (Nota de Crédito = Reingreso de mercadería)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    // Asumimos un AlmacenId por defecto o el de la venta original
                    // TODO: Obtener el AlmacenId correcto del detalle de venta original
                    long idAlmacen = 1; 

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

            dto.Id = nota.Id;
            return dto;
        }
    }
}
