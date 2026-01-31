using Compras.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Compras.API.Domain.Interfaces
{
    public interface IProveedorRepositorio
    {
        Task<Proveedor?> ObtenerPorIdAsync(long id);
        Task<Proveedor> AgregarAsync(Proveedor proveedor);
        Task ActualizarAsync(Proveedor proveedor);
        Task EliminarAsync(long id);
        Task<IEnumerable<Proveedor>> ObtenerTodosAsync();
    }
}
