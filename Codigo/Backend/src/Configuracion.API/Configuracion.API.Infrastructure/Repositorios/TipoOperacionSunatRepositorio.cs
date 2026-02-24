using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class TipoOperacionSunatRepositorio : ITipoOperacionSunatRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public TipoOperacionSunatRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TipoOperacionSunat>> ObtenerTodosAsync()
        {
            return await _context.TiposOperacionSunat
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<TipoOperacionSunat?> ObtenerPorIdAsync(long id)
        {
            return await _context.TiposOperacionSunat.FindAsync(id);
        }

        public async Task<TipoOperacionSunat?> ObtenerPorCodigoAsync(string codigo)
        {
            return await _context.TiposOperacionSunat
                .FirstOrDefaultAsync(x => x.Codigo == codigo);
        }

        public async Task<TipoOperacionSunat> AgregarAsync(TipoOperacionSunat tipoOperacion)
        {
            await _context.TiposOperacionSunat.AddAsync(tipoOperacion);
            await _context.SaveChangesAsync();
            return tipoOperacion;
        }

        public async Task ActualizarAsync(TipoOperacionSunat tipoOperacion)
        {
            _context.Entry(tipoOperacion).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var tipoOperacion = await _context.TiposOperacionSunat.FindAsync(id);
            if (tipoOperacion != null)
            {
                _context.TiposOperacionSunat.Remove(tipoOperacion);
                await _context.SaveChangesAsync();
            }
        }
    }
}
