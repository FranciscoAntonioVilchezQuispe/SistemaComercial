using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Inventario.API.Domain.DTOs;
using System.Data;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class KardexMovimientoRepositorio : IKardexMovimientoRepositorio
    {
        private readonly IInventarioDbContext _context;

        public KardexMovimientoRepositorio(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<MovimientoDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) {
                if (connection is System.Data.Common.DbConnection dbConn) await dbConn.OpenAsync();
                else connection.Open();
            }

            var sql = @"
                SELECT km.id_kardex_movimiento as Id, km.id_tipo_movimiento, km.id_stock, km.id_producto,
                       km.id_almacen, km.cantidad, km.cantidad_anterior, km.cantidad_nueva,
                       km.costo_unitario_movimiento, km.saldo_cantidad, km.saldo_valorizado,
                       km.costo_promedio_actual, km.referencia_modulo, km.referencia_id,
                       km.observaciones, km.fecha_movimiento as FechaHoraMovimiento,
                       km.fecha_creacion as FechaCreacion, km.usuario_creacion
                FROM inventario.inv_kardex_movimiento km
                WHERE km.id_kardex_movimiento = @id;";

            return await connection.QueryFirstOrDefaultAsync<MovimientoDetalleDto>(sql, new { id });
        }

        public async Task ActualizarAsync(KardexMovimiento movimiento)
        {
            _context.KardexMovimientos.Update(movimiento);
            await _context.SaveChangesAsync(default);
        }

        public async Task AgregarAsync(KardexMovimiento movimiento)
        {
            await _context.KardexMovimientos.AddAsync(movimiento);
            await _context.SaveChangesAsync(default);
        }

        public async Task BloquearFilaParaCalculoAsync(long almacenId, long productoId)
        {
            var sql = $"SELECT 1 FROM inventario.inv_kardex_movimiento WHERE id_almacen = {almacenId} AND id_producto = {productoId} FOR UPDATE";
            await ((DbContext)_context).Database.ExecuteSqlRawAsync(sql);
        }

        public async Task<List<KardexMovimiento>> ObtenerMovimientosDesdeAsync(long almacenId, long productoId, DateTime desdeFecha, TimeSpan desdeHora)
        {
            return await _context.KardexMovimientos
                .Where(x => x.AlmacenId == almacenId && x.ProductoId == productoId)
                .Where(x => x.FechaMovimiento > desdeFecha || (x.FechaMovimiento == desdeFecha && x.HoraMovimiento >= desdeHora))
                .OrderBy(x => x.FechaHoraCompuesta)
                .ThenBy(x => x.Id)
                .ToListAsync();
        }

        public async Task<KardexMovimiento?> ObtenerPorIdAsync(long id)
        {
            return await _context.KardexMovimientos.FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<List<KardexMovimiento>> ObtenerPorReferenciaAsync(long referenciaId, string referenciaTipo)
        {
            return await _context.KardexMovimientos
                .Where(x => x.ReferenciaId == referenciaId && x.ReferenciaTipo == referenciaTipo)
                .ToListAsync();
        }

        public async Task<KardexMovimiento?> ObtenerUltimoMovimientoAsync(long almacenId, long productoId, DateTime hastaFecha, TimeSpan hastaHora)
        {
            return await _context.KardexMovimientos
                .Where(x => x.AlmacenId == almacenId && x.ProductoId == productoId)
                .Where(x => x.Anulado == false)
                .Where(x => x.FechaMovimiento < hastaFecha || (x.FechaMovimiento == hastaFecha && x.HoraMovimiento < hastaHora))
                .OrderByDescending(x => x.FechaHoraCompuesta)
                .ThenByDescending(x => x.Id)
                .FirstOrDefaultAsync();
        }

        public async Task<(IEnumerable<MovimientoListDto> Datos, int Total)> ObtenerPaginadoAsync(long? idAlmacen, long? idProducto, int pagina, int elementosPorPagina)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) {
                if (connection is System.Data.Common.DbConnection dbConn) await dbConn.OpenAsync();
                else connection.Open();
            }

            var offset = (pagina - 1) * elementosPorPagina;
            var sql = @"
                SELECT km.id_kardex_movimiento as Id, km.cantidad, km.cantidad_nueva,
                       km.fecha_movimiento as FechaCreacion, km.usuario_creacion,
                       COUNT(*) OVER() AS TotalRegistros
                FROM inventario.inv_kardex_movimiento km
                WHERE (@idAlmacen IS NULL OR km.id_almacen = @idAlmacen)
                  AND (@idProducto IS NULL OR km.id_producto = @idProducto)
                ORDER BY km.fecha_movimiento DESC, km.id_kardex_movimiento DESC
                LIMIT @elementosPorPagina OFFSET @offset;";

            var parameters = new { idAlmacen, idProducto, elementosPorPagina, offset };
            var rows = await connection.QueryAsync<MovimientoListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
