using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class AlmacenRepositorio : IAlmacenRepositorio
    {
        private readonly InventarioDbContext _context;

        public AlmacenRepositorio(InventarioDbContext context)
        {
            _context = context;
        }

        public async Task<Almacen?> ObtenerPorIdAsync(long id)
        {
            return await _context.Almacenes.FindAsync(id);
        }

        public async Task<Almacen> AgregarAsync(Almacen almacen)
        {
            _context.Almacenes.Add(almacen);
            await _context.SaveChangesAsync();
            return almacen;
        }

        public async Task ActualizarAsync(Almacen almacen)
        {
            _context.Entry(almacen).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Almacen>> ObtenerTodosAsync()
        {
            return await _context.Almacenes.ToListAsync();
        }
    }
}
