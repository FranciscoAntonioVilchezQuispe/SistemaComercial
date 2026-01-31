using Contabilidad.API.Domain.Entidades;
using Contabilidad.API.Domain.Interfaces;
using Contabilidad.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Contabilidad.API.Infrastructure.Repositorios
{
    public class PlanCuentaRepositorio : IPlanCuentaRepositorio
    {
        private readonly ContabilidadDbContext _context;

        public PlanCuentaRepositorio(ContabilidadDbContext context)
        {
            _context = context;
        }

        public async Task<PlanCuenta?> ObtenerPorIdAsync(long id)
        {
            return await _context.PlanCuentas
                .Include(c => c.SubCuentas)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<PlanCuenta> AgregarAsync(PlanCuenta cuenta)
        {
            _context.PlanCuentas.Add(cuenta);
            await _context.SaveChangesAsync();
            return cuenta;
        }

        public async Task ActualizarAsync(PlanCuenta cuenta)
        {
            _context.Entry(cuenta).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<PlanCuenta>> ObtenerTodasAsync()
        {
            return await _context.PlanCuentas.ToListAsync();
        }

        public async Task<IEnumerable<PlanCuenta>> ObtenerPorNivelAsync(int nivel)
        {
            return await _context.PlanCuentas
                .Where(c => c.Nivel == nivel)
                .ToListAsync();
        }
    }

    public class CentroCostoRepositorio : ICentroCostoRepositorio
    {
        private readonly ContabilidadDbContext _context;

        public CentroCostoRepositorio(ContabilidadDbContext context)
        {
            _context = context;
        }

        public async Task<CentroCosto?> ObtenerPorIdAsync(long id)
        {
            return await _context.CentrosCosto.FindAsync(id);
        }

        public async Task<CentroCosto> AgregarAsync(CentroCosto centro)
        {
            _context.CentrosCosto.Add(centro);
            await _context.SaveChangesAsync();
            return centro;
        }

        public async Task ActualizarAsync(CentroCosto centro)
        {
            _context.Entry(centro).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<CentroCosto>> ObtenerTodosAsync()
        {
            return await _context.CentrosCosto.ToListAsync();
        }
    }
}
