namespace Compras.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, long idCompra);
    }
}
