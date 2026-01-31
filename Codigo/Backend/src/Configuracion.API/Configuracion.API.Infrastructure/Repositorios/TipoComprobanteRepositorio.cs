using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class TipoComprobanteRepositorio : ITipoComprobanteRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public TipoComprobanteRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<TipoComprobante?> ObtenerPorIdAsync(long id)
        {
            return await _context.TiposComprobante.FindAsync(id);
        }

        public async Task<TipoComprobante> AgregarAsync(TipoComprobante tipo)
        {
            _context.TiposComprobante.Add(tipo);
            await _context.SaveChangesAsync();
            return tipo;
        }

        public async Task ActualizarAsync(TipoComprobante tipo)
        {
            _context.Entry(tipo).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<TipoComprobante>> ObtenerTodosAsync()
        {
            return await _context.TiposComprobante.ToListAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.TiposComprobante.FindAsync(id);
            if (entity != null)
            {
                _context.TiposComprobante.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
