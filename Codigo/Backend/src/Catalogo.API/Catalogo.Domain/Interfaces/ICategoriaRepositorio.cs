using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface ICategoriaRepositorio
    {
        Task<Categoria?> ObtenerPorIdAsync(long id);
        Task<Categoria> AgregarAsync(Categoria categoria);
        Task ActualizarAsync(Categoria categoria);
        Task EliminarAsync(long id);
        Task<IEnumerable<Categoria>> ObtenerTodosAsync();
        Task<(IEnumerable<Categoria> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina);
    }
}
