using MediatR;
using Ventas.API.Application.DTOs;

namespace Ventas.API.Application.Comandos
{
    public record CrearNotaDebitoComando(NotaDebitoDto Nota) : IRequest<NotaDebitoDto>;
}
