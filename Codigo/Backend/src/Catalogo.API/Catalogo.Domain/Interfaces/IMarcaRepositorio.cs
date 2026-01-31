using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IMarcaRepositorio
    {
        Task<Marca?> ObtenerPorIdAsync(long id);
        Task<Marca> AgregarAsync(Marca marca);
        Task ActualizarAsync(Marca marca);
        Task EliminarAsync(long id);
        Task<IEnumerable<Marca>> ObtenerTodosAsync();
        Task<(IEnumerable<Marca> Datos, int Total)> ObtenerPaginadoAsync(string? busqueda, bool? activo, int pagina, int elementosPorPagina);
    }
}
