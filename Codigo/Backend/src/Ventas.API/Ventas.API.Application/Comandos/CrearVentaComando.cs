using Ventas.API.Application.DTOs;
using MediatR;

namespace Ventas.API.Application.Comandos
{
    public record CrearVentaComando(VentaDto Venta) : IRequest<long>;
}
