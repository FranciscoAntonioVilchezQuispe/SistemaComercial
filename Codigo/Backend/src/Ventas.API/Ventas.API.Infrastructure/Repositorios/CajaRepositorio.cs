using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Ventas.API.Infrastructure.Repositorios
{
    public class CajaRepositorio : ICajaRepositorio
    {
        private readonly VentasDbContext _context;

        public CajaRepositorio(VentasDbContext context)
        {
            _context = context;
        }

        public async Task<Caja?> ObtenerPorIdAsync(long id)
        {
            return await _context.Cajas.FindAsync(id);
        }

        public async Task<Caja> AgregarAsync(Caja caja)
        {
            _context.Cajas.Add(caja);
            await _context.SaveChangesAsync();
            return caja;
        }

        public async Task ActualizarAsync(Caja caja)
        {
            _context.Entry(caja).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Caja>> ObtenerTodasAsync()
        {
            return await _context.Cajas.ToListAsync();
        }
    }
}
