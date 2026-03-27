using Inventario.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Inventario.API.Domain.Interfaces
{
    public interface IAlmacenRepositorio
    {
        Task<Almacen?> ObtenerPorIdAsync(long id);
        Task<Almacen> AgregarAsync(Almacen almacen);
        Task ActualizarAsync(Almacen almacen);
        Task<IEnumerable<Almacen>> ObtenerTodosAsync();
        Task<(IEnumerable<Almacen> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina);
    }
}
