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
                SELECT km.id as Id, km.tipo_operacion as IdTipoMovimiento, km.producto_id as IdProducto,
                       km.almacen_id as IdAlmacen, COALESCE(km.entrada_cantidad, km.salida_cantidad, 0) as Cantidad, 
                       km.saldo_cantidad as CantidadNueva, km.saldo_costo_unitario as CostoUnitarioMovimiento, 
                       km.saldo_cantidad, km.saldo_costo_total as SaldoValorizado,
                       km.saldo_costo_unitario as CostoPromedioActual, km.modulo_origen as ReferenciaModulo, 
                       km.referencia_id as ReferenciaId, km.observaciones, km.fecha_movimiento as FechaHoraMovimiento,
                       km.fecha_movimiento as FechaCreacion, km.usuario_registro_id as UsuarioCreacion
                FROM inventario.inv_kardex_movimiento km
                WHERE km.id = @id;";

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
            var sql = $"SELECT 1 FROM inventario.inv_kardex_movimiento WHERE almacen_id = {almacenId} AND producto_id = {productoId} FOR UPDATE";
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
                SELECT km.id as Id, COALESCE(km.entrada_cantidad, km.salida_cantidad, 0) as Cantidad, 
                       km.saldo_cantidad as CantidadNueva,
                       km.fecha_movimiento as FechaCreacion, km.usuario_registro_id as UsuarioCreacion,
                       COUNT(*) OVER() AS TotalRegistros
                FROM inventario.inv_kardex_movimiento km
                WHERE (@idAlmacen IS NULL OR km.almacen_id = @idAlmacen)
                  AND (@idProducto IS NULL OR km.producto_id = @idProducto)
                ORDER BY km.fecha_movimiento DESC, km.hora_movimiento DESC, km.id DESC
                LIMIT @elementosPorPagina OFFSET @offset;";

            var parameters = new { idAlmacen, idProducto, elementosPorPagina, offset };
            var rows = await connection.QueryAsync<MovimientoListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
