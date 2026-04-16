using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface ITipoAfectacionIgvRepositorio
    {
        Task<TipoAfectacionIgv?> ObtenerPorIdAsync(long id);
        Task<TipoAfectacionIgv?> ObtenerPorCodigoAsync(string codigo);
        Task<TipoAfectacionIgv> AgregarAsync(TipoAfectacionIgv afectacion);
        Task ActualizarAsync(TipoAfectacionIgv afectacion);
        Task<IEnumerable<TipoAfectacionIgv>> ObtenerTodosAsync();
        Task<(IEnumerable<TipoAfectacionIgv> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
        Task InicializarAsync();
    }
}
