using Inventario.API.Domain.DTOs;
using MediatR;

namespace Inventario.API.Application.Consultas
{
    public record ObtenerMovimientoInventarioPorIdConsulta(long Id) : IRequest<MovimientoDetalleDto?>;
}
