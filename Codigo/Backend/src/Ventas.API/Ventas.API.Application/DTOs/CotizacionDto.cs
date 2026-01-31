using System;
using System.Collections.Generic;

namespace Ventas.API.Application.DTOs
{
    public class CotizacionDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public long IdCliente { get; set; }
        public long IdUsuarioVendedor { get; set; }
        public DateTime FechaEmision { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public long IdEstado { get; set; } // Catalog
        public string Moneda { get; set; } = "PEN";
        public decimal TipoCambio { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Impuesto { get; set; }
        public decimal Total { get; set; }
        public string? Observaciones { get; set; }

        public List<DetalleCotizacionDto> Detalles { get; set; } = new();
    }

    public class DetalleCotizacionDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public long? IdVariante { get; set; }
        public string? DescripcionProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
    }
}
