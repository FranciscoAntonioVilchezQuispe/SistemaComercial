namespace Ventas.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad, long idVenta, long idTipoComprobante, string serie, string numero);
        Task<bool> AnularMovimientosVentaAsync(long idVenta);
        Task<bool> RegistrarEntradaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero);
        Task<bool> RegistrarSalidaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero);
    }
}
