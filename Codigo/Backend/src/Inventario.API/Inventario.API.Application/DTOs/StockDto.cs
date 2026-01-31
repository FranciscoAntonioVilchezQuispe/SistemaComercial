using System;

namespace Inventario.API.Application.DTOs
{
    public class StockDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public long? IdVariante { get; set; }
        public long IdAlmacen { get; set; }
        public decimal CantidadActual { get; set; }
        public decimal? CantidadReservada { get; set; }
        public string? UbicacionFisica { get; set; }
        public DateTime FechaActualizacion { get; set; }
    }
}
