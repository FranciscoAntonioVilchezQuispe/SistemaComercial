using Ventas.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Ventas.API.Domain.Interfaces
{
    public interface IVentaRepositorio
    {
        Task<Venta?> ObtenerPorIdAsync(long id);
        Task<Venta> AgregarAsync(Venta venta);
        Task<IEnumerable<Venta>> ObtenerTodasAsync();
        Task<(IEnumerable<Venta> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
    }

    public interface ICotizacionRepositorio
    {
        Task<Cotizacion?> ObtenerPorIdAsync(long id);
        Task<Cotizacion> AgregarAsync(Cotizacion cotizacion);
        Task<IEnumerable<Cotizacion>> ObtenerTodasAsync();
        Task<(IEnumerable<Cotizacion> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
    }
}
