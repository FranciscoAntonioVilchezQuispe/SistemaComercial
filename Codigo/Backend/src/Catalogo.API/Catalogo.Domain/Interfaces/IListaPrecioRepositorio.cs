using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IListaPrecioRepositorio
    {
        Task<ListaPrecio?> ObtenerPorIdAsync(long id);
        Task<ListaPrecio> AgregarAsync(ListaPrecio lista);
        Task ActualizarAsync(ListaPrecio lista);
        Task EliminarAsync(long id);
        Task<IEnumerable<ListaPrecio>> ObtenerTodosAsync();
    }
}
