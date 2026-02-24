using MediatR;

namespace Inventario.API.Application.Comandos.Kardex
{
    public record CerrarPeriodoComando(string Periodo, long UsuarioId) : IRequest<bool>;
}
