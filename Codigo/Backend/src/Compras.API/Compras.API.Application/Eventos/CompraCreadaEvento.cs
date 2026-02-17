using MediatR;

namespace Compras.API.Application.Eventos
{
    public record CompraCreadaEvento(long CompraId, long IdAlmacen, List<CompraItemDetalle> Items) : INotification;

    public record CompraItemDetalle(long IdProducto, decimal Cantidad, decimal CostoUnitario);

}
