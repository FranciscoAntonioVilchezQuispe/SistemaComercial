using System;

namespace Ventas.API.Application.DTOs
{
    public class PagoDto
    {
        public long Id { get; set; }
        public long IdMetodoPago { get; set; } // Catalog or Config ID
        public decimal MontoPago { get; set; }
        public string? ReferenciaPago { get; set; }
        public DateTime FechaPago { get; set; }
    }
}
