using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class TipoAfectacionIgvRepositorio : ITipoAfectacionIgvRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public TipoAfectacionIgvRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<TipoAfectacionIgv?> ObtenerPorIdAsync(long id)
        {
            return await _context.TiposAfectacionIgv.FindAsync(id);
        }

        public async Task<TipoAfectacionIgv?> ObtenerPorCodigoAsync(string codigo)
        {
            return await _context.TiposAfectacionIgv
                .FirstOrDefaultAsync(x => x.Codigo == codigo);
        }

        public async Task<TipoAfectacionIgv> AgregarAsync(TipoAfectacionIgv afectacion)
        {
            _context.TiposAfectacionIgv.Add(afectacion);
            await _context.SaveChangesAsync();
            return afectacion;
        }

        public async Task ActualizarAsync(TipoAfectacionIgv afectacion)
        {
            _context.Entry(afectacion).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<TipoAfectacionIgv>> ObtenerTodosAsync()
        {
            return await _context.TiposAfectacionIgv
                .OrderBy(x => x.Codigo)
                .ToListAsync();
        }

        public async Task<(IEnumerable<TipoAfectacionIgv> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var query = _context.TiposAfectacionIgv.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                query = query.Where(x => x.Descripcion.ToLower().Contains(search) || x.Codigo.ToLower().Contains(search));
            }

            var total = await query.CountAsync();
            var datos = await query
                .OrderBy(x => x.Codigo)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.TiposAfectacionIgv.FindAsync(id);
            if (entity != null)
            {
                _context.TiposAfectacionIgv.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task InicializarAsync()
        {
            var semillas = new List<TipoAfectacionIgv>
            {
                new TipoAfectacionIgv { Codigo = "10", Descripcion = "Gravado - Operación Onerosa", EsGravado = true, CodigoTributoDefault = "1000", NombreTributoDefault = "IGV", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoAfectacionIgv { Codigo = "11", Descripcion = "Gravado - Retiro por Premio", EsGravado = true, EsGratuito = true, CodigoTributoDefault = "1000", NombreTributoDefault = "IGV", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoAfectacionIgv { Codigo = "20", Descripcion = "Exonerado - Operación Onerosa", EsExonerado = true, CodigoTributoDefault = "9997", NombreTributoDefault = "EXO", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoAfectacionIgv { Codigo = "30", Descripcion = "Inafecto - Operación Onerosa", EsInafecto = true, CodigoTributoDefault = "9998", NombreTributoDefault = "INA", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoAfectacionIgv { Codigo = "40", Descripcion = "Exportación de Bienes o Servicios", CodigoTributoDefault = "9995", NombreTributoDefault = "EXP", Activado = true, UsuarioCreacion = "SISTEMA" }
            };

            foreach (var s in semillas)
            {
                if (!await _context.TiposAfectacionIgv.AnyAsync(x => x.Codigo == s.Codigo))
                {
                    _context.TiposAfectacionIgv.Add(s);
                }
            }

            await _context.SaveChangesAsync();
        }
    }
}
