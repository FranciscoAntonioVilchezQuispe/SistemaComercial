using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Compras.API.Infrastructure.Repositorios
{
    public class CompraRepositorio : ICompraRepositorio
    {
        private readonly ComprasDbContext _context;

        public CompraRepositorio(ComprasDbContext context)
        {
            _context = context;
        }

        public async Task<Compra?> ObtenerPorIdAsync(long id)
        {
            return await _context.Compras
                .Include(c => c.Detalles)
                .Include(c => c.Proveedor)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Compra> AgregarAsync(Compra compra)
        {
            _context.Compras.Add(compra);
            await _context.SaveChangesAsync();
            return compra;
        }

        public async Task<IEnumerable<Compra>> ObtenerTodosAsync()
        {
            return await _context.Compras.Include(c => c.Proveedor).ToListAsync();
        }

        public async Task<IEnumerable<Compra>> ObtenerPorProveedorAsync(long idProveedor)
        {
            return await _context.Compras
                .Where(c => c.IdProveedor == idProveedor)
                .ToListAsync();
        }
    }
}
