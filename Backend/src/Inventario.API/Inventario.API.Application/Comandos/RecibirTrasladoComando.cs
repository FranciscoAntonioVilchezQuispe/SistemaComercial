using MediatR;
using System.Collections.Generic;

namespace Inventario.API.Application.Comandos
{
    public class RecibirTrasladoComando : IRequest<bool>
    {
        public long TrasladoId { get; set; }
        public string? Observaciones { get; set; }
        public List<RecibirTrasladoDetalleDto> Detalles { get; set; } = new();
    }

    public class RecibirTrasladoDetalleDto
    {
        public long ProductoId { get; set; }
        public decimal CantidadRecibida { get; set; }
        public string? Observaciones { get; set; }
    }
}
