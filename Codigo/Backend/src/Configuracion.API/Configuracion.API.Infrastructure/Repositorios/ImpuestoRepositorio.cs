using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class ImpuestoRepositorio : IImpuestoRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public ImpuestoRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<Impuesto?> ObtenerPorIdAsync(long id)
        {
            return await _context.Impuestos.FindAsync(id);
        }

        public async Task<Impuesto> AgregarAsync(Impuesto impuesto)
        {
            _context.Impuestos.Add(impuesto);
            await _context.SaveChangesAsync();
            return impuesto;
        }

        public async Task ActualizarAsync(Impuesto impuesto)
        {
            _context.Entry(impuesto).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Impuesto>> ObtenerTodosAsync()
        {
            return await _context.Impuestos.ToListAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.Impuestos.FindAsync(id);
            if (entity != null)
            {
                _context.Impuestos.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }

    public class MetodoPagoRepositorio : IMetodoPagoRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public MetodoPagoRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<MetodoPago?> ObtenerPorIdAsync(long id)
        {
            return await _context.MetodosPago.FindAsync(id);
        }

        public async Task<MetodoPago> AgregarAsync(MetodoPago metodo)
        {
            _context.MetodosPago.Add(metodo);
            await _context.SaveChangesAsync();
            return metodo;
        }

        public async Task ActualizarAsync(MetodoPago metodo)
        {
            _context.Entry(metodo).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<MetodoPago>> ObtenerTodosAsync()
        {
            return await _context.MetodosPago.ToListAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.MetodosPago.FindAsync(id);
            if (entity != null)
            {
                _context.MetodosPago.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
