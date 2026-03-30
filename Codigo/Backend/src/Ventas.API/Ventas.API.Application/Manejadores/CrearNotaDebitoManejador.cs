using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Microsoft.Extensions.Logging;

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

            // 1. Validar venta de referencia
            var venta = await _context.Ventas
                .FirstOrDefaultAsync(v => v.Id == dto.IdVentaReferencia, cancellationToken);
            
            if (venta == null)
                throw new Exception("La venta de referencia no existe.");

            // 2. Mapear a Entidad
            var nota = new NotaDebito
            {
                Serie = dto.Serie,
                Numero = dto.Numero,
                TipoComprobante = "08",
                IdVentaReferencia = dto.IdVentaReferencia,
                SerieReferencia = venta.Serie,
                NumeroReferencia = venta.Numero,
                TipoDocReferencia = "01",
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
                
                Detalles = dto.Detalles.Select(d => new NotaDebitoDetalle
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
            _context.NotasDebito.Add(nota);
            await _context.SaveChangesAsync(cancellationToken);

            // 4. Actualizar Inventario si afecta stock (Nota de Débito = Salida por incremento de cantidad/precio que exige más stock?)
            if (nota.AfectaStock)
            {
                foreach (var det in nota.Detalles)
                {
                    long idAlmacen = 1; // TODO: Obtener dinámico

                    var success = await _inventarioServicio.RegistrarSalidaNotaDebitoAsync(
                        det.IdProducto, 
                        idAlmacen, 
                        det.Cantidad, 
                        nota.Id, 
                        nota.Serie, 
                        nota.Numero.ToString());

                    if (!success)
                    {
                        _logger.LogError("No se pudo registrar salida en inventario para ND {NotaId}, Producto {ProdId}", nota.Id, det.IdProducto);
                        throw new Exception($"Error al actualizar stock por Nota de Débito.");
                    }
                }
            }

            dto.Id = nota.Id;
            return dto;
        }
    }
}
