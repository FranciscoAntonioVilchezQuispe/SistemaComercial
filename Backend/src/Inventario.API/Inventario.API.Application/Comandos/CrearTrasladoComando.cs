using MediatR;
using System.Collections.Generic;

namespace Inventario.API.Application.Comandos
{
    public class CrearTrasladoComando : IRequest<long>
    {
        public long AlmacenOrigenId { get; set; }
        public long AlmacenDestinoId { get; set; }
        public string? Observaciones { get; set; }
        public List<CrearTrasladoDetalleDto> Detalles { get; set; } = new();
    }

    public class CrearTrasladoDetalleDto
    {
        public long ProductoId { get; set; }
        public decimal Cantidad { get; set; }
    }
}
