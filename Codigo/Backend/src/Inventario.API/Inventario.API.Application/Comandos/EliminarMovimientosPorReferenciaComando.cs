using MediatR;

namespace Inventario.API.Application.Comandos
{
    public record EliminarMovimientosPorReferenciaComando(string Modulo, long IdReferencia) : IRequest<bool>;
}
