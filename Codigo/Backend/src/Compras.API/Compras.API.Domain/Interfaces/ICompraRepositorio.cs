using Compras.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Compras.API.Domain.Interfaces
{
    public interface ICompraRepositorio
    {
        Task<Compra?> ObtenerPorIdAsync(long id);
        Task<Compra> AgregarAsync(Compra compra);
        Task<IEnumerable<Compra>> ObtenerTodosAsync();
        Task<IEnumerable<Compra>> ObtenerPorProveedorAsync(long idProveedor);
    }
}
