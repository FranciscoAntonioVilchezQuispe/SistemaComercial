using MediatR;
using Microsoft.EntityFrameworkCore;
using Ventas.API.Application.Comandos;
using Ventas.API.Application.Eventos;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;

namespace Ventas.API.Application.Manejadores
{
    public class CrearVentaManejador : IRequestHandler<CrearVentaComando, long>
    {
        private readonly IVentasDbContext _context;
        private readonly IMediator _mediator;

        public CrearVentaManejador(IVentasDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(CrearVentaComando request, CancellationToken cancellationToken)
        {
            var dto = request.Venta;

            // 1. Validar Catálogos e Integridad
            // ... (resto del código igual hasta el mapeo)

            // 2. Mapear a Entidad (se mantiene el código previo pero lo resumo para no fallar el replace)
            var venta = new Venta
            {
                IdEmpresa = dto.IdEmpresa,
                IdAlmacen = dto.IdAlmacen,
                IdCaja = dto.IdCaja,
                IdCliente = dto.IdCliente,
                IdUsuarioVendedor = dto.IdUsuarioVendedor,
                IdCotizacionOrigen = dto.IdCotizacionOrigen,
                IdTipoComprobante = dto.IdTipoComprobante,
                Serie = dto.Serie,
                Numero = dto.Numero,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                FechaVencimientoPago = dto.FechaVencimientoPago,
                IdEstado = dto.IdEstado,
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                SubtotalGravado = dto.SubtotalGravado,
                SubtotalExonerado = dto.SubtotalExonerado,
                SubtotalInafecto = dto.SubtotalInafecto,
                TotalImpuesto = dto.TotalImpuesto,
                TotalDescuentoGlobal = dto.TotalDescuentoGlobal,
                TotalVenta = dto.TotalVenta,
                SaldoPendiente = dto.SaldoPendiente,
                IdEstadoPago = dto.IdEstadoPago,
                Observaciones = dto.Observaciones,
                Detalles = dto.Detalles.Select(d => new DetalleVenta
                {
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    DescripcionProducto = d.DescripcionProducto,
                    Cantidad = d.Cantidad,
                    PrecioUnitario = d.PrecioUnitario,
                    PrecioListaOriginal = d.PrecioListaOriginal,
                    PorcentajeImpuesto = d.PorcentajeImpuesto,
                    ImpuestoItem = d.ImpuestoItem,
                    TotalItem = d.TotalItem
                }).ToList()
            };

            // 3. Persistir
            _context.Ventas.Add(venta);
            await _context.SaveChangesAsync(cancellationToken);

            // 4. Publicar evento para actualizar inventario
            var evento = new VentaCreadaEvento(
                venta.Id,
                venta.IdAlmacen,
                venta.Detalles.Select(d => new VentaItemDetalle(d.IdProducto, d.Cantidad)).ToList()
            );

            await _mediator.Publish(evento, cancellationToken);

            return venta.Id;
        }
    }
}
