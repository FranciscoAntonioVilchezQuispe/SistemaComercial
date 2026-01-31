using Configuracion.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Configuracion.API.Domain.Interfaces
{
    public interface IImpuestoRepositorio
    {
        Task<Impuesto?> ObtenerPorIdAsync(long id);
        Task<Impuesto> AgregarAsync(Impuesto impuesto);
        Task ActualizarAsync(Impuesto impuesto);
        Task<IEnumerable<Impuesto>> ObtenerTodosAsync();
        Task EliminarAsync(long id);
    }

    public interface IMetodoPagoRepositorio
    {
        Task<MetodoPago?> ObtenerPorIdAsync(long id);
        Task<MetodoPago> AgregarAsync(MetodoPago metodo);
        Task ActualizarAsync(MetodoPago metodo);
        Task<IEnumerable<MetodoPago>> ObtenerTodosAsync();
        Task EliminarAsync(long id);
    }
}
