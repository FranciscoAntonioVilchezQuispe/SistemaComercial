using Contabilidad.API.Domain.Entidades;
using Contabilidad.API.Domain.Interfaces;
using Contabilidad.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Dapper;
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

        public async Task<(IEnumerable<PlanCuenta> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int? nivel, int pagina, int elementosPorPagina)
        {
            var connection = _context.Database.GetDbConnection();
            var offset = (pagina - 1) * elementosPorPagina;
            
            var sqlBase = "FROM contabilidad.plan_cuentas WHERE 1=1";
            var parameters = new DynamicParameters();

            if (!string.IsNullOrEmpty(busqueda))
            {
                sqlBase += " AND (nombre ILIKE @busqueda OR codigo ILIKE @busqueda)";
                parameters.Add("busqueda", $"%{busqueda}%");
            }

            if (nivel.HasValue)
            {
                sqlBase += " AND nivel = @nivel";
                parameters.Add("nivel", nivel.Value);
            }

            var sqlCount = $"SELECT COUNT(*) {sqlBase}";
            var sqlData = $"SELECT * {sqlBase} ORDER BY codigo OFFSET @offset LIMIT @limit";
            
            parameters.Add("offset", offset);
            parameters.Add("limit", elementosPorPagina);

            var total = await connection.ExecuteScalarAsync<int>(sqlCount, parameters);
            var datos = await connection.QueryAsync<PlanCuenta>(sqlData, parameters);

            return (datos, total);
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

        public async Task<(IEnumerable<CentroCosto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int pagina, int elementosPorPagina)
        {
            var connection = _context.Database.GetDbConnection();
            var offset = (pagina - 1) * elementosPorPagina;
            
            var sqlBase = "FROM contabilidad.centros_costo WHERE 1=1";
            var parameters = new DynamicParameters();

            if (!string.IsNullOrEmpty(busqueda))
            {
                sqlBase += " AND (nombre ILIKE @busqueda OR codigo ILIKE @busqueda)";
                parameters.Add("busqueda", $"%{busqueda}%");
            }

            var sqlCount = $"SELECT COUNT(*) {sqlBase}";
            var sqlData = $"SELECT * {sqlBase} ORDER BY codigo OFFSET @offset LIMIT @limit";
            
            parameters.Add("offset", offset);
            parameters.Add("limit", elementosPorPagina);

            var total = await connection.ExecuteScalarAsync<int>(sqlCount, parameters);
            var datos = await connection.QueryAsync<CentroCosto>(sqlData, parameters);

            return (datos, total);
        }
    }
}
