using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Dapper;
using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Datos;
using Ventas.API.Domain.DTOs;
using Ventas.API.Domain.DTOs.Reportes;

namespace Ventas.API.Infrastructure.Repositorios
{
    public class VentaRepositorio : IVentaRepositorio
    {
        private readonly VentasDbContext _context;

        public VentaRepositorio(VentasDbContext context)
        {
            _context = context;
        }

        public async Task<VentaDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var sql = @"
                -- Cabecera
                SELECT v.id_venta as Id, v.serie as Serie, v.numero as Numero, v.fecha_emision as FechaEmision,
                       v.id_cliente as IdCliente, c.razon_social as ClienteRazonSocial, c.numero_documento as ClienteNumeroDocumento,
                       v.id_tipo_comprobante as IdTipoComprobante, tc.nombre as TipoComprobanteNombre,
                       v.subtotal as Subtotal, v.igv as Igv, v.total_venta as TotalVenta,
                       v.id_estado as IdEstado, tgd.nombre as EstadoNombre, v.id_almacen as IdAlmacen
                FROM ventas.ventas v
                INNER JOIN clientes.clientes c ON v.id_cliente = c.id_cliente
                INNER JOIN configuracion.tipo_comprobante tc ON v.id_tipo_comprobante = tc.id_tipo_comprobante
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = v.id_estado
                WHERE v.id_venta = @id;

                -- Detalles
                SELECT d.id_detalle_venta as Id, d.id_producto as IdProducto, p.nombre_producto as NombreProducto,
                       d.cantidad as Cantidad, d.precio_unitario as PrecioUnitario, d.total_item as TotalItem,
                       d.id_afectacion_igv as IdAfectacionIgv
                FROM ventas.detalle_venta d
                INNER JOIN catalogo.productos p ON d.id_producto = p.id_producto
                WHERE d.id_venta = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var venta = await multi.ReadFirstOrDefaultAsync<VentaDetalleDto>();
            if (venta != null)
            {
                venta.Detalles = (await multi.ReadAsync<DetalleVentaDto>()).ToList();
            }

            return venta;
        }

        public async Task<Venta?> ObtenerPorIdAsync(long id)
        {
            return await _context.Ventas
                .Include(v => v.Detalles)
                .FirstOrDefaultAsync(v => v.Id == id);
        }

        public async Task<Venta> AgregarAsync(Venta venta)
        {
            _context.Ventas.Add(venta);
            await _context.SaveChangesAsync();
            return venta;
        }

        public async Task<IEnumerable<Venta>> ObtenerTodasAsync()
        {
            return await _context.Ventas
                .Include(v => v.Detalles)
                .ToListAsync();
        }

        public async Task<(IEnumerable<VentaListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var offset = (pageNumber - 1) * pageSize;
            var sql = @"
                SELECT v.id_venta as Id, v.serie as Serie, v.numero as Numero, v.fecha_emision as FechaEmision,
                       c.razon_social as ClienteRazonSocial, tc.nombre as TipoComprobanteNombre,
                       v.total_venta as TotalVenta, tgd.nombre as EstadoNombre,
                       COUNT(*) OVER() AS Total
                FROM ventas.ventas v
                INNER JOIN clientes.clientes c ON v.id_cliente = c.id_cliente
                INNER JOIN configuracion.tipo_comprobante tc ON v.id_tipo_comprobante = tc.id_tipo_comprobante
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = v.id_estado
                WHERE (@search IS NULL OR v.serie ILIKE @search OR v.numero ILIKE @search OR c.razon_social ILIKE @search)
                ORDER BY v.fecha_emision DESC
                LIMIT @pageSize OFFSET @offset;";

            var parameters = new { search = $"%{search}%", pageSize, offset };
            var rows = (await connection.QueryAsync<VentaListDto>(sql, parameters)).ToList();
            
            var total = rows.FirstOrDefault()?.Total ?? 0;
            return (rows, total);
        }

        public async Task<long> ObtenerSiguienteCorrelativoAsync(long idAlmacen, long idTipoComprobante, string serie)
        {
            var maxNumero = await _context.Ventas
                .Where(v => v.IdAlmacen == idAlmacen && v.IdTipoComprobante == idTipoComprobante && v.Serie == serie)
                .MaxAsync(v => (long?)v.Numero) ?? 0;

            return maxNumero + 1;
        }

        // --- MÉTODOS DE REPORTE ---

        public async Task<IEnumerable<RankingProductoDto>> ObtenerRankingProductosAsync(DateTime fechaInicio, DateTime fechaFin, int top)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var sql = @"
                SELECT 
                    d.id_producto AS IdProducto,
                    p.codigo_producto AS CodigoProducto,
                    p.nombre_producto AS NombreProducto,
                    SUM(d.cantidad) AS CantidadVendida,
                    SUM(d.total_item) AS TotalVendido
                FROM ventas.detalle_venta d
                INNER JOIN catalogo.productos p ON d.id_producto = p.id_producto
                INNER JOIN ventas.ventas v ON d.id_venta = v.id_venta
                WHERE v.fecha_emision BETWEEN @fechaInicio AND @fechaFin
                  AND v.id_estado != 30 
                GROUP BY d.id_producto, p.codigo_producto, p.nombre_producto
                ORDER BY SUM(d.total_item) DESC
                LIMIT @top;";

