using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Data;
using Dapper;
using System.Linq;
using Ventas.API.Domain.DTOs;

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
            if (connection.State != System.Data.ConnectionState.Open)
                await connection.OpenAsync();

            var sql = @"
                -- Cabecera
                SELECT v.id_venta as Id, v.serie, v.numero, v.fecha_emision, v.total_venta, v.subtotal_gravado, v.subtotal_exonerado,
                       v.subtotal_inafecto, v.total_impuesto, v.total_descuento_global, v.saldo_pendiente, v.observaciones,
                       v.moneda, v.tipo_cambio, v.fecha_vencimiento_pago, v.id_empresa, v.id_almacen, v.id_caja, v.id_cliente,
                       v.id_usuario_vendedor, v.id_cotizacion_origen, v.id_tipo_comprobante, v.id_estado, v.id_estado_pago,
                       v.fecha_creacion,
                       tc.nombre AS TipoComprobante,
                       c.razon_social AS NombreCliente,
                       c.numero_documento AS NumeroDocumentoCliente,
                       tgd.nombre AS Estado,
                       tgd2.nombre AS EstadoPago
                FROM ventas.ventas v
                INNER JOIN configuracion.tipo_comprobante tc ON tc.id_tipo_comprobante = v.id_tipo_comprobante
                INNER JOIN clientes.clientes c ON c.id_cliente = v.id_cliente
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = v.id_estado
                LEFT JOIN configuracion.tablas_generales_detalle tgd2 ON tgd2.id_tabla = 13 AND tgd2.id_detalle = v.id_estado_pago
                WHERE v.id_venta = @id;

                -- Detalles
                SELECT dv.id_detalle_venta as Id, dv.id_producto, dv.id_variante, NULLIF(p.nombre_producto, dv.descripcion_producto) as descripcion_producto,
                       dv.cantidad, dv.precio_unitario, dv.precio_lista_original, dv.porcentaje_impuesto,
                       dv.impuesto_item, dv.total_item
                FROM ventas.detalle_venta dv
                INNER JOIN catalogo.productos p ON p.id_producto = dv.id_producto
                WHERE dv.id_venta = @id;

                -- Pagos
                SELECT p.id_pago as Id, p.fecha_pago, p.monto_pago, p.id_metodo_pago,
                       mp.nombre AS MetodoPagoNombre
                FROM ventas.pagos p
                LEFT JOIN configuracion.metodos_pago mp  ON mp.id_metodo_pago = p.id_metodo_pago
                WHERE p.id_venta = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            
            var venta = await multi.ReadFirstOrDefaultAsync<VentaDetalleDto>();
            if (venta != null)
            {
                venta.Detalles = (await multi.ReadAsync<DetalleVentaDto>()).ToList();
                venta.Pagos = (await multi.ReadAsync<PagoDto>()).ToList();
            }

            return venta;
        }

        public async Task<Venta?> ObtenerPorIdAsync(long id)
        {
            return await _context.Ventas
                .Include(v => v.Detalles)
                .Include(v => v.Cliente)
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
                .Include(v => v.Cliente)
                .ToListAsync();
        }

        public async Task<(IEnumerable<VentaListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != System.Data.ConnectionState.Open)
                await connection.OpenAsync();
            
            var sqlSearch = string.IsNullOrEmpty(search) ? null : $"%{search}%";
            var offset = (pageNumber - 1) * pageSize;

            var sql = @"
                SELECT v.id_venta AS Id, v.serie, v.numero, v.fecha_emision, v.total_venta,
                       v.id_estado, v.id_estado_pago, v.fecha_creacion,
                       tc.nombre AS tipo_comprobante_nombre,
                       c.razon_social AS cliente_razon_social,
                       c.numero_documento AS cliente_numero_documento,
                       tgd.nombre AS estado_nombre,
                       tgd2.nombre AS estado_pago_nombre,
                       COUNT(*) OVER() AS total
                FROM ventas.ventas v
                INNER JOIN configuracion.tipo_comprobante tc ON tc.id_tipo_comprobante = v.id_tipo_comprobante
                INNER JOIN clientes.clientes c ON c.id_cliente = v.id_cliente
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = v.id_estado
                LEFT JOIN configuracion.tablas_generales_detalle tgd2 ON tgd2.id_tabla = 13 AND tgd2.id_detalle = v.id_estado_pago
                WHERE (@search IS NULL 
                   OR v.serie ILIKE @search 
                   OR v.numero::text ILIKE @search 
                   OR c.razon_social ILIKE @search
                   OR c.numero_documento ILIKE @search)
                ORDER BY v.fecha_emision DESC, v.id_venta DESC
                LIMIT @pageSize OFFSET @offset;";

            var parameters = new { search = sqlSearch, pageSize, offset };

            var rows = await connection.QueryAsync<VentaListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.Total ?? 0;

            return (rows, total);
        }

        public async Task<long> ObtenerSiguienteCorrelativoAsync(long idAlmacen, long idTipoComprobante, string serie)
        {
            using var tx = await _context.Database.BeginTransactionAsync();
            try
            {
                var row = await _context.SeriesComprobantes
                    .FromSqlRaw("SELECT * FROM configuracion.series_comprobantes WHERE id_almacen = {0} AND id_tipo_comprobante = {1} AND serie = {2} FOR UPDATE", 
                        idAlmacen, idTipoComprobante, serie)
                    .FirstOrDefaultAsync();

                if (row == null) throw new Exception($"Configuración de serie {serie} no encontrada.");

                row.CorrelativoActual++;
                var next = row.CorrelativoActual;

                _context.SeriesComprobantes.Update(row);
                await _context.SaveChangesAsync();
                await tx.CommitAsync();

                return next;
            }
            catch { await tx.RollbackAsync(); throw; }
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
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                -- Cabecera
                SELECT c.id_cotizacion as Id, c.serie, c.numero, c.id_cliente, 
                       cli.razon_social as ClienteNombre, cli.numero_documento as ClienteNumeroDocumento,
                       c.id_usuario_vendedor, c.fecha_emision, c.fecha_vencimiento, 
                       c.id_estado, c.moneda, c.tipo_cambio, c.subtotal, c.impuesto, c.total, c.observaciones
                FROM ventas.cotizaciones c
                INNER JOIN clientes.clientes cli ON cli.id_cliente = c.id_cliente
                WHERE c.id_cotizacion = @id;

                -- Detalles
                SELECT dc.id_detalle_cotizacion as Id, dc.id_producto, p.codigo_producto, p.nombre_producto as DescripcionProducto,
                       dc.id_variante, dc.cantidad, dc.precio_unitario, dc.subtotal
                FROM ventas.detalle_cotizacion dc
                INNER JOIN catalogo.productos p ON p.id_producto = dc.id_producto
                WHERE dc.id_cotizacion = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var dto = await multi.ReadFirstOrDefaultAsync<CotizacionDetalleDto>();
            if (dto != null)
            {
                dto.Detalles = (await multi.ReadAsync<DetalleCotizacionItemDto>()).ToList();
            }

            return dto;
        }

        public async Task<Cotizacion?> ObtenerPorIdAsync(long id)
        {
            return await _context.Cotizaciones
                .Include(c => c.Detalles)
                .Include(c => c.Cliente)
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
                .Include(c => c.Cliente)
                .ToListAsync();
        }

        public async Task<(IEnumerable<CotizacionListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var offset = (pageNumber - 1) * pageSize;
            var sql = @"
                SELECT c.id_cotizacion as Id, c.serie, c.numero, c.fecha_emision, c.fecha_vencimiento,
                       cli.razon_social as ClienteNombre, c.moneda, c.total as TotalCotizacion, c.id_estado,
                       tgd.nombre as EstadoNombre,
                       COUNT(*) OVER() AS Total
                FROM ventas.cotizaciones c
                INNER JOIN clientes.clientes cli ON cli.id_cliente = c.id_cliente
                LEFT JOIN configuracion.tablas_generales_detalle tgd ON tgd.id_tabla = 15 AND tgd.id_detalle = c.id_estado
                WHERE (@search IS NULL OR 
                       c.serie ILIKE '%' || @search || '%' OR 
                       c.numero::text ILIKE '%' || @search || '%' OR
                       cli.razon_social ILIKE '%' || @search || '%')
                ORDER BY c.fecha_emision DESC, c.id_cotizacion DESC
                LIMIT @pageSize OFFSET @offset;";

            var parameters = new { search, pageSize, offset };
            var rows = await connection.QueryAsync<CotizacionListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.Total ?? 0;
            return (rows, total);
        }
    }
}
