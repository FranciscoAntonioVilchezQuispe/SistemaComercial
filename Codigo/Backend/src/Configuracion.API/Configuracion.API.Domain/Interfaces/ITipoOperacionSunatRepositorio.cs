using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface ITipoOperacionSunatRepositorio
    {
        Task<IEnumerable<TipoOperacionSunat>> ObtenerTodosAsync();
        Task<TipoOperacionSunat?> ObtenerPorIdAsync(long id);
        Task<TipoOperacionSunat?> ObtenerPorCodigoAsync(string codigo);
        Task<TipoOperacionSunat> AgregarAsync(TipoOperacionSunat tipoOperacion);
        Task ActualizarAsync(TipoOperacionSunat tipoOperacion);
        Task EliminarAsync(long id);
    }
}
