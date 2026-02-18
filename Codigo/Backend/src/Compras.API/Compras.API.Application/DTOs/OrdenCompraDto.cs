using System;
using System.Collections.Generic;

namespace Compras.API.Application.DTOs
{


    public class DetalleOrdenCompraDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public long? IdVariante { get; set; }
        public decimal CantidadSolicitada { get; set; }
        public decimal PrecioUnitarioPactado { get; set; }
        public decimal Subtotal { get; set; }
        public decimal? CantidadRecibida { get; set; }
    }

    public class OrdenCompraDto
    {
        public long Id { get; set; }
        public string? CodigoOrden { get; set; }
        public long IdProveedor { get; set; }
        public long IdAlmacenDestino { get; set; }
        public DateTime FechaEmision { get; set; }
        public DateTime? FechaEntregaEstimada { get; set; }
        public long IdEstado { get; set; } // Catalog ID
        public decimal TotalImporte { get; set; }
        public string? Observaciones { get; set; }
        public long? IdTipoComprobante { get; set; }
        public string? Serie { get; set; }
        public string? Numero { get; set; }
        public List<DetalleOrdenCompraDto> Detalles { get; set; } = new();
    }
}
