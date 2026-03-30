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
                // 3.1 Obtener el tipo de movimiento para saber si fue ENTRADA o SALIDA
                var tipoMov = await _context.TiposMovimiento.FirstOrDefaultAsync(t => t.Id == mov.IdTipoMovimiento, cancellationToken);
                if (tipoMov == null) continue;

                // 3.2 Determinar Factor de Reversión
                // Si el original fue SUMA (ING_COM, etc.), la reversión es RESTA (-1)
                // Si el original fue RESTA (SAL_VEN, etc.), la reversión es SUMA (1)
                decimal factorReversion = 0;
                switch (tipoMov.Codigo)
                {
                    case "ING_COM":
                    case "AJU_POS":
                    case "INV_INI":
                    case "ING_TRA":
                        factorReversion = -1; // Revertir ingreso = Restar
                        break;
                    case "SAL_VEN":
                    case "AJU_NEG":
                    case "TRA_ALM":
                        factorReversion = 1; // Revertir salida = Sumar
                        break;
                }

                var stock = await _context.Stocks.FirstOrDefaultAsync(s => s.Id == mov.IdStock, cancellationToken);
                if (stock != null)
                {
                    decimal cantidadARevertir = mov.Cantidad * factorReversion;
                    
                    // Revertir el stock: Aplicamos el factor de reversión
                    stock.CantidadActual += cantidadARevertir;
                    
                    // Revertir Valorizado (Aproximado por CPP del movimiento)
                    decimal costoUnitario = mov.CostoUnitarioMovimiento ?? stock.CostoPromedio;
                    stock.ValorTotal += (cantidadARevertir * costoUnitario);
                    
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
