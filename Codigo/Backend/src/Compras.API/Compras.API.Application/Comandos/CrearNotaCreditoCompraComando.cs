using MediatR;
using Compras.API.Application.DTOs;

namespace Compras.API.Application.Comandos
{
    public record CrearNotaCreditoCompraComando(NotaCreditoCompraDto Nota) : IRequest<NotaCreditoCompraDto>;
}
