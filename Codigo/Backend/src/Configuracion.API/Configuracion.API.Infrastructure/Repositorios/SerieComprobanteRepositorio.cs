using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class SerieComprobanteRepositorio : ISerieComprobanteRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public SerieComprobanteRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<SerieComprobante?> ObtenerPorIdAsync(long id)
        {
            return await _context.SeriesComprobantes.FindAsync(id);
        }

        public async Task<SerieComprobante> AgregarAsync(SerieComprobante serie)
        {
            _context.SeriesComprobantes.Add(serie);
            await _context.SaveChangesAsync();
            return serie;
        }

        public async Task ActualizarAsync(SerieComprobante serie)
        {
            _context.Entry(serie).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<SerieComprobante>> ObtenerTodasAsync()
        {
            return await _context.SeriesComprobantes.ToListAsync();
        }

        public async Task<(IEnumerable<SerieComprobante>, int)> ObtenerPaginadoAsync(string? search, bool? activo, int pageNumber, int pageSize)
        {
            var query = _context.SeriesComprobantes.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(s => s.Serie.Contains(search));
            }

            // Nota: SerieComprobante no parece tener activado/desactivado en la entidad vista, 
            // pero mantengo el parámetro por consistencia si se añade luego.

            int total = await query.CountAsync();
            var datos = await query
                .OrderBy(s => s.IdTipoComprobante)
                .ThenBy(s => s.Serie)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
        }

        public async Task<IEnumerable<SerieComprobante>> ObtenerPorTipoAsync(long idTipoComprobante)
        {
            return await _context.SeriesComprobantes
                .Where(s => s.IdTipoComprobante == idTipoComprobante)
                .ToListAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.SeriesComprobantes.FindAsync(id);
            if (entity != null)
            {
                _context.SeriesComprobantes.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
