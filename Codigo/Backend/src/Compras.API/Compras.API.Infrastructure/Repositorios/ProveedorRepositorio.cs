using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Compras.API.Infrastructure.Repositorios
{
    public class ProveedorRepositorio : IProveedorRepositorio
    {
        private readonly ComprasDbContext _context;

        public ProveedorRepositorio(ComprasDbContext context)
        {
            _context = context;
        }

        public async Task<Proveedor?> ObtenerPorIdAsync(long id)
        {
            return await _context.Proveedores.FindAsync(id);
        }

        public async Task<Proveedor> AgregarAsync(Proveedor proveedor)
        {
            _context.Proveedores.Add(proveedor);
            await _context.SaveChangesAsync();
            return proveedor;
        }

        public async Task ActualizarAsync(Proveedor proveedor)
        {
            _context.Entry(proveedor).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var proveedor = await _context.Proveedores.FindAsync(id);
            if (proveedor != null)
            {
                _context.Proveedores.Remove(proveedor);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Proveedor>> ObtenerTodosAsync(string? busqueda = null)
        {
            var query = _context.Proveedores.AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var term = busqueda.Trim().ToLower();
                query = query.Where(p =>
                    p.RazonSocial.ToLower().Contains(term) ||
                    p.NumeroDocumento.Contains(term));
            }

            // Limit results to avoid performance issues if no search term, or just limit generally
            if (string.IsNullOrWhiteSpace(busqueda))
            {
                // Optional: Return empty or limited list if no search to prevent massive load
                // For now, we will return empty list if no search to force user to search
                // Or limit to top 20
                return await query.Take(20).ToListAsync();
            }

            return await query.ToListAsync();
        }
    }
}
