using MediatR;

namespace Inventario.API.Application.Comandos
{
    public record SincronizarComprasHistComando(bool Reiniciar = false) : IRequest<string>;
}
