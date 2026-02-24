namespace Compras.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idCompra, long idTipoComprobante, string serie, string numero);
        Task<bool> EliminarMovimientosCompraAsync(long idCompra);
    }
}
