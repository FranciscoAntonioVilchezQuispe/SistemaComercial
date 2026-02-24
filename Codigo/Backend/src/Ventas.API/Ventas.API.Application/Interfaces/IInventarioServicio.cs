namespace Ventas.API.Application.Interfaces
{
    public interface IInventarioServicio
    {
        Task<bool> RegistrarSalidaVentaAsync(long idProducto, long idAlmacen, decimal cantidad, long idVenta, long idTipoComprobante, string serie, string numero);
    }
}
