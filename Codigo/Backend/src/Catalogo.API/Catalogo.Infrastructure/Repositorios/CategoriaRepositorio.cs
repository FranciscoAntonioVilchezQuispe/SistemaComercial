using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class CategoriaRepositorio : ICategoriaRepositorio
    {
        private readonly CatalogoDbContext _context;

        public CategoriaRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<Categoria?> ObtenerPorIdAsync(long id)
        {
            return await _context.Categorias
                .Include(c => c.SubCategorias)
                .FirstOrDefaultAsync(c => c.Id == id);
        }

        public async Task<Categoria> AgregarAsync(Categoria categoria)
        {
            _context.Categorias.Add(categoria);
            await _context.SaveChangesAsync();
            return categoria;
        }

        public async Task ActualizarAsync(Categoria categoria)
        {
            _context.Entry(categoria).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var categoria = await _context.Categorias.FindAsync(id);
            if (categoria != null)
            {
                categoria.Activado = !categoria.Activado;
                categoria.UsuarioActualizacion = "SISTEMA";
                categoria.FechaActualizacion = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Categoria>> ObtenerTodosAsync()
        {
            return await _context.Categorias.ToListAsync();
        }

        public async Task<(IEnumerable<Categoria> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina)
        {
            var query = _context.Categorias.AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var termino = busqueda.ToLower();
                query = query.Where(x => x.NombreCategoria.ToLower().Contains(termino) || (x.Descripcion != null && x.Descripcion.ToLower().Contains(termino)));
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
