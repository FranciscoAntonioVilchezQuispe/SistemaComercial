namespace Ventas.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad, long idVenta, long idTipoComprobante, string serie, string numero, DateTime? fechaMovimiento = null, string codigoOperacionSunat = "01");
        Task<bool> AnularMovimientosVentaAsync(long idVenta);
        Task<bool> RegistrarEntradaNotaCreditoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero, long idTipoComprobante, DateTime? fechaMovimiento = null, string codigoOperacionSunat = "05");
        Task<bool> RegistrarSalidaNotaDebitoAsync(long idProducto, long idAlmacen, decimal cantidad, long idNota, string serie, string numero, long idTipoComprobante, DateTime? fechaMovimiento = null, string codigoOperacionSunat = "01");
    }
}
