using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class StockRepositorio : IStockRepositorio
    {
        private readonly InventarioDbContext _context;

        public StockRepositorio(InventarioDbContext context)
        {
            _context = context;
        }

        public async Task<Stock?> ObtenerPorProductoAlmacenAsync(long idProducto, long idAlmacen)
        {
            return await _context.Stocks
                .FirstOrDefaultAsync(s => s.IdProducto == idProducto && s.IdAlmacen == idAlmacen);
        }

        public async Task<IEnumerable<Stock>> ObtenerStockBajoAsync(decimal nivelMinimo)
        {
            return await _context.Stocks
                .Where(s => s.CantidadActual <= nivelMinimo)
                .ToListAsync();
        }

        public async Task<IEnumerable<Stock>> ObtenerPorAlmacenAsync(long idAlmacen)
        {
            return await _context.Stocks
                .Where(s => s.IdAlmacen == idAlmacen)
                .ToListAsync();
        }
    }
}
