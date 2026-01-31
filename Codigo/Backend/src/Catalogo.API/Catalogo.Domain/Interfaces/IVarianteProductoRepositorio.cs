using Catalogo.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Catalogo.Domain.Interfaces
{
    public interface IVarianteProductoRepositorio
    {
        Task<VarianteProducto?> ObtenerPorIdAsync(long id);
        Task<VarianteProducto> AgregarAsync(VarianteProducto variante);
        Task ActualizarAsync(VarianteProducto variante);
        Task EliminarAsync(long id);
        Task<IEnumerable<VarianteProducto>> ObtenerPorProductoAsync(long idProducto);
    }
}
