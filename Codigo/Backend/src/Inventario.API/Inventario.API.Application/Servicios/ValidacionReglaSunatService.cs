using Inventario.API.Application.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;
using Nucleo.Comun.Domain.Helpers;

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
            Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Buscando Operación: {codigoOperacion}");
            // 1. Obtener el ID de la operación SUNAT a partir del código
            var operacion = await _context.SyncTiposOperacionSunat
                .AsNoTracking()
                .FirstOrDefaultAsync(t => t.Codigo == codigoOperacion && t.Activado, cancellationToken);

            if (operacion == null)
            {
                Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Operación NO ENCONTRADA o INACTIVA.");
                return 0; // Si la operación no existe o no está activa, no se permite
            }
            Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Operación Encontrada: ID={operacion.Id}");

            // 2. Consultar la matriz de reglas
            Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Buscando Regla para OperaciónID={operacion.Id} y ComprobanteID={idTipoComprobante}");
            var regla = await _context.SyncMatrizReglasSunat
                .AsNoTracking()
                .FirstOrDefaultAsync(r => r.IdTipoOperacion == operacion.Id &&
                                         r.IdTipoComprobante == idTipoComprobante &&
                                         r.Activado, cancellationToken);

            if (regla == null)
            {
                Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Regla NO ENCONTRADA o INACTIVA en matriz.");
            }
            else 
            {
                Console.WriteLine($"[DEBUG] [Inventario.API] [ValidacionSunat] Regla Encontrada: Nivel={regla.NivelObligatoriedad}");
            }

            // 3. Retornar el nivel de obligatoriedad (0 si no se encuentra la combinación)
            return regla?.NivelObligatoriedad ?? 0;
        }

        public TimeSpan ObtenerHoraComercial(string modulo, string tipoComprobanteSunat)
        {
            string m = modulo?.ToUpper() ?? "";
            
            if (m.Contains("COMPRAS"))
            {
                // Notas de Crédito (07) o Débito (08) de Compras
                if (tipoComprobanteSunat == "07" || tipoComprobanteSunat == "08")
                    return new TimeSpan(9, 0, 0);
                
                return new TimeSpan(8, 0, 0);
            }
            
            if (m.Contains("VENTAS"))
            {
                // Notas de Crédito (07) o Débito (08) de Ventas
                if (tipoComprobanteSunat == "07" || tipoComprobanteSunat == "08")
                    return new TimeSpan(11, 0, 0);
                
                return new TimeSpan(10, 0, 0);
            }

            return DateTimeHelper.ObtenerAhoraLima().TimeOfDay; // Default real time if unknown
        }
    }
}
