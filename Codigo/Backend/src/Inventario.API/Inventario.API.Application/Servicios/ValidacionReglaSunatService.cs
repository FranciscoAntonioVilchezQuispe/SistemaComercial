using Inventario.API.Application.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Servicios
{
    public class ValidacionReglaSunatService : IValidacionReglaSunatService
    {
        private readonly IInventarioDbContext _context;

        public ValidacionReglaSunatService(IInventarioDbContext context)
        {
            _context = context;
        }

        public async Task<int> ValidarReglaAsync(string codigoOperacion, long idTipoComprobante, CancellationToken cancellationToken)
        {
            // 1. Obtener el ID de la operación SUNAT a partir del código
            var operacion = await _context.SyncTiposOperacionSunat
                .AsNoTracking()
                .FirstOrDefaultAsync(t => t.Codigo == codigoOperacion && t.Activo, cancellationToken);

            if (operacion == null)
                return 0; // Si la operación no existe o no está activa, no se permite

            // 2. Consultar la matriz de reglas
            var regla = await _context.SyncMatrizReglasSunat
                .AsNoTracking()
                .FirstOrDefaultAsync(r => r.IdTipoOperacion == operacion.Id &&
                                         r.IdTipoComprobante == idTipoComprobante &&
                                         r.Activo, cancellationToken);

            // 3. Retornar el nivel de obligatoriedad (0 si no se encuentra la combinación)
            return regla?.NivelObligatoriedad ?? 0;
        }
    }
}