            return await connection.QueryAsync<RankingProductoDto>(sql, new { fechaInicio, fechaFin, top });
        }

        public async Task<IEnumerable<TopClienteDto>> ObtenerTopClientesAsync(DateTime fechaInicio, DateTime fechaFin, int top)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var sql = @"
                SELECT 
                    v.id_cliente AS IdCliente,
                    c.razon_social AS RazonSocial,
                    c.numero_documento AS NumeroDocumento,
                    COUNT(v.id_venta) AS CantidadOperaciones,
                    SUM(v.total_venta) AS TotalComprado
                FROM ventas.ventas v
                INNER JOIN clientes.clientes c ON v.id_cliente = c.id_cliente
                WHERE v.fecha_emision BETWEEN @fechaInicio AND @fechaFin
                  AND v.id_estado != 30
                GROUP BY v.id_cliente, c.razon_social, c.numero_documento
                ORDER BY SUM(v.total_venta) DESC
                LIMIT @top;";

            return await connection.QueryAsync<TopClienteDto>(sql, new { fechaInicio, fechaFin, top });
        }
    }

    public class CotizacionRepositorio : ICotizacionRepositorio
    {
        private readonly VentasDbContext _context;

        public CotizacionRepositorio(VentasDbContext context)
        {
            _context = context;
        }

        public async Task<CotizacionDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var sql = @"
                -- Cabecera
                SELECT c.id_cotizacion as Id, c.codigo_cotizacion as Codigo, c.fecha_emision as FechaEmision,
                       c.id_cliente as IdCliente, cl.razon_social as ClienteRazonSocial, cl.numero_documento as ClienteNumeroDocumento,
                       c.subtotal as Subtotal, c.igv as Igv, c.total as Total,
                       c.id_estado as IdEstado, tgd.nombre as EstadoNombre, c.id_almacen as IdAlmacen
                FROM ventas.cotizaciones c
                INNER JOIN clientes.clientes cl ON c.id_cliente = cl.id_cliente
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 16 AND tgd.id_detalle = c.id_estado
                WHERE c.id_cotizacion = @id;

                -- Detalles
                SELECT d.id_detalle_cotizacion as Id, d.id_producto as IdProducto, p.nombre_producto as NombreProducto,
                       d.cantidad as Cantidad, d.precio_unitario as PrecioUnitario, d.subtotal as TotalItem
                FROM ventas.detalle_cotizacion d
                INNER JOIN catalogo.productos p ON d.id_producto = p.id_producto
                WHERE d.id_cotizacion = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var cotizacion = await multi.ReadFirstOrDefaultAsync<CotizacionDetalleDto>();
            if (cotizacion != null)
            {
                cotizacion.Detalles = (await multi.ReadAsync<DetalleCotizacionItemDto>()).ToList();
            }

            return cotizacion;
        }

        public async Task<Cotizacion?> ObtenerPorIdAsync(long id)
        {
            return await _context.Cotizaciones
                .Include(c => c.Detalles)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Cotizacion> AgregarAsync(Cotizacion cotizacion)
        {
            _context.Cotizaciones.Add(cotizacion);
            await _context.SaveChangesAsync();
            return cotizacion;
        }

        public async Task<IEnumerable<Cotizacion>> ObtenerTodasAsync()
        {
            return await _context.Cotizaciones
                .Include(c => c.Detalles)
                .ToListAsync();
        }

        public async Task<(IEnumerable<CotizacionListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync();

            var offset = (pageNumber - 1) * pageSize;
            var sql = @"
                SELECT c.id_cotizacion as Id, c.codigo_cotizacion as Codigo, c.fecha_emision as FechaEmision,
                       cl.razon_social as ClienteRazonSocial, c.total as Total, tgd.nombre as EstadoNombre,
                       COUNT(*) OVER() AS Total
                FROM ventas.cotizaciones c
                INNER JOIN clientes.clientes cl ON c.id_cliente = cl.id_cliente
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 16 AND tgd.id_detalle = c.id_estado
                WHERE (@search IS NULL OR c.codigo_cotizacion ILIKE @search OR cl.razon_social ILIKE @search)
                ORDER BY c.fecha_emision DESC
                LIMIT @pageSize OFFSET @offset;";

            var parameters = new { search = $"%{search}%", pageSize, offset };
            var rows = (await connection.QueryAsync<CotizacionListDto>(sql, parameters)).ToList();
            
            var total = rows.FirstOrDefault()?.Total ?? 0;
            return (rows, total);
        }
    }
}
