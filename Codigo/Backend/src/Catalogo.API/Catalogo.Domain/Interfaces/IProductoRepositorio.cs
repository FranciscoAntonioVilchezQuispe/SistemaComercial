using Catalogo.Domain.Entidades;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IProductoRepositorio
    {
        Task<Producto?> ObtenerPorIdAsync(long id);
        Task<Producto> AgregarAsync(Producto producto);
        Task ActualizarAsync(Producto producto);
        Task<IEnumerable<Producto>> ObtenerTodosAsync();
        Task<(IEnumerable<Producto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina);
    }
}
