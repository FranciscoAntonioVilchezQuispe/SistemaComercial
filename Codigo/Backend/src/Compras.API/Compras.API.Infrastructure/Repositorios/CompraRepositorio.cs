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

        public CompraRepositorio(ComprasDbContext context)
        {
            _context = context;
        }

        public async Task<Compra?> ObtenerPorIdAsync(long id)
        {
            var query = from c in _context.Compras
                        join p in _context.Proveedores on c.IdProveedor equals p.Id
                        join td in _context.TiposDocumentoRef on p.IdTipoDocumento equals td.Id
                        join tc in _context.TiposComprobanteRef on c.IdTipoComprobante equals tc.Id
                        join a in _context.AlmacenesRef on c.IdAlmacen equals a.Id
                        where c.Id == id
                        select new { c, p, td, tc, a };

            var resultado = await query.FirstOrDefaultAsync();
            if (resultado == null) return null;

            var compra = resultado.c;
            compra.Proveedor = resultado.p;
            compra.NombreAlmacen = resultado.a.NombreAlmacen;
            compra.NombreTipoComprobante = resultado.tc.Nombre;
            compra.NombreTipoDocumentoProveedor = resultado.td.Nombre;

            var detallesQuery = from dc in _context.DetallesCompra
                                join prod in _context.ProductosRef on dc.IdProducto equals prod.Id
                                where dc.IdCompra == id
                                select new { dc, prod };

            var detalles = await detallesQuery.ToListAsync();
            compra.Detalles = detalles.Select(x =>
            {
                x.dc.Descripcion = x.prod.NombreProducto;
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
                        join td in _context.TiposDocumentoRef on p.IdTipoDocumento equals td.Id
                        join tc in _context.TiposComprobanteRef on c.IdTipoComprobante equals tc.Id
                        join a in _context.AlmacenesRef on c.IdAlmacen equals a.Id
                        select new { c, p, td, tc, a };

            var resultados = await query.ToListAsync();

            return resultados.Select(r =>
            {
                var c = r.c;
                c.Proveedor = r.p;
                c.NombreAlmacen = r.a.NombreAlmacen;
                c.NombreTipoComprobante = r.tc.Nombre;
                c.NombreTipoDocumentoProveedor = r.td.Nombre;
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
