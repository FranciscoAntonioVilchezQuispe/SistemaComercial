using System;

namespace Ventas.API.Domain.DTOs
{
    public class CotizacionListDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string NumeroFormateado => Numero.ToString().PadLeft(8, '0');
        public DateTime FechaEmision { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public string Moneda { get; set; } = "PEN";
        public decimal TotalCotizacion { get; set; }
        public string EstadoNombre { get; set; } = string.Empty;
        public long IdEstado { get; set; }
        
        // Paginación (Window Function: COUNT(*) OVER())
        public int Total { get; set; }
    }
}
