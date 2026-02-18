using Compras.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Compras.API.Domain.Interfaces
{
    public interface IOrdenCompraRepositorio
    {
        Task<OrdenCompra?> ObtenerPorIdAsync(long id);
        Task<OrdenCompra> AgregarAsync(OrdenCompra orden);
        Task ActualizarAsync(OrdenCompra orden);
        Task<IEnumerable<OrdenCompra>> ObtenerTodosAsync();
        Task<IEnumerable<OrdenCompra>> ObtenerPorProveedorAsync(long idProveedor);
        Task<OrdenCompra?> ActualizarEstadoAsync(long id, long idEstado);
        Task<string> ObtenerSiguienteNumeroAsync();
    }
}
