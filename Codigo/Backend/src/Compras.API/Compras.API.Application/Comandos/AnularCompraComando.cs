using MediatR;

namespace Compras.API.Application.Comandos
{
    public record AnularCompraComando(long IdCompra, string Motivo) : IRequest<bool>;
}
