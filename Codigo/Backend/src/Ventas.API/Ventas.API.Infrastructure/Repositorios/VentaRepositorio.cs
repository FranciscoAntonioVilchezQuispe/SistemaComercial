using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Ventas.API.Infrastructure.Repositorios
{
    public class VentaRepositorio : IVentaRepositorio
    {
        private readonly VentasDbContext _context;

        public VentaRepositorio(VentasDbContext context)
        {
            _context = context;
        }

        public async Task<Venta?> ObtenerPorIdAsync(long id)
        {
            return await _context.Ventas
                .Include(v => v.Detalles)
                .Include(v => v.Cliente)
                .FirstOrDefaultAsync(v => v.Id == id);
        }

        public async Task<Venta> AgregarAsync(Venta venta)
        {
            _context.Ventas.Add(venta);
            await _context.SaveChangesAsync();
            return venta;
        }

        public async Task<IEnumerable<Venta>> ObtenerTodasAsync()
        {
            return await _context.Ventas
                .Include(v => v.Cliente)
                .ToListAsync();
        }

        public async Task<(IEnumerable<Venta> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var query = _context.Ventas
                .Include(v => v.Cliente)
                .AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                query = query.Where(v => 
                    v.Serie.ToLower().Contains(search) || 
                    v.Numero.ToLower().Contains(search) ||
                    v.Cliente.RazonSocial.ToLower().Contains(search));
            }

            var total = await query.CountAsync();
            var datos = await query
                .OrderByDescending(v => v.FechaEmision)
                .ThenByDescending(v => v.Id)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
        }
    }

    public class CotizacionRepositorio : ICotizacionRepositorio
    {
        private readonly VentasDbContext _context;

        public CotizacionRepositorio(VentasDbContext context)
        {
            _context = context;
        }

        public async Task<Cotizacion?> ObtenerPorIdAsync(long id)
        {
            return await _context.Cotizaciones
                .Include(c => c.Detalles)
                .Include(c => c.Cliente)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Cotizacion> AgregarAsync(Cotizacion cotizacion)
        {
            _context.Cotizaciones.Add(cotizacion);
            await _context.SaveChangesAsync();
            return cotizacion;
        }

        public async Task<IEnumerable<Cotizacion>> ObtenerTodasAsync()
        {
            return await _context.Cotizaciones
                .Include(c => c.Cliente)
                .ToListAsync();
        }

        public async Task<(IEnumerable<Cotizacion> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var query = _context.Cotizaciones
                .Include(c => c.Cliente)
                .AsQueryable();

            if (!string.IsNullOrEmpty(search))
            {
                search = search.ToLower();
                query = query.Where(c => 
                    c.Serie.ToLower().Contains(search) || 
                    c.Numero.ToLower().Contains(search) ||
                    c.Cliente.RazonSocial.ToLower().Contains(search));
            }

            var total = await query.CountAsync();
            var datos = await query
                .OrderByDescending(c => c.FechaEmision)
                .ThenByDescending(c => c.Id)
                .Skip((pageNumber - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return (datos, total);
        }
    }
}
