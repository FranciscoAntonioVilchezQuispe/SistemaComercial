using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;
using Compras.API.Application.Eventos;

namespace Compras.API.Application.Manejadores
{
    public class CrearCompraManejador : IRequestHandler<CrearCompraComando, long>
    {
        private readonly IComprasDbContext _context;
        private readonly IMediator _mediator;

        public CrearCompraManejador(IComprasDbContext context, IMediator mediator)
        {
            _context = context;
            _mediator = mediator;
        }

        public async Task<long> Handle(CrearCompraComando request, CancellationToken cancellationToken)
        {
            var dto = request.Compra;

            // 1. Validaciones
            // ... (resto del código se mantiene)

            // 2. Mapear a Entidad (utilizando campos existentes en Compra.cs)
            var compra = new Compra
            {
                IdProveedor = dto.IdProveedor,
                IdAlmacen = dto.IdAlmacen,
                IdOrdenCompraRef = dto.IdOrdenCompraRef,
                IdTipoComprobante = dto.IdTipoComprobante,
                SerieComprobante = dto.SerieComprobante,
                NumeroComprobante = dto.NumeroComprobante,
                FechaEmision = dto.FechaEmision == default ? DateTime.UtcNow : dto.FechaEmision,
                FechaContable = dto.FechaContable == default ? DateTime.UtcNow : dto.FechaContable,
                Moneda = dto.Moneda,
                TipoCambio = dto.TipoCambio,
                Subtotal = dto.Subtotal,
                Impuesto = dto.Impuesto,
                Total = dto.Total,
                SaldoPendiente = dto.SaldoPendiente,
                IdEstadoPago = dto.IdEstadoPago,
                Observaciones = dto.Observaciones,
                Detalles = dto.Detalles.Select(d => new DetalleCompra
                {
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    Descripcion = d.Descripcion,
                    Cantidad = d.Cantidad,
                    PrecioUnitarioCompra = d.PrecioUnitarioCompra,
                    Subtotal = d.Subtotal
                }).ToList()
            };

            // 3. Persistir
            _context.Compras.Add(compra);
            await _context.SaveChangesAsync(cancellationToken);

            // 3.1 Actualizar Orden de Compra si existe referencia
            if (dto.IdOrdenCompraRef.HasValue && dto.IdOrdenCompraRef.Value > 0)
            {
                var orden = await _context.OrdenesCompra.FirstOrDefaultAsync(o => o.Id == dto.IdOrdenCompraRef.Value, cancellationToken);
                if (orden != null)
                {
                    orden.CompraId = compra.Id;
                    _context.OrdenesCompra.Update(orden);
                    await _context.SaveChangesAsync(cancellationToken);
                }
            }

            // 4. Publicar evento para actualizar inventario
            var evento = new CompraCreadaEvento(
                compra.Id,
                compra.IdAlmacen,
                compra.Detalles.Select(d => new CompraItemDetalle(d.IdProducto, d.Cantidad, d.PrecioUnitarioCompra)).ToList()

            );

            await _mediator.Publish(evento, cancellationToken);

            return compra.Id;
        }
    }
}
