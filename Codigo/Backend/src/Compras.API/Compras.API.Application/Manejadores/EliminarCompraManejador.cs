using MediatR;
using Microsoft.EntityFrameworkCore;
using Compras.API.Application.Comandos;
using Compras.API.Application.Interfaces;
using Compras.API.Domain.Entidades;

namespace Compras.API.Application.Manejadores
{
    public class EliminarCompraManejador : IRequestHandler<EliminarCompraComando, bool>
    {
        private readonly IComprasDbContext _context;
        private readonly IInventarioServicio _inventarioServicio;

        public EliminarCompraManejador(IComprasDbContext context, IInventarioServicio inventarioServicio)
        {
            _context = context;
            _inventarioServicio = inventarioServicio;
        }

        public async Task<bool> Handle(EliminarCompraComando request, CancellationToken cancellationToken)
        {
            var compra = await _context.Compras
                .Include(c => c.Detalles)
                .FirstOrDefaultAsync(c => c.Id == request.Id, cancellationToken);

            if (compra == null) return false;

            // 1. Desactivación Lógica
            compra.Activado = false;
            foreach (var detalle in compra.Detalles)
            {
                detalle.Activado = false;
            }

            // 2. Liberar Orden de Compra si existe
            if (compra.IdOrdenCompraRef.HasValue)
            {
                var orden = await _context.OrdenesCompra
                    .FirstOrDefaultAsync(o => o.Id == compra.IdOrdenCompraRef.Value, cancellationToken);

                if (orden != null)
                {
                    orden.CompraId = null;
                    _context.OrdenesCompra.Update(orden);
                }
            }

            _context.Compras.Update(compra);
            await _context.SaveChangesAsync(cancellationToken);

            // 3. Revertir Stock en Inventario (Eliminar movimientos)
            await _inventarioServicio.EliminarMovimientosCompraAsync(compra.Id);

            return true;
        }
    }
}
