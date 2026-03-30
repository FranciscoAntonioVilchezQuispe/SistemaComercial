namespace Compras.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarEntradaCompraAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idCompra, long idTipoComprobante, string serie, string numero);
        Task<bool> EliminarMovimientosCompraAsync(long idCompra);
        Task<bool> RegistrarSalidaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero);
        Task<bool> RegistrarEntradaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad, decimal costoUnitario, long idNota, string serie, string numero);
    }
}
