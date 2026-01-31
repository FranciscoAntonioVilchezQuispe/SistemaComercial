using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class MarcaRepositorio : IMarcaRepositorio
    {
        private readonly CatalogoDbContext _context;

        public MarcaRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<Marca?> ObtenerPorIdAsync(long id)
        {
            return await _context.Marcas.FindAsync(id);
        }

        public async Task<Marca> AgregarAsync(Marca marca)
        {
            _context.Marcas.Add(marca);
            await _context.SaveChangesAsync();
            return marca;
        }

        public async Task ActualizarAsync(Marca marca)
        {
            _context.Entry(marca).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var marca = await _context.Marcas.FindAsync(id);
            if (marca != null)
            {
                marca.Activado = !marca.Activado;
                marca.UsuarioActualizacion = "SISTEMA";
                marca.FechaActualizacion = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Marca>> ObtenerTodosAsync()
        {
            return await _context.Marcas.ToListAsync();
        }

        public async Task<(IEnumerable<Marca> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina)
        {
            var query = _context.Marcas.AsQueryable();

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var termino = busqueda.ToLower();
                query = query.Where(x => x.NombreMarca.ToLower().Contains(termino));
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
