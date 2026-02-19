using MediatR;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;

namespace Inventario.API.Application.Manejadores
{
    public class EliminarMovimientosPorReferenciaManejador : IRequestHandler<EliminarMovimientosPorReferenciaComando, bool>
    {
        private readonly IInventarioDbContext _context;

        public EliminarMovimientosPorReferenciaManejador(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<bool> Handle(EliminarMovimientosPorReferenciaComando request, CancellationToken cancellationToken)
        {
            var movimientos = await _context.MovimientosInventario
                .Where(m => m.ReferenciaModulo == request.Modulo && m.IdReferencia == request.IdReferencia)
                .ToListAsync(cancellationToken);

            if (!movimientos.Any()) return true;

            foreach (var mov in movimientos)
            {
                var stock = await _context.Stocks.FirstOrDefaultAsync(s => s.Id == mov.IdStock, cancellationToken);
                if (stock != null)
                {
                    // Revertir el stock: Como es un ingreso (cantidad positiva), restamos la cantidad original
                    stock.CantidadActual -= mov.Cantidad;
                    _context.Stocks.Update(stock);
                }

                // Eliminación física del movimiento para simplificar (o desactivación lógica si se prefiere)
                _context.MovimientosInventario.Remove(mov);
            }

            await _context.SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}
