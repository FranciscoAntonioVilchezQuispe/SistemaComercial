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

        public async Task<IEnumerable<Proveedor>> ObtenerTodosAsync()
        {
            return await _context.Proveedores.ToListAsync();
        }
    }
}
