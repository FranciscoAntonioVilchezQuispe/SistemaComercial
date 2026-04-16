using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface ITipoTributoRepositorio
    {
        Task<TipoTributo?> ObtenerPorIdAsync(long id);
        Task<TipoTributo?> ObtenerPorCodigoAsync(string codigo);
        Task<TipoTributo> AgregarAsync(TipoTributo tributo);
        Task ActualizarAsync(TipoTributo tributo);
        Task<IEnumerable<TipoTributo>> ObtenerTodosAsync();
        Task<(IEnumerable<TipoTributo> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
        Task InicializarAsync();
    }
}
