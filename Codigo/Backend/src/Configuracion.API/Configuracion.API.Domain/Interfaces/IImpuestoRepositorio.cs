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
        Task<(IEnumerable<Impuesto> Datos, int Total)> ObtenerPaginadoAsync(string? search, bool? activo, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
    }

    public interface IMetodoPagoRepositorio
    {
        Task<MetodoPago?> ObtenerPorIdAsync(long id);
        Task<MetodoPago> AgregarAsync(MetodoPago metodo);
        Task ActualizarAsync(MetodoPago metodo);
        Task<IEnumerable<MetodoPago>> ObtenerTodosAsync();
        Task<(IEnumerable<MetodoPago> Datos, int Total)> ObtenerPaginadoAsync(string? search, bool? activo, int pageNumber, int pageSize);
        Task EliminarAsync(long id);
    }
}
