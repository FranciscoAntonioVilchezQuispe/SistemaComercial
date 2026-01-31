using Inventario.API.Application.DTOs;
using MediatR;

namespace Inventario.API.Application.Consultas
{
    public record ObtenerMovimientoInventarioPorIdConsulta(long Id) : IRequest<MovimientoInventarioDto?>;
}
