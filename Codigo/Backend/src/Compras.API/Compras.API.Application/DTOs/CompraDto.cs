using System;
using System.Collections.Generic;

namespace Compras.API.Application.DTOs
{
    public class DetalleCompraDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public string? NombreProducto { get; set; }
        public long? IdVariante { get; set; }
        public string? Descripcion { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitarioCompra { get; set; }
        public decimal Subtotal { get; set; }
        public string AfectacionIgv { get; set; } = "G";
    }

    public class CompraDto
    {
        public long Id { get; set; }
        public long IdProveedor { get; set; }
        public string? RazonSocialProveedor { get; set; }
        public long IdAlmacen { get; set; }
        public string? NombreAlmacen { get; set; }
        public long? IdOrdenCompraRef { get; set; }
        public long IdTipoComprobante { get; set; }
        public string? NombreTipoComprobante { get; set; }
        public string SerieComprobante { get; set; } = null!;
        public string NumeroComprobante { get; set; } = null!;
        public DateTime FechaEmision { get; set; }
        public DateTime FechaContable { get; set; }
        public DateTime? FechaVencimiento { get; set; }
        public long IdMoneda { get; set; }
        public string Moneda { get; set; } = "PEN";
        public decimal TipoCambio { get; set; }
        public decimal Subtotal { get; set; }
        public decimal BaseGravada { get; set; }
        public decimal BaseExonerada { get; set; }
        public decimal BaseInafecta { get; set; }
        public decimal Impuesto { get; set; }
        public decimal Total { get; set; }
        public decimal? SaldoPendiente { get; set; }
        public long IdEstadoPago { get; set; }

        public string? Observaciones { get; set; }
        public string? NumeroDocumentoProveedor { get; set; }
        public string? NombreTipoDocumentoProveedor { get; set; }
        public long? IdTipoDocumentoProveedor { get; set; }

        public List<DetalleCompraDto> Detalles { get; set; } = new();
    }
}
