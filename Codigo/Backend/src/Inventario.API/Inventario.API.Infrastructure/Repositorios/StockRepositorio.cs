using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Nucleo.Comun.Domain;
using System;

namespace Inventario.API.Infrastructure.Repositorios
{
    public class StockRepositorio : IStockRepositorio
    {
        private readonly InventarioDbContext _context;

        public StockRepositorio(InventarioDbContext context)
        {
            _context = context;
        }

        public async Task<Stock?> ObtenerPorProductoAlmacenAsync(long idProducto, long idAlmacen)
        {
            try 
            {
                return await _context.Stocks
                    .FirstOrDefaultAsync(s => s.IdProducto == idProducto && s.IdAlmacen == idAlmacen);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerPorProductoAlmacenAsync] → Falló al obtener stock para Producto={idProducto}, Almacen={idAlmacen}");
                Console.Error.WriteLine($"Detalle: {ex.Message}");
                throw new AppException("StockRepositorio", "Error al obtener stock por producto/almacén", new { idProducto, idAlmacen }, ex);
            }
        }

        public async Task<IEnumerable<Stock>> ObtenerStockBajoAsync(decimal nivelMinimo)
        {
            try
            {
                return await _context.Stocks
                    .Where(s => s.CantidadActual <= nivelMinimo)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerStockBajoAsync] → Falló al obtener stock bajo nivel {nivelMinimo}");
                throw new AppException("StockRepositorio", "Error al obtener stock bajo el nivel mínimo", new { nivelMinimo }, ex);
            }
        }

        public async Task<IEnumerable<Stock>> ObtenerPorAlmacenAsync(long idAlmacen)
        {
            try
            {
                return await _context.Stocks
                    .Where(s => s.IdAlmacen == idAlmacen)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerPorAlmacenAsync] → Falló al obtener stock para Almacen={idAlmacen}");
                throw new AppException("StockRepositorio", "Error al obtener stock por almacén", new { idAlmacen }, ex);
            }
        }

        public async Task<IEnumerable<Stock>> ObtenerPorProductoAsync(long idProducto)
        {
            try
            {
                return await _context.Stocks
                    .Where(s => s.IdProducto == idProducto)
                    .ToListAsync();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerPorProductoAsync] → Falló al obtener stock para Producto={idProducto}");
                throw new AppException("StockRepositorio", "Error al obtener stock por producto", new { idProducto }, ex);
            }
        }

        public async Task<IEnumerable<Stock>> ObtenerTodoAsync()
        {
            try
            {
                return await _context.Stocks.ToListAsync();
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerTodoAsync] → Error inesperado al obtener todo el stock");
                throw new AppException("StockRepositorio", "Error al obtener todo el stock", null, ex);
            }
        }

        public async Task<(IEnumerable<Stock> stocks, int total)> ObtenerPaginadoAsync(long? idAlmacen, long? idProducto, int pagina, int elementosPorPagina)
        {
            try
            {
                var query = _context.Stocks.AsQueryable();

                if (idAlmacen.HasValue)
                    query = query.Where(s => s.IdAlmacen == idAlmacen.Value);

                if (idProducto.HasValue)
                    query = query.Where(s => s.IdProducto == idProducto.Value);

                int total = await query.CountAsync();

                var stocks = await query
                    .OrderByDescending(s => s.Id)
                    .Skip((pagina - 1) * elementosPorPagina)
                    .Take(elementosPorPagina)
                    .ToListAsync();

                return (stocks, total);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"[ERROR] [StockRepositorio] [ObtenerPaginadoAsync] → Error en consulta paginada");
                Console.Error.WriteLine($"Detalle: Almacen={idAlmacen}, Producto={idProducto}, Pagina={pagina} | Mensaje: {ex.Message}");
                Console.Error.WriteLine($"Stack: {ex.StackTrace}");
                throw new AppException("StockRepositorio", "Error al realizar consulta paginada de stock", new { idAlmacen, idProducto, pagina, elementosPorPagina }, ex);
            }
        }
    }
}
