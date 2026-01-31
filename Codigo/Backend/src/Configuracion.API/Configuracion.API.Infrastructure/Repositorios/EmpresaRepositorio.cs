using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class EmpresaRepositorio : IEmpresaRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public EmpresaRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<Empresa?> ObtenerActualAsync()
        {
            return await _context.Empresas.FirstOrDefaultAsync();
        }

        public async Task ActualizarAsync(Empresa empresa)
        {
            _context.Entry(empresa).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }
    }

    public class SucursalRepositorio : ISucursalRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public SucursalRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<Sucursal?> ObtenerPorIdAsync(long id)
        {
            return await _context.Sucursales.FindAsync(id);
        }

        public async Task<Sucursal> AgregarAsync(Sucursal sucursal)
        {
            _context.Sucursales.Add(sucursal);
            await _context.SaveChangesAsync();
            return sucursal;
        }

        public async Task ActualizarAsync(Sucursal sucursal)
        {
            _context.Entry(sucursal).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Sucursal>> ObtenerTodasAsync()
        {
            return await _context.Sucursales.ToListAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var entity = await _context.Sucursales.FindAsync(id);
            if (entity != null)
            {
                _context.Sucursales.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }
    }
}
