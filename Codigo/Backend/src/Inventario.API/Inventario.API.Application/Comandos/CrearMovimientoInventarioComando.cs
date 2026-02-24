using MediatR;

namespace Inventario.API.Application.Comandos
{
    public record CrearMovimientoInventarioComando(
        long IdProducto,
        long IdAlmacen,
        long IdTipoMovimiento,
        decimal Cantidad,
        decimal? CostoUnitario,
        string? ReferenciaModulo,
        long? IdReferencia,
        string? Observaciones,
        long? IdTipoDocumento,
        string? SerieDocumento,
        string? NumeroDocumento,
        DateTime? FechaMovimiento = null
    ) : IRequest<long>;

}
