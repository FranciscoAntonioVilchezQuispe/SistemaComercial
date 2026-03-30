using MediatR;
using Compras.API.Application.DTOs;

namespace Compras.API.Application.Comandos
{
    public record CrearNotaDebitoCompraComando(NotaDebitoCompraDto Nota) : IRequest<NotaDebitoCompraDto>;
}
