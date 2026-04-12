using System;
using System.Collections.Generic;

namespace Inventario.API.Domain.Entidades.Integracion
{
    public class SyncNotaCreditoVenta
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public long IdVentaReferencia { get; set; }
        public DateTime FechaEmision { get; set; }
        public long IdAlmacen { get; set; }
        public decimal Total { get; set; }
        public bool AfectaStock { get; set; }

        public SyncVenta Venta { get; set; } = null!;
        public ICollection<SyncDetalleNotaCreditoVenta> Detalles { get; set; } = new List<SyncDetalleNotaCreditoVenta>();
    }

    public class SyncDetalleNotaCreditoVenta
    {
        public long Id { get; set; }
        public long IdNota { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        public SyncNotaCreditoVenta Nota { get; set; } = null!;
    }

    public class SyncNotaDebitoVenta
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public long IdVentaReferencia { get; set; }
        public DateTime FechaEmision { get; set; }
        public long IdAlmacen { get; set; }
        public decimal Total { get; set; }
        public bool AfectaStock { get; set; }

        public SyncVenta Venta { get; set; } = null!;
        public ICollection<SyncDetalleNotaDebitoVenta> Detalles { get; set; } = new List<SyncDetalleNotaDebitoVenta>();
    }

    public class SyncDetalleNotaDebitoVenta
    {
        public long Id { get; set; }
        public long IdNota { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        public SyncNotaDebitoVenta Nota { get; set; } = null!;
    }
}
