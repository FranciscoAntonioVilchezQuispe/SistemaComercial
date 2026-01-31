using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class ImagenProductoRepositorio : IImagenProductoRepositorio
    {
        private readonly CatalogoDbContext _context;

        public ImagenProductoRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<ImagenProducto?> ObtenerPorIdAsync(long id)
        {
            return await _context.ImagenesProducto.FindAsync(id);
        }

        public async Task<ImagenProducto> AgregarAsync(ImagenProducto imagen)
        {
            _context.ImagenesProducto.Add(imagen);
            await _context.SaveChangesAsync();
            return imagen;
        }

        public async Task ActualizarAsync(ImagenProducto imagen)
        {
            _context.Entry(imagen).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var imagen = await _context.ImagenesProducto.FindAsync(id);
            if (imagen != null)
            {
                _context.ImagenesProducto.Remove(imagen);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<ImagenProducto>> ObtenerPorProductoAsync(long idProducto)
        {
            return await _context.ImagenesProducto
                .Where(i => i.IdProducto == idProducto)
                .ToListAsync();
        }
    }
}
