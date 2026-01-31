using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IImagenProductoRepositorio
    {
        Task<ImagenProducto?> ObtenerPorIdAsync(long id);
        Task<ImagenProducto> AgregarAsync(ImagenProducto imagen);
        Task ActualizarAsync(ImagenProducto imagen);
        Task EliminarAsync(long id);
        Task<IEnumerable<ImagenProducto>> ObtenerPorProductoAsync(long idProducto);
    }
}
