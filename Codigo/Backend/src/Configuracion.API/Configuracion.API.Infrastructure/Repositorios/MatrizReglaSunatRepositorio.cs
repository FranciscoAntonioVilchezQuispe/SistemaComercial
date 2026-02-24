using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Configuracion.API.Infrastructure.Repositorios
{
    public class MatrizReglaSunatRepositorio : IMatrizReglaSunatRepositorio
    {
        private readonly ConfiguracionDbContext _context;

        public MatrizReglaSunatRepositorio(ConfiguracionDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<MatrizReglaSunat>> ObtenerTodasAsync()
        {
            return await _context.MatrizReglasSunat
                .Include(m => m.TipoOperacion)
                .Include(m => m.TipoComprobante)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<IEnumerable<MatrizReglaSunat>> ObtenerPorOperacionAsync(string codigoOperacion)
        {
            return await _context.MatrizReglasSunat
                .Include(m => m.TipoOperacion)
                .Include(m => m.TipoComprobante)
                .Where(m => m.TipoOperacion.Codigo == codigoOperacion && m.Activo == true)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<MatrizReglaSunat?> ObtenerPorIdAsync(long id)
        {
            return await _context.MatrizReglasSunat
                .Include(m => m.TipoOperacion)
                .Include(m => m.TipoComprobante)
                .FirstOrDefaultAsync(m => m.Id == id);
        }

        public async Task<MatrizReglaSunat> AgregarAsync(MatrizReglaSunat matrizRegla)
        {
            await _context.MatrizReglasSunat.AddAsync(matrizRegla);
            await _context.SaveChangesAsync();
            return matrizRegla;
        }

        public async Task ActualizarAsync(MatrizReglaSunat matrizRegla)
        {
            _context.Entry(matrizRegla).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

        public async Task EliminarAsync(long id)
        {
            var matrizRegla = await _context.MatrizReglasSunat.FindAsync(id);
            if (matrizRegla != null)
            {
                _context.MatrizReglasSunat.Remove(matrizRegla);
                await _context.SaveChangesAsync();
            }
        }
    }
}
