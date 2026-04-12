using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using Dapper;
using Catalogo.Domain.DTOs;
using System.Collections.Generic;
using System.Linq;
using System.Data;

namespace Catalogo.Infrastructure.Repositorios
{
    public class ProductoRepositorio : IProductoRepositorio
    {
        private readonly CatalogoDbContext _context;

        public ProductoRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<ProductoDetalleDto?> ObtenerDetallePorIdAsync(long id)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var sql = @"
                -- Cabecera de Producto
                SELECT p.id_producto as Id, p.codigo_producto as Codigo, p.nombre_producto as Nombre, p.descripcion,
                       p.id_categoria, c.nombre_categoria as CategoriaNombre,
                       p.id_marca, m.nombre_marca as MarcaNombre,
                       p.id_unidad as IdUnidadMedida, um.nombre_unidad as UnidadMedidaNombre, um.simbolo as UnidadMedidaSigla,
                       p.id_tipo_producto, p.codigo_barras, p.sku,
                       p.precio_compra, p.precio_venta_publico, p.precio_venta_mayorista, p.precio_venta_distribuidor,
                       p.stock_minimo, p.stock_maximo, p.tiene_variantes, p.permite_inventario_negativo,
                       p.metodo_valuacion, p.gravado_impuesto, p.porcentaje_impuesto, p.imagen_principal_url,
                       p.activado as Activo, p.fecha_creacion, p.fecha_modificacion as FechaModificacion
                FROM catalogo.productos p
                INNER JOIN catalogo.categorias c ON c.id_categoria = p.id_categoria
                INNER JOIN catalogo.marcas m ON m.id_marca = p.id_marca
                INNER JOIN catalogo.unidades_medida um ON um.id_unidad = p.id_unidad
                WHERE p.id_producto = @id;

                -- Imágenes
                SELECT id_imagen as Id, url_imagen as UrlImagen, es_principal as EsPrincipal, orden
                FROM catalogo.imagenes_producto
                WHERE id_producto = @id;

                -- Variantes
                SELECT id_variante as Id, sku_variante as SkuVariante, 
                       codigo_barras_variante as CodigoBarrasVariante, 
                       nombre_completo_variante as NombreCompletoVariante, 
                       atributos_json as AtributosJson, 
                       precio_adicional as PrecioAdicional
                FROM catalogo.variantes_producto
                WHERE id_producto = @id;";

            using var multi = await connection.QueryMultipleAsync(sql, new { id });
            var producto = await multi.ReadFirstOrDefaultAsync<ProductoDetalleDto>();
            if (producto != null)
            {
                producto.Imagenes = (await multi.ReadAsync<ImagenProductoDto>()).ToList();
                producto.Variantes = (await multi.ReadAsync<VarianteProductoDto>()).ToList();
            }

            return producto;
        }

        public async Task<Producto?> ObtenerPorIdAsync(long id)
        {
            return await _context.Productos
                .Include(p => p.Categoria)
                .Include(p => p.Marca)
                .Include(p => p.UnidadMedida)
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<Producto> AgregarAsync(Producto producto)
        {
            await _context.Productos.AddAsync(producto);
            await _context.SaveChangesAsync();
            return producto;
        }

        public async Task ActualizarAsync(Producto producto)
        {
            _context.Productos.Update(producto);
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<Producto>> ObtenerTodosAsync()
        {
            return await _context.Productos
                .Include(p => p.Categoria)
                .Include(p => p.Marca)
                .Include(p => p.UnidadMedida)
                .ToListAsync();
        }

        public async Task<(IEnumerable<ProductoListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int pagina, int elementosPorPagina)
        {
            var connection = _context.GetDbConnection();
            if (connection.State != ConnectionState.Open) await connection.OpenAsync();

            var offset = (pagina - 1) * elementosPorPagina;
            var sql = @"
                SELECT p.id_producto as Id, p.codigo_producto as Codigo, p.nombre_producto as Nombre,
                       c.nombre_categoria as CategoriaNombre, m.nombre_marca as MarcaNombre, um.simbolo as UnidadMedidaSigla,
                       p.precio_venta_publico as PrecioVentaPublico, p.imagen_principal_url, p.activado as Activo,
                       COUNT(*) OVER() AS TotalRegistros
                FROM catalogo.productos p
                INNER JOIN catalogo.categorias c ON c.id_categoria = p.id_categoria
                INNER JOIN catalogo.marcas m ON m.id_marca = p.id_marca
                INNER JOIN catalogo.unidades_medida um ON um.id_unidad = p.id_unidad
                WHERE (@busqueda IS NULL OR 
                       p.nombre_producto ILIKE '%' || @busqueda || '%' OR 
                       p.codigo_producto ILIKE '%' || @busqueda || '%' OR
                       p.codigo_barras ILIKE '%' || @busqueda || '%')
                ORDER BY p.nombre_producto ASC
                LIMIT @elementosPorPagina OFFSET @offset;";

            var parameters = new { busqueda, elementosPorPagina, offset };
            var rows = await connection.QueryAsync<ProductoListDto>(sql, parameters);
            
            var total = rows.FirstOrDefault()?.TotalRegistros ?? 0;
            return (rows, total);
        }
    }
}
