using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Configuracion.API.Domain.DTOs;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Dapper;
using Microsoft.EntityFrameworkCore;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class UbigeoRepository : IUbigeoRepository
    {
        private readonly ConfiguracionDbContext _context;

        public UbigeoRepository(ConfiguracionDbContext context)
        {
            _context = context;
        }

        private IDbConnection Connection => _context.Database.GetDbConnection();

        public async Task<IEnumerable<UbigeoItemDto>> GetDepartamentosAsync()
        {
            const string sql = @"
                SELECT codigo AS Codigo, nombre AS Nombre
                FROM configuracion.ubigeos
                WHERE nivel = 1 AND activado = true
                ORDER BY nombre;";
            
            return await Connection.QueryAsync<UbigeoItemDto>(sql);
        }

        public async Task<IEnumerable<UbigeoItemDto>> GetProvinciasByDepartamentoAsync(string codigoDept)
        {
            const string sql = @"
                SELECT codigo AS Codigo, nombre AS Nombre
                FROM configuracion.ubigeos
                WHERE nivel = 2 AND parent_id = @codigoDept AND activado = true
                ORDER BY nombre;";
            
            return await Connection.QueryAsync<UbigeoItemDto>(sql, new { codigoDept });
        }

        public async Task<IEnumerable<UbigeoItemDto>> GetDistritosByProvinciaAsync(string codigoProv)
        {
            const string sql = @"
                SELECT codigo AS Codigo, nombre AS Nombre
                FROM configuracion.ubigeos
                WHERE nivel = 3 AND parent_id = @codigoProv AND activado = true
                ORDER BY nombre;";
            
            return await Connection.QueryAsync<UbigeoItemDto>(sql, new { codigoProv });
        }

        public async Task<UbigeoDetalleDto?> GetDetalleByCodigoAsync(string codigo6)
        {
            const string sql = @"
                WITH RECURSIVE ruta AS (
                    SELECT codigo, nombre, nivel, parent_id
                    FROM configuracion.ubigeos
                    WHERE codigo = @codigo6
                    UNION ALL
                    SELECT u.codigo, u.nombre, u.nivel, u.parent_id
                    FROM configuracion.ubigeos u
                    INNER JOIN ruta r ON u.codigo = r.parent_id
                )
                SELECT
                    MAX(CASE WHEN nivel = 3 THEN codigo END)  AS Codigo,
                    MAX(CASE WHEN nivel = 3 THEN nombre END)  AS Distrito,
                    MAX(CASE WHEN nivel = 2 THEN codigo END)  AS CodigoProvincia,
                    MAX(CASE WHEN nivel = 2 THEN nombre END)  AS Provincia,
                    MAX(CASE WHEN nivel = 1 THEN codigo END)  AS CodigoDepartamento,
                    MAX(CASE WHEN nivel = 1 THEN nombre END)  AS Departamento,
                    CONCAT(
                        MAX(CASE WHEN nivel = 1 THEN nombre END), ' › ',
                        MAX(CASE WHEN nivel = 2 THEN nombre END), ' › ',
                        MAX(CASE WHEN nivel = 3 THEN nombre END)
                    ) AS TextoCompleto
                FROM ruta;";

            return await Connection.QueryFirstOrDefaultAsync<UbigeoDetalleDto>(sql, new { codigo6 });
        }

        public async Task<IEnumerable<UbigeoSearchResultDto>> SearchAsync(string termino, int limit = 15)
        {
            const string sql = @"
                SELECT
                    d.codigo AS Codigo,
                    d.nombre AS Nombre,
                    p.nombre AS Provincia,
                    dep.nombre AS Departamento,
                    dep.nombre || ' › ' || p.nombre || ' › ' || d.nombre AS TextoCompleto
                FROM configuracion.ubigeos d
                JOIN configuracion.ubigeos p   ON p.codigo = d.parent_id
                JOIN configuracion.ubigeos dep ON dep.codigo = p.parent_id
                WHERE d.nivel = 3 AND d.activado = true
                  AND (
                      d.nombre ILIKE '%' || @termino || '%'
                      OR p.nombre ILIKE '%' || @termino || '%'
                      OR dep.nombre ILIKE '%' || @termino || '%'
                  )
                ORDER BY d.nombre
                LIMIT @limit;";

            return await Connection.QueryAsync<UbigeoSearchResultDto>(sql, new { termino, limit });
        }
    }
}
