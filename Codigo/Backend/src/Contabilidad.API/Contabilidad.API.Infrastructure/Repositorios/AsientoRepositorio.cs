using Contabilidad.API.Domain.Entidades;
using Contabilidad.API.Domain.Interfaces;
using Contabilidad.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Contabilidad.API.Domain.DTOs;
using System.Data;

namespace Contabilidad.API.Infrastructure.Repositorios
{
    public class AsientoRepositorio : IAsientoRepositorio
    {
        private readonly ContabilidadDbContext _context;

        public AsientoRepositorio(ContabilidadDbContext context)
        {
            _context = context;
        }

        public async Task<AsientoDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                -- Cabecera del Asiento
                SELECT a.id_asiento as Id, a.fecha_contable, a.periodo, a.glosa, a.origen_modulo,
                       a.id_origen_referencia, a.id_estado, a.total_debe, a.total_haber
                FROM contabilidad.asientos_contables a
                WHERE a.id_asiento = @id;

                -- Detalles del Asiento con Cuentas y Centros de Costo
                SELECT da.id_detalle_asiento as Id, da.id_cuenta, pc.codigo as CuentaCodigo, pc.nombre as CuentaNombre,
                       da.id_centro_costo, cc.nombre as CentroCostoNombre,
                       da.debe, da.haber, da.nota
                FROM contabilidad.detalle_asiento da
                INNER JOIN contabilidad.plan_cuentas pc ON pc.id_cuenta = da.id_cuenta
                LEFT JOIN contabilidad.centros_costo cc ON cc.id_centro_costo = da.id_centro_costo
                WHERE da.id_asiento = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var asiento = await multi.ReadFirstOrDefaultAsync<AsientoDetalleDto>();
            if (asiento != null)
            {
                asiento.Detalles = (await multi.ReadAsync<DetalleAsientoDto>()).ToList();
            }

            return asiento;
        }

        public async Task<AsientoContable?> ObtenerPorIdAsync(long id)
        {
            return await _context.AsientosContables
                .Include(a => a.Detalles)
                .FirstOrDefaultAsync(a => a.Id == id);
        }

        public async Task<AsientoContable> AgregarAsync(AsientoContable asiento)
        {
            _context.AsientosContables.Add(asiento);
            await _context.SaveChangesAsync();
            return asiento;
        }

        public async Task<(IEnumerable<AsientoListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, string? periodo, int pagina, int elementosPorPagina)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var offset = (pagina - 1) * elementosPorPagina;
            var sql = @"
                SELECT a.id_asiento as Id, a.fecha_contable, a.periodo, a.glosa, a.origen_modulo,
                       a.total_debe, a.total_haber,
                       COUNT(*) OVER() AS TotalRegistros
                FROM contabilidad.asientos_contables a
                WHERE (@busqueda IS NULL OR a.glosa ILIKE '%' || @busqueda || '%' OR a.origen_modulo ILIKE '%' || @busqueda || '%')
                  AND (@periodo IS NULL OR a.periodo = @periodo)
                ORDER BY a.fecha_contable DESC, a.id_asiento DESC
                LIMIT @elementosPorPagina OFFSET @offset;";

            var parameters = new { busqueda, periodo, elementosPorPagina, offset };
            var rows = await connection.QueryAsync<AsientoListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
