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
    }

    public interface ICotizacionRepositorio
    {
        Task<Cotizacion?> ObtenerPorIdAsync(long id);
        Task<Cotizacion> AgregarAsync(Cotizacion cotizacion);
        Task<IEnumerable<Cotizacion>> ObtenerTodasAsync();
    }
}
