using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class ListaPrecioRepositorio : IListaPrecioRepositorio
    {
        private readonly CatalogoDbContext _context;

        public ListaPrecioRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<ListaPrecio?> ObtenerPorIdAsync(long id)
        {
            return await _context.ListasPrecios.FindAsync(id);
        }

        public async Task<ListaPrecio> AgregarAsync(ListaPrecio lista)
        {
            _context.ListasPrecios.Add(lista);
            await _context.SaveChangesAsync();
            return lista;
        }

        public async Task ActualizarAsync(ListaPrecio lista)
        {
            _context.Entry(lista).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var lista = await _context.ListasPrecios.FindAsync(id);
            if (lista != null)
            {
                _context.ListasPrecios.Remove(lista);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<ListaPrecio>> ObtenerTodosAsync()
        {
            return await _context.ListasPrecios.ToListAsync();
        }
    }
}
