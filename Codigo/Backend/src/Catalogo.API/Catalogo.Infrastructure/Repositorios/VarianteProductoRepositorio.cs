using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Infrastructure.Repositorios
{
    public class VarianteProductoRepositorio : IVarianteProductoRepositorio
    {
        private readonly CatalogoDbContext _context;

        public VarianteProductoRepositorio(CatalogoDbContext context)
        {
            _context = context;
        }

        public async Task<VarianteProducto?> ObtenerPorIdAsync(long id)
        {
            return await _context.VariantesProducto.FindAsync(id);
        }

        public async Task<VarianteProducto> AgregarAsync(VarianteProducto variante)
        {
            _context.VariantesProducto.Add(variante);
            await _context.SaveChangesAsync();
            return variante;
        }

        public async Task ActualizarAsync(VarianteProducto variante)
        {
            _context.Entry(variante).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var variante = await _context.VariantesProducto.FindAsync(id);
            if (variante != null)
            {
                _context.VariantesProducto.Remove(variante);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<VarianteProducto>> ObtenerPorProductoAsync(long idProducto)
        {
            return await _context.VariantesProducto
                .Where(v => v.IdProducto == idProducto)
                .ToListAsync();
        }
    }
}
