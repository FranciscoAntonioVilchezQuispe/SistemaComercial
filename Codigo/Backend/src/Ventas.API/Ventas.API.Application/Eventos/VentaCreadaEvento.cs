using MediatR;

namespace Ventas.API.Application.Eventos
{
    public record VentaCreadaEvento(
        long VentaId, 
        long IdAlmacen, 
        long IdTipoComprobante, 
        string Serie, 
        string Numero, 
        List<VentaItemDetalle> Items) : INotification;

    public record VentaItemDetalle(long IdProducto, decimal Cantidad);
}
