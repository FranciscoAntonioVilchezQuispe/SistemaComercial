using Ventas.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;
using Ventas.API.Domain.DTOs;

namespace Ventas.API.Domain.Interfaces
{
    public interface IVentaRepositorio
    {
        Task<VentaDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<Venta?> ObtenerPorIdAsync(long id); // Para escrituras/validaciones internas
        Task<Venta> AgregarAsync(Venta venta);
        Task<IEnumerable<Venta>> ObtenerTodasAsync();
        Task<(IEnumerable<VentaListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
        Task<long> ObtenerSiguienteCorrelativoAsync(long idAlmacen, long idTipoComprobante, string serie);
    }

    public interface ICotizacionRepositorio
    {
        Task<CotizacionDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<Cotizacion?> ObtenerPorIdAsync(long id);
        Task<Cotizacion> AgregarAsync(Cotizacion cotizacion);
        Task<IEnumerable<Cotizacion>> ObtenerTodasAsync();
        Task<(IEnumerable<CotizacionListDto> Datos, int Total)> ObtenerPaginadoAsync(string? search, int pageNumber, int pageSize);
    }
}
