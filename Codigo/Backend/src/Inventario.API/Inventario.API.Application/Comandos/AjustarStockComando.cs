using MediatR;

namespace Inventario.API.Application.Comandos
{
    public record AjustarStockComando(
        long IdProducto,
        long IdAlmacen,
        decimal NuevaCantidad,
        string Motivo
    ) : IRequest<long>;
}
