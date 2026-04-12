using System;
using System.Collections.Generic;

namespace Inventario.API.Domain.Entidades.Integracion
{
    public class SyncNotaCreditoCompra
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public long IdCompraReferencia { get; set; }
        public DateTime FechaEmision { get; set; }
        public long IdProveedor { get; set; }
        public long IdAlmacen { get; set; }
        public decimal Total { get; set; }
        public bool AfectaStock { get; set; }

        public SyncCompra Compra { get; set; } = null!;
        public ICollection<SyncDetalleNotaCreditoCompra> Detalles { get; set; } = new List<SyncDetalleNotaCreditoCompra>();
    }

    public class SyncDetalleNotaCreditoCompra
    {
        public long Id { get; set; }
        public long IdNota { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        public SyncNotaCreditoCompra Nota { get; set; } = null!;
    }

    public class SyncNotaDebitoCompra
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public long IdCompraReferencia { get; set; }
        public DateTime FechaEmision { get; set; }
        public long IdProveedor { get; set; }
        public long IdAlmacen { get; set; }
        public decimal Total { get; set; }
        public bool AfectaStock { get; set; }

        public SyncCompra Compra { get; set; } = null!;
        public ICollection<SyncDetalleNotaDebitoCompra> Detalles { get; set; } = new List<SyncDetalleNotaDebitoCompra>();
    }

    public class SyncDetalleNotaDebitoCompra
    {
        public long Id { get; set; }
        public long IdNota { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }

        public SyncNotaDebitoCompra Nota { get; set; } = null!;
    }
}
