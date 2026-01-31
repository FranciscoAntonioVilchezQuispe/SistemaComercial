using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface ISerieComprobanteRepositorio
    {
        Task<SerieComprobante?> ObtenerPorIdAsync(long id);
        Task<SerieComprobante> AgregarAsync(SerieComprobante serie);
        Task ActualizarAsync(SerieComprobante serie);
        Task<IEnumerable<SerieComprobante>> ObtenerTodasAsync();
        Task<IEnumerable<SerieComprobante>> ObtenerPorTipoAsync(long idTipoComprobante);
        Task EliminarAsync(long id);
    }
}
