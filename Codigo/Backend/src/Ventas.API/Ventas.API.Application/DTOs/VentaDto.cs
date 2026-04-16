using System;
using System.Collections.Generic;
using Ventas.API.Domain.DTOs;

namespace Ventas.API.Application.DTOs
{
    public class VentaDto
    {
        public long Id { get; set; }
        public long IdEmpresa { get; set; }
        public long IdAlmacen { get; set; }
        public long? IdCaja { get; set; }
        public long IdCliente { get; set; }
        public string NombreCliente { get; set; } = string.Empty; // Opción para mostrar nombre sin join extra si se desea
        public long IdUsuarioVendedor { get; set; }
        public long? IdCotizacionOrigen { get; set; }
        public long IdTipoComprobante { get; set; } // Catalog
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string NumeroFormateado => Numero.ToString().PadLeft(8, '0');
        public DateTime FechaEmision { get; set; }
        public DateTime? FechaVencimientoPago { get; set; }
        public long IdEstado { get; set; } // Catalog
        public string Moneda { get; set; } = "PEN";
        public decimal TipoCambio { get; set; }
        public decimal SubtotalGravado { get; set; }
        public decimal SubtotalExonerado { get; set; }
        public decimal SubtotalInafecto { get; set; }
        public decimal TotalImpuesto { get; set; }
        public decimal TotalDescuentoGlobal { get; set; }
        public decimal TotalVenta { get; set; }
        public decimal SaldoPendiente { get; set; }
        public long IdEstadoPago { get; set; } // Catalog
        public string EstadoPago { get; set; } = string.Empty;
        public string Estado { get; set; } = string.Empty;
        public string TipoComprobante { get; set; } = string.Empty;
        public string? Observaciones { get; set; }
        public long? IdTipoOperacion { get; set; }

        public List<DetalleVentaDto> Detalles { get; set; } = new();
        public List<PagoDto> Pagos { get; set; } = new();
    }
}
