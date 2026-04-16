using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class TipoTributoRepositorio : ITipoTributoRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public TipoTributoRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<TipoTributo?> ObtenerPorIdAsync(long id)
        {
            return await _context.TiposTributo.FindAsync(id);
        }

        public async Task<TipoTributo?> ObtenerPorCodigoAsync(string codigo)
        {
            return await _context.TiposTributo
                .FirstOrDefaultAsync(x => x.Codigo == codigo);
        }

        public async Task<TipoTributo> AgregarAsync(TipoTributo tributo)
        {
            _context.TiposTributo.Add(tributo);
            await _context.SaveChangesAsync();
            return tributo;
        }

        public async Task ActualizarAsync(TipoTributo tributo)
        {
            _context.Entry(tributo).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<TipoTributo>> ObtenerTodosAsync()
        {
            return await _context.TiposTributo
                .OrderBy(x => x.Codigo)
                .ToListAsync();
        }

        public async Task<(IEnumerable<TipoTributo> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var query = _context.TiposTributo.AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                query = query.Where(x => x.Nombre.ToLower().Contains(search) || x.Codigo.ToLower().Contains(search));
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
            var entity = await _context.TiposTributo.FindAsync(id);
            if (entity != null)
            {
                _context.TiposTributo.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task InicializarAsync()
        {
            var semillas = new List<TipoTributo>
            {
                new TipoTributo { Codigo = "1000", Nombre = "IGV", CodigoInternacional = "VAT", Descripcion = "Impuesto General a las Ventas", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "2000", Nombre = "ISC", CodigoInternacional = "EXC", Descripcion = "Impuesto Selectivo al Consumo", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "9995", Nombre = "EXP", CodigoInternacional = "FRE", Descripcion = "Exportación", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "9996", Nombre = "GRA", CodigoInternacional = "FRE", Descripcion = "Gratuito", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "9997", Nombre = "EXO", CodigoInternacional = "VAT", Descripcion = "Exonerado", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "9998", Nombre = "INA", CodigoInternacional = "FRE", Descripcion = "Inafecto", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "1016", Nombre = "IVAP", CodigoInternacional = "VAT", Descripcion = "Impuesto al Valor Arroz Pilado", Activado = true, UsuarioCreacion = "SISTEMA" },
                new TipoTributo { Codigo = "7152", Nombre = "ICBPER", CodigoInternacional = "OTH", Descripcion = "Impuesto a la Bolsa de Plástico", Activado = true, UsuarioCreacion = "SISTEMA" }
            };

            foreach (var s in semillas)
            {
                if (!await _context.TiposTributo.AnyAsync(x => x.Codigo == s.Codigo))
                {
                    _context.TiposTributo.Add(s);
                }
            }

            await _context.SaveChangesAsync();
        }
    }
}
