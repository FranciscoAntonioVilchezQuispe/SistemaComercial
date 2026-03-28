using MediatR;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Application.Comandos;
using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Interfaces;

namespace Inventario.API.Application.Manejadores
{
    public class EliminarMovimientosPorReferenciaManejador : IRequestHandler<EliminarMovimientosPorReferenciaComando, bool>
    {
        private readonly IInventarioDbContext _context;
        private readonly IKardexService _kardexService;
        private readonly IKardexMovimientoRepositorio _kardexRepo;

        public EliminarMovimientosPorReferenciaManejador(
            IInventarioDbContext context, 
            IKardexService kardexService,
            IKardexMovimientoRepositorio kardexRepo)
        {
            _context = context;
            _kardexService = kardexService;
            _kardexRepo = kardexRepo;
        }

        public async Task<bool> Handle(EliminarMovimientosPorReferenciaComando request, CancellationToken cancellationToken)
        {
            var movimientos = await _context.MovimientosInventario
                .Where(m => m.ReferenciaModulo == request.Modulo && m.IdReferencia == request.IdReferencia)
                .ToListAsync(cancellationToken);

            if (!movimientos.Any()) return true;

            // 1. Obtener movimientos de Kardex relacionados ANTES de eliminar los de inventario
            var kardexMovs = await _kardexRepo.ObtenerPorReferenciaAsync(request.IdReferencia, request.Modulo);

            foreach (var mov in movimientos)
            {
                var stock = await _context.Stocks.FirstOrDefaultAsync(s => s.Id == mov.IdStock, cancellationToken);
                if (stock != null)
                {
                    // Revertir el stock: Restamos cantidad y valor
                    stock.CantidadActual -= mov.Cantidad;
                    stock.ValorTotal -= (mov.Cantidad * (mov.CostoUnitarioMovimiento ?? 0));
                    
                    if (stock.CantidadActual > 0)
                        stock.CostoPromedio = Math.Round(stock.ValorTotal / stock.CantidadActual, 4);
                    else
                    {
                        stock.CantidadActual = 0;
                        stock.ValorTotal = 0;
                        stock.CostoPromedio = 0;
                    }
                    _context.Stocks.Update(stock);
                }

                // Eliminación física del movimiento
                _context.MovimientosInventario.Remove(mov);
            }

            // 2. Anular Kardex relacionado
            foreach (var kMov in kardexMovs.Where(k => !k.Anulado))
            {
                try 
                {
                    await _kardexService.AnularMovimientoAsync(
                        kMov.Id, 
                        $"Anulación automática por eliminación de {request.Modulo} #{request.IdReferencia}", 
                        1 // Usuario Sistema
                    );
                }
                catch (Exception ex)
                {
                    // Loggeamos pero continuamos para no bloquear la eliminación si el periodo ya está cerrado (aunque sería ideal fallar)
                    Console.WriteLine($"[WARN] No se pudo anular registro Kardex {kMov.Id}: {ex.Message}");
                }
            }

            await _context.SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}
