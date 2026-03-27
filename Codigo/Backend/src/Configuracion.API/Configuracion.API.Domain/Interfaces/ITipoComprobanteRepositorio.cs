using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface ITipoComprobanteRepositorio
    {
        Task<TipoComprobante?> ObtenerPorIdAsync(long id);
        Task<TipoComprobante> AgregarAsync(TipoComprobante tipo);
        Task ActualizarAsync(TipoComprobante tipo);
        Task<IEnumerable<TipoComprobante>> ObtenerTodosAsync();
        Task<(IEnumerable<TipoComprobante>, int)> ObtenerPaginadoAsync(string? search, bool? activo, string? modulo, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
    }
}
