using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class UnidadMedidaRepositorio : IUnidadMedidaRepositorio
    {
        private readonly CatalogoDbContext _context;

        public UnidadMedidaRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<UnidadMedida?> ObtenerPorIdAsync(long id)
        {
            return await _context.UnidadesMedida.FindAsync(id);
        }

        public async Task<UnidadMedida> AgregarAsync(UnidadMedida unidad)
        {
            _context.UnidadesMedida.Add(unidad);
            await _context.SaveChangesAsync();
            return unidad;
        }

        public async Task ActualizarAsync(UnidadMedida unidad)
        {
            _context.Entry(unidad).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var unidad = await _context.UnidadesMedida.FindAsync(id);
            if (unidad != null)
            {
                _context.UnidadesMedida.Remove(unidad);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<UnidadMedida>> ObtenerTodosAsync()
        {
            return await _context.UnidadesMedida.ToListAsync();
        }
    }
}
