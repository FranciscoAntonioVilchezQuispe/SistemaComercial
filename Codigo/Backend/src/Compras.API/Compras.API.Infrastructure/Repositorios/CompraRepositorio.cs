using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Configuracion.API.Infrastructure.Datos;
using Inventario.API.Infrastructure.Datos;
using Catalogo.Infrastructure.Datos;

namespace Compras.API.Infrastructure.Repositorios
{
    public class CompraRepositorio : ICompraRepositorio
    {
        private readonly ComprasDbContext _context;
        private readonly ConfiguracionDbContext _configContext;
        private readonly InventarioDbContext _inventarioContext;
        private readonly CatalogoDbContext _catalogoContext;

        public CompraRepositorio(
            ComprasDbContext context,
            ConfiguracionDbContext configContext,
            InventarioDbContext inventarioContext,
            CatalogoDbContext catalogoContext)
        {
            _context = context;
            _configContext = configContext;
            _inventarioContext = inventarioContext;
            _catalogoContext = catalogoContext;
        }

        public async Task<Compra?> ObtenerPorIdAsync(long id)
        {
            var query = from c in _context.Compras
                        join p in _context.Proveedores on c.IdProveedor equals p.Id
                        join td in _configContext.DocumentoIdentidadReglas on p.IdTipoDocumento equals td.Id
                        join tc in _configContext.TiposComprobante on c.IdTipoComprobante equals tc.Id
                        join a in _inventarioContext.Almacenes on c.IdAlmacen equals a.Id
                        where c.Id == id
                        select new { c, p, td, tc, a };

            var resultado = await query.FirstOrDefaultAsync();
            if (resultado == null) return null;

            var compra = resultado.c;
            compra.Proveedor = resultado.p;
            // Nota: Aquí asignamos los nombres al DTO en el endpoint o mapeador, 
            // pero para mantener la compatibilidad con el repositorio devolvemos la entidad.
            // Para el detalle también hacemos join:

            var detallesQuery = from dc in _context.DetallesCompra
                                join prod in _catalogoContext.Productos on dc.IdProducto equals prod.Id
                                where dc.IdCompra == id
                                select new { dc, prod };

            var detalles = await detallesQuery.ToListAsync();
            compra.Detalles = detalles.Select(x =>
            {
                x.dc.Descripcion = x.prod.NombreProducto; // Usamos el nombre del producto
                return x.dc;
            }).ToList();

            return compra;
        }

        public async Task<Compra> AgregarAsync(Compra compra)
        {
            _context.Compras.Add(compra);
            await _context.SaveChangesAsync();
            return compra;
        }

        public async Task<IEnumerable<Compra>> ObtenerTodosAsync()
        {
            var query = from c in _context.Compras
                        join p in _context.Proveedores on c.IdProveedor equals p.Id
                        join td in _configContext.DocumentoIdentidadReglas on p.IdTipoDocumento equals td.Id
                        join tc in _configContext.TiposComprobante on c.IdTipoComprobante equals tc.Id
                        join a in _inventarioContext.Almacenes on c.IdAlmacen equals a.Id
                        select new { c, p, td, tc, a };

            var resultados = await query.ToListAsync();

            return resultados.Select(r =>
            {
                var c = r.c;
                c.Proveedor = r.p;
                // Almacenamos temporalmente los nombres en propiedades virtuales o el DTO se encargará
                return c;
            }).ToList();
        }

        public async Task<IEnumerable<Compra>> ObtenerPorProveedorAsync(long idProveedor)
        {
            return await _context.Compras
                .Where(c => c.IdProveedor == idProveedor)
                .ToListAsync();
        }
    }
}
