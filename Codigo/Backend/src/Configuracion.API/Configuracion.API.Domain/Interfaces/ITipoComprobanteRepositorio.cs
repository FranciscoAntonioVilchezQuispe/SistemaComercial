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
        Task EliminarAsync(long id);
    }
}
