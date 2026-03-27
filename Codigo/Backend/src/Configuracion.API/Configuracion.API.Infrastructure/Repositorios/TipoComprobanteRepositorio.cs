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

        public async Task<(IEnumerable<TipoComprobante>, int)> ObtenerPaginadoAsync(string? search, bool? activo, string? modulo, int pageNumber, int pageSize)
        {
            var query = _context.TiposComprobante.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                query = query.Where(t => t.Nombre.Contains(search) || t.Codigo.Contains(search));
            }

            if (activo.HasValue)
            {
                query = query.Where(t => t.Activado == activo.Value);
            }

            if (!string.IsNullOrEmpty(modulo))
            {
                var mod = modulo.ToUpper();
                if (mod == "COMPRA") query = query.Where(t => t.EsCompra);
                else if (mod == "VENTA") query = query.Where(t => t.EsVenta);
                else if (mod == "ORDEN_COMPRA") query = query.Where(t => t.EsOrdenCompra);
            }

            int total = await query.CountAsync();
            var datos = await query
                .OrderBy(t => t.Nombre)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
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
