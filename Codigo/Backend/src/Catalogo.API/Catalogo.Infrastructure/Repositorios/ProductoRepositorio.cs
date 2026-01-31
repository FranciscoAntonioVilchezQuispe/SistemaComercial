using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class ProductoRepositorio : IProductoRepositorio
    {
        private readonly CatalogoDbContext _context;

        public ProductoRepositorio(CatalogoDbContext context)
        {
            _context = context;
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

        public async Task EliminarAsync(long id)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto != null)
            {
                producto.Activado = !producto.Activado;
                producto.UsuarioActualizacion = "SISTEMA";
                producto.FechaActualizacion = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<(IEnumerable<Producto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina)
        {
            var query = _context.Productos
                .Include(p => p.Categoria)
                .Include(p => p.Marca)
                .Include(p => p.UnidadMedida)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var termino = busqueda.ToLower();
                query = query.Where(x => x.NombreProducto.ToLower().Contains(termino) || x.CodigoProducto.ToLower().Contains(termino));
            }

            if (activo.HasValue)
            {
                query = query.Where(x => x.Activado == activo.Value);
            }

            var total = await query.CountAsync();

            var datos = await query
                .OrderByDescending(x => x.Id)
                .Skip((pagina - 1) * elementosPorPagina)
                .Take(elementosPorPagina)
                .ToListAsync();

            return (datos, total);
        }
    }
}
