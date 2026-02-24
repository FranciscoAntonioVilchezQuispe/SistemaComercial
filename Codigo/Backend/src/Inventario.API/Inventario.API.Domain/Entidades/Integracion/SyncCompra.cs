using System;
using System.Collections.Generic;

namespace Inventario.API.Domain.Entidades.Integracion
{
    public class SyncCompra
    {
        public long IdCompra { get; set; }
        public long IdAlmacen { get; set; }
        public long IdTipoComprobante { get; set; }
        public string? SerieComprobante { get; set; }
        public string? NumeroComprobante { get; set; }
        public DateTime FechaEmision { get; set; }

        public ICollection<SyncDetalleCompra> Detalles { get; set; } = new List<SyncDetalleCompra>();
    }

    public class SyncDetalleCompra
    {
        public long Id { get; set; }
        public long IdCompra { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitarioCompra { get; set; }

        public SyncCompra Compra { get; set; } = null!;
    }
}
