using Inventario.API.Domain.Entidades;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Inventario.API.Domain.Interfaces
{
    public interface IStockRepositorio
    {
        Task<Stock?> ObtenerPorProductoAlmacenAsync(long idProducto, long idAlmacen);
        Task<IEnumerable<Stock>> ObtenerStockBajoAsync(decimal nivelMinimo);
        Task<IEnumerable<Stock>> ObtenerPorAlmacenAsync(long idAlmacen);
    }
}
