namespace Compras.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idCompra);
        Task<bool> EliminarMovimientosCompraAsync(long idCompra);
    }
}
