using Catalogo.Domain.Entidades;
using Catalogo.Domain.DTOs;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IProductoRepositorio
    {
        Task<ProductoDetalleDto?> ObtenerDetallePorIdAsync(long id);
        Task<Producto?> ObtenerPorIdAsync(long id); // Auditoría y escrituras internas
        Task<Producto> AgregarAsync(Producto producto);
        Task ActualizarAsync(Producto producto);
        Task<IEnumerable<Producto>> ObtenerTodosAsync();
        Task<(IEnumerable<ProductoListDto> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, int pagina, int elementosPorPagina);
    }
}
