using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Entidades.Kardex;
using Inventario.API.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class KardexMovimientoRepositorio : IKardexMovimientoRepositorio
    {
        private readonly IInventarioDbContext _context;

        public KardexMovimientoRepositorio(IInventarioDbContext context)
        {
            _context = context;
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
            // Bloqueo pesimista en PostgreSQL para evitar Race Conditions durante operaciones concurrentes en la misma combinación Almacén-Producto
            var sql = $"SELECT 1 FROM inventario.inv_kardex_movimiento WHERE almacen_id = {almacenId} AND producto_id = {productoId} FOR UPDATE";
            
            // Usando ExecuteSqlRawAsync para que adquiera el candado SQL directamente en el bloque de la transacción activa
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

        public async Task<KardexMovimiento?> ObtenerPorReferenciaAsync(long referenciaId, string referenciaTipo)
        {
            return await _context.KardexMovimientos.FirstOrDefaultAsync(x => x.ReferenciaId == referenciaId && x.ReferenciaTipo == referenciaTipo);
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
    }
}
