using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IUnidadMedidaRepositorio
    {
        Task<UnidadMedida?> ObtenerPorIdAsync(long id);
        Task<UnidadMedida> AgregarAsync(UnidadMedida unidad);
        Task ActualizarAsync(UnidadMedida unidad);
        Task EliminarAsync(long id);
        Task<IEnumerable<UnidadMedida>> ObtenerTodosAsync();
    }
}
