using MediatR;

namespace Ventas.API.Application.Comandos
{
    public record AnularVentaComando(long IdVenta, string Motivo, long UsuarioId) : IRequest<bool>;
}
