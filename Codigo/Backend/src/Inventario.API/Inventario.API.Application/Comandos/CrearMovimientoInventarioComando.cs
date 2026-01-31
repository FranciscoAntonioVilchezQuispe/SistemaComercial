using MediatR;

namespace Inventario.API.Application.Comandos
{
    public record CrearMovimientoInventarioComando(
        long IdProducto,
        long IdAlmacen,
        long IdTipoMovimiento,
        decimal Cantidad,
        string? ReferenciaModulo,
        long? IdReferencia,
        string? Observaciones
    ) : IRequest<long>;
}
