using MediatR;

namespace Inventario.API.Application.Comandos.Kardex
{
    public record AbrirPeriodoComando(string Periodo, long UsuarioId) : IRequest<bool>;
}
