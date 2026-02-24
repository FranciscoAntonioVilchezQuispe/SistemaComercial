using System.Threading;
using System.Threading.Tasks;

namespace Inventario.API.Application.Interfaces
{
    public interface IValidacionReglaSunatService
    {
        /// <summary>
        /// Valida si una combinación de tipo de operación y tipo de comprobante es permitida por SUNAT.
        /// </summary>
        /// <param name="codigoOperacion">Código SUNAT de la operación (ej. 01, 11, 16)</param>
        /// <param name="idTipoComprobante">ID del tipo de comprobante (Tabla 10)</param>
        /// <returns>Nivel de obligatoriedad: 0=Prohibido, 1=Opcional, 2=Obligatorio, 3=Recomendado</returns>
        Task<int> ValidarReglaAsync(string codigoOperacion, long idTipoComprobante, CancellationToken cancellationToken);
    }
}
