using MediatR;
using System;

namespace Inventario.API.Application.Comandos.Kardex
{
    public record RecalcularKardexComando(long AlmacenId, long ProductoId, DateTime DesdeFecha, string Motivo, long UsuarioId) : IRequest<bool>;
}
