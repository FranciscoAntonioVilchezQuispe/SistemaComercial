using MediatR;

namespace Compras.API.Application.Eventos
{
    public record CompraCreadaEvento(
        long CompraId, 
        long IdAlmacen, 
        long IdTipoComprobante,
        string SerieComprobante,
        string NumeroComprobante,
        List<CompraItemDetalle> Items) : INotification;

    public record CompraItemDetalle(long IdProducto, decimal Cantidad, decimal CostoUnitario);

}
