using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Compras.API.Domain.DTOs;
using System.Data;
using Compras.API.Domain.DTOs.Reportes;

namespace Compras.API.Infrastructure.Repositorios
{
    public class CompraRepositorio : ICompraRepositorio
    {
        private readonly ComprasDbContext _context;

        public CompraRepositorio(ComprasDbContext context)
        {
            _context = context;
        }

        public async Task<CompraDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                -- Cabecera
                SELECT c.id_compra as Id, c.id_proveedor, p.razon_social as RazonSocialProveedor, 
                       p.numero_documento as NumeroDocumentoProveedor, td.nombre as NombreTipoDocumentoProveedor,
                       p.id_tipo_documento as IdTipoDocumentoProveedor,
                       c.id_almacen, alm.nombre_almacen as NombreAlmacen, c.id_orden_compra_ref,
                       c.id_tipo_comprobante, tc.nombre as NombreTipoComprobante,
                       c.serie_comprobante, c.numero_comprobante, c.fecha_emision, c.fecha_contable,
                       c.fecha_vencimiento, c.moneda, c.tipo_cambio, c.subtotal, c.base_gravada,
                       c.base_exonerada, c.base_inafecta, c.impuesto, c.total, c.saldo_pendiente,
                       c.id_estado_pago, c.id_estado as IdEstado, tgd.nombre as EstadoNombre, c.observaciones
                FROM compras.compras c
                INNER JOIN compras.proveedores p ON p.id_proveedor = c.id_proveedor
                INNER JOIN configuracion.tipo_documento td ON td.id_regla = p.id_tipo_documento
                INNER JOIN inventario.almacenes alm ON alm.id_almacen = c.id_almacen
                INNER JOIN configuracion.tipo_comprobante tc ON tc.id_tipo_comprobante = c.id_tipo_comprobante
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = c.id_estado
                WHERE c.id_compra = @id;

                -- Detalles
                SELECT dc.id_detalle_compra as Id, dc.id_producto, prod.nombre_producto as NombreProducto,
                       dc.id_variante, dc.descripcion, dc.cantidad, dc.precio_unitario_compra,
                       dc.subtotal, dc.afectacion_igv
                FROM compras.detalle_compra dc
                INNER JOIN catalogo.productos prod ON prod.id_producto = dc.id_producto
                WHERE dc.id_compra = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var compra = await multi.ReadFirstOrDefaultAsync<CompraDetalleDto>();
            if (compra != null)
            {
                compra.Detalles = (await multi.ReadAsync<DetalleCompraDto>()).ToList();
            }

            return compra;
        }

        public async Task<Compra?> ObtenerPorIdAsync(long id)
        {
            return await _context.Compras
                .Include(c => c.Detalles)
                .Include(c => c.Proveedor)
                .FirstOrDefaultAsync(c => c.Id == id);
        }


        public async Task<IEnumerable<Compra>> ObtenerTodosAsync()
        {
            return await _context.Compras
                .Include(c => c.Proveedor)
                .ToListAsync();
        }

        public async Task<Compra> AgregarAsync(Compra compra)
        {
            _context.Compras.Add(compra);
            await _context.SaveChangesAsync();
            return compra;
        }

        public async Task<(bool Exito, string Mensaje, long CompraId)> RegistrarCompraAsync(Compra compra)
        {
            try
            {
                _context.Compras.Add(compra);
                await _context.SaveChangesAsync();
                return (true, "Compra registrada exitosamente", compra.Id);
            }
            catch (System.Exception ex)
            {
                return (false, $"Error al registrar la compra: {ex.Message}", 0);
            }
        }

        public async Task<IEnumerable<CompraProveedorDto>> ObtenerComprasPorProveedorAsync(DateTime fechaInicio, DateTime fechaFin, int top)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                SELECT 
                    p.id_proveedor AS IdProveedor,
                    p.razon_social AS RazonSocial,
                    p.numero_documento AS NumeroDocumento,
                    COUNT(c.id_compra) AS CantidadFacturas,
                    SUM(c.total) AS TotalComprado,
                    MAX(c.fecha_emision) AS FechaUltimaCompra
                FROM compras.proveedores p
                INNER JOIN compras.compras c ON p.id_proveedor = c.id_proveedor
                WHERE c.fecha_emision BETWEEN @fechaInicio AND @fechaFin
                  AND c.id_estado != 30 -- ID de 'Anulada'
                GROUP BY p.id_proveedor, p.razon_social, p.numero_documento
                ORDER BY SUM(c.total) DESC
                LIMIT @top;";

            return await connection.QueryAsync<CompraProveedorDto>(sql, new { fechaInicio, fechaFin, top });
        }

        public async Task<IEnumerable<Compra>> ObtenerPorProveedorAsync(long idProveedor)
        {
            return await _context.Compras
                .Where(c => c.IdProveedor == idProveedor)
                .ToListAsync();
        }

        public async Task<(IEnumerable<CompraListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int pagina, int elementosPorPagina)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var offset = (pagina - 1) * elementosPorPagina;
            var sql = @"
                SELECT c.id_compra as Id, c.serie_comprobante, c.numero_comprobante, c.fecha_emision,
                       p.razon_social as RazonSocialProveedor, p.numero_documento as NumeroDocumentoProveedor,
                       tc.nombre as NombreTipoComprobante, c.moneda, c.total, c.saldo_pendiente,
                       c.id_estado as IdEstado, tgd.nombre as EstadoNombre, alm.nombre_almacen as NombreAlmacen,
                       COUNT(*) OVER() AS TotalRegistros
                FROM compras.compras c
                INNER JOIN compras.proveedores p ON p.id_proveedor = c.id_proveedor
                INNER JOIN configuracion.tipo_comprobante tc ON tc.id_tipo_comprobante = c.id_tipo_comprobante
                INNER JOIN inventario.almacenes alm ON alm.id_almacen = c.id_almacen
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = c.id_estado
                WHERE (@busqueda IS NULL OR 
                       c.serie_comprobante ILIKE '%' || @busqueda || '%' OR 
                       c.numero_comprobante ILIKE '%' || @busqueda || '%' OR
                       p.razon_social ILIKE '%' || @busqueda || '%' OR
                       p.numero_documento ILIKE '%' || @busqueda || '%')
                ORDER BY c.fecha_emision DESC, c.id_compra DESC
                LIMIT @elementosPorPagina OFFSET @offset;";

            var parameters = new { busqueda, elementosPorPagina, offset };
            var rows = await connection.QueryAsync<CompraListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
