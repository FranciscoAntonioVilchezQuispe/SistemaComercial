using MediatR;
using Ventas.API.Application.DTOs;

namespace Ventas.API.Application.Comandos
{
    public record CrearNotaCreditoComando(NotaCreditoDto Nota) : IRequest<NotaCreditoDto>;
}
