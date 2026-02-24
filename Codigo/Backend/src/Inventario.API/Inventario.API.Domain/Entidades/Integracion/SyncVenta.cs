using System;
using System.Collections.Generic;

namespace Inventario.API.Domain.Entidades.Integracion
{
    public class SyncVenta
    {
        public long IdVenta { get; set; }
        public long IdAlmacen { get; set; }
        public long IdTipoComprobante { get; set; }
        public string? Serie { get; set; }
        public long Numero { get; set; }
        public DateTime FechaEmision { get; set; }

        public ICollection<SyncDetalleVenta> Detalles { get; set; } = new List<SyncDetalleVenta>();
    }

    public class SyncDetalleVenta
    {
        public long Id { get; set; }
        public long IdVenta { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        public SyncVenta Venta { get; set; } = null!;
    }
}
