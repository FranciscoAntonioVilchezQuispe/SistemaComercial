using MediatR;

namespace Catalogo.Application.Comandos
{
    /// <summary>
    /// Realiza un borrado lógico del producto (Activado = false).
    /// </summary>
    public record EliminarProductoComando(long Id) : IRequest<bool>;
}
