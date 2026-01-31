using Configuracion.API.Application.Interfaces;
using Configuracion.API.Domain.Entidades;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;

namespace Configuracion.API.Infrastructure.Repositorios
{
    /// <summary>
    /// Implementación del repositorio para TablaGeneral
    /// </summary>
    public class TablaGeneralRepositorio : ITablaGeneralRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public TablaGeneralRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<List<TablaGeneral>> ObtenerTodosAsync()
        {
            return await _context.TablasGenerales
                .Where(tg => tg.Activado)
                .Include(tg => tg.Detalles.Where(d => d.Activado && d.Estado))
                .OrderBy(tg => tg.Nombre)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<TablaGeneral?> ObtenerPorCodigoAsync(string codigo, bool incluirInactivos = false)
        {
            var query = _context.TablasGenerales
                .Where(tg => tg.Codigo == codigo && tg.Activado);

            if (incluirInactivos)
            {
                query = query.Include(tg => tg.Detalles.Where(d => d.Activado));
            }
            else
            {
                query = query.Include(tg => tg.Detalles.Where(d => d.Activado && d.Estado));
            }

            return await query
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        public async Task<List<TablaGeneralDetalle>> ObtenerValoresPorCodigoAsync(string codigo, bool incluirInactivos = false)
        {
            var query = _context.TablasGeneralesDetalles
                .Where(tgd => tgd.TablaGeneral.Codigo == codigo && tgd.Activado);

            if (!incluirInactivos)
            {
                query = query.Where(tgd => tgd.Estado);
            }

            return await query
                .OrderBy(tgd => tgd.Orden)
                .ThenBy(tgd => tgd.Nombre)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<TablaGeneralDetalle?> ObtenerValorPorIdAsync(long idDetalle)
        {
            return await _context.TablasGeneralesDetalles
                .Where(tgd => tgd.Id == idDetalle && tgd.Activado)
                .AsNoTracking()
                .FirstOrDefaultAsync();
        }

        public async Task<TablaGeneral?> ObtenerPorIdAsync(long id)
        {
            return await _context.TablasGenerales
                .Include(tg => tg.Detalles.Where(d => d.Activado))
                .FirstOrDefaultAsync(tg => tg.Id == id && tg.Activado);
        }

        public async Task<TablaGeneral> AgregarAsync(TablaGeneral entidad)
        {
            await _context.TablasGenerales.AddAsync(entidad);
            await _context.SaveChangesAsync();
            return entidad;
        }

        public async Task ActualizarAsync(TablaGeneral entidad)
        {
            _context.TablasGenerales.Update(entidad);
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entidad = await _context.TablasGenerales.FindAsync(id);
            if (entidad != null)
            {
                entidad.Activado = false; // Soft Delete
                await _context.SaveChangesAsync();
            }
        }

        public async Task<TablaGeneralDetalle> AgregarDetalleAsync(TablaGeneralDetalle entidad)
        {
            await _context.TablasGeneralesDetalles.AddAsync(entidad);
            await _context.SaveChangesAsync();
            return entidad;
        }

        public async Task ActualizarDetalleAsync(TablaGeneralDetalle entidad)
        {
            _context.TablasGeneralesDetalles.Update(entidad);
            await _context.SaveChangesAsync();
        }

        public async Task EliminarDetalleAsync(long id)
        {
            var entidad = await _context.TablasGeneralesDetalles.FindAsync(id);
            if (entidad != null)
            {
                entidad.Activado = false; // Soft Delete
                await _context.SaveChangesAsync();
            }
        }
    }
}
