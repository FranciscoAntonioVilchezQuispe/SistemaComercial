using System;
using System.Collections.Generic;

namespace Compras.API.Application.DTOs
{
    public class NotaDebitoCompraDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public string TipoComprobante { get; set; } = "08";

        public long IdCompraReferencia { get; set; }
        public string? SerieReferencia { get; set; }
        public string? NumeroReferencia { get; set; }
        public string? TipoDocReferencia { get; set; }

        public long IdTipoNota { get; set; }
        public string MotivoSustento { get; set; } = null!;

        public long? IdProveedor { get; set; }
        public string? ProveedorTipoDoc { get; set; }
        public string? ProveedorNroDoc { get; set; }
        public string? ProveedorRazonSocial { get; set; }

        public decimal Subtotal { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
        public string Moneda { get; set; } = "PEN";
        public decimal? TipoCambio { get; set; }

        public bool AfectaStock { get; set; }
        public DateTime FechaEmision { get; set; }
        public string Estado { get; set; } = "PENDIENTE";

        public List<NotaDebitoDetalleCompraDto> Detalles { get; set; } = new();
    }

    public class NotaDebitoDetalleCompraDto
    {
        public long Id { get; set; }
        public long? IdCompraDetalle { get; set; }
        public long IdProducto { get; set; }
        public string Descripcion { get; set; } = null!;
        public string UnidadMedida { get; set; } = "NIU";
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
    }
}
