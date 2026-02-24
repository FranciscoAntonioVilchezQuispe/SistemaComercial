using MediatR;
using System.Collections.Generic;

namespace Inventario.API.Application.Consultas
{
    public record ObtenerTrasladosConsulta : IRequest<List<TrasladoDto>>;

    public class TrasladoDto
    {
        public long Id { get; set; }
        public string NumeroTraslado { get; set; } = null!;
        public long AlmacenOrigenId { get; set; }
        public string AlmacenOrigenNombre { get; set; } = null!;
        public long AlmacenDestinoId { get; set; }
        public string AlmacenDestinoNombre { get; set; } = null!;
        public DateTime? FechaDespacho { get; set; }
        public DateTime? FechaRecepcion { get; set; }
        public string Estado { get; set; } = null!;
        public string? Observaciones { get; set; }
        public List<TrasladoDetalleDto> Detalles { get; set; } = new();
    }

    public class TrasladoDetalleDto
    {
        public long ProductoId { get; set; }
        public string ProductoNombre { get; set; } = null!;
        public decimal CantidadSolicitada { get; set; }
        public decimal CantidadDespachada { get; set; }
        public decimal CantidadRecibida { get; set; }
    }
}
