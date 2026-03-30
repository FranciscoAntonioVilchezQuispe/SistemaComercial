using System;
using System.Collections.Generic;

namespace Ventas.API.Domain.DTOs
{
    public class CotizacionDetalleDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string NumeroFormateado => Numero.ToString().PadLeft(8, '0');
        public long IdCliente { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public string ClienteNumeroDocumento { get; set; } = string.Empty;
        public long IdUsuarioVendedor { get; set; }
        public string VendedorNombre { get; set; } = string.Empty;
        public DateTime FechaEmision { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public long IdEstado { get; set; }
        public string EstadoNombre { get; set; } = string.Empty;
        public string Moneda { get; set; } = "PEN";
        public decimal TipoCambio { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Impuesto { get; set; }
        public decimal Total { get; set; }
        public string? Observaciones { get; set; }

        public List<DetalleCotizacionItemDto> Detalles { get; set; } = new();
    }

    public class DetalleCotizacionItemDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public string CodigoProducto { get; set; } = string.Empty;
        public string? DescripcionProducto { get; set; }
        public long? IdVariante { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
    }
}
