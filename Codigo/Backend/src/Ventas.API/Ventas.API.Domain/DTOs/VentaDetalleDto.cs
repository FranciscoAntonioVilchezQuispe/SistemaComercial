using System;
using System.Collections.Generic;

namespace Ventas.API.Domain.DTOs
{
    /// <summary>
    /// DTO de detalle completo para vista previa o edición de ventas.
    /// Sigue la arquitectura de endpoints segregados (Lista vs Detalle).
    /// </summary>
    public class VentaDetalleDto
    {
        public long Id { get; set; }
        public long IdEmpresa { get; set; }
        public long IdAlmacen { get; set; }
        public long? IdCaja { get; set; }
        public long IdCliente { get; set; }
        public string NombreCliente { get; set; } = string.Empty;
        public string NumeroDocumentoCliente { get; set; } = string.Empty;
        public long IdUsuarioVendedor { get; set; }
        public long? IdCotizacionOrigen { get; set; }
        public long IdTipoComprobante { get; set; }
        public string TipoComprobante { get; set; } = string.Empty;
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string NumeroFormateado => Numero.ToString().PadLeft(8, '0');
        public DateTime FechaEmision { get; set; }
        public DateTime? FechaVencimientoPago { get; set; }
        public long IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string Moneda { get; set; } = "PEN";
        public decimal TipoCambio { get; set; }
        public decimal SubtotalGravado { get; set; }
        public decimal SubtotalExonerado { get; set; }
        public decimal SubtotalInafecto { get; set; }
        public decimal TotalImpuesto { get; set; }
        public decimal TotalDescuentoGlobal { get; set; }
        public decimal TotalVenta { get; set; }
        public decimal SaldoPendiente { get; set; }
        public long IdEstadoPago { get; set; }
        public string EstadoPago { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public string? Observaciones { get; set; }

        public List<DetalleVentaDto> Detalles { get; set; } = new();
        public List<PagoDto> Pagos { get; set; } = new();
    }
}
