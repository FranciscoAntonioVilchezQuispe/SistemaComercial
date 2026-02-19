using MediatR;

namespace Compras.API.Application.Comandos
{
    public record EliminarCompraComando(long Id) : IRequest<bool>;
}
