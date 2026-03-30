using System;
using System.Collections.Generic;
using Ventas.API.Domain.DTOs;

namespace Ventas.API.Application.DTOs
{
    public class NotaCreditoDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string TipoComprobante { get; set; } = "07";

        public long IdVentaReferencia { get; set; }
        public string SerieReferencia { get; set; } = null!;
        public long NumeroReferencia { get; set; }
        public string TipoDocReferencia { get; set; } = null!;

        public long IdTipoNota { get; set; } // Motivo SUNAT
        public string MotivoSustento { get; set; } = null!;

        public long IdCliente { get; set; }
        public string ClienteTipoDoc { get; set; } = null!;
        public string ClienteNroDoc { get; set; } = null!;
        public string ClienteRazonSocial { get; set; } = null!;

        public decimal Subtotal { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
        public string Moneda { get; set; } = "PEN";
        public decimal? TipoCambio { get; set; }

        public bool AfectaStock { get; set; }
        public DateTime FechaEmision { get; set; }
        public string Estado { get; set; } = "PENDIENTE";

        public List<NotaCreditoDetalleDto> Detalles { get; set; } = new();
    }

    public class NotaCreditoDetalleDto
    {
        public long Id { get; set; }
        public long? IdVentaDetalle { get; set; }
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
