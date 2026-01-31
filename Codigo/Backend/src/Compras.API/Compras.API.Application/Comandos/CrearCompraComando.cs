using Compras.API.Application.DTOs;
using MediatR;

namespace Compras.API.Application.Comandos
{
    public record CrearCompraComando(CompraDto Compra) : IRequest<long>;
}
