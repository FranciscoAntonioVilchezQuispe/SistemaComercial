using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("compras", Schema = "compras")]
    public class Compra : EntidadBase
    {
        [Column("id_compra")]
        public override long Id { get; set; }

        [Column("id_proveedor")]
        public long IdProveedor { get; set; }

        [Column("id_almacen")]
        public long IdAlmacen { get; set; }

        [Column("id_orden_compra_ref")]
        public long? IdOrdenCompraRef { get; set; }

        [Required]
        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("serie_comprobante")]
        public string SerieComprobante { get; set; } = null!;

        [Required]
        [MaxLength(20)]
        [Column("numero_comprobante")]
        public string NumeroComprobante { get; set; } = null!;

        [Column("fecha_emision")]
        public DateTime FechaEmision { get; set; }

        [Column("fecha_contable")]
        public DateTime FechaContable { get; set; }

        [MaxLength(3)]
        [Column("moneda")]
        public string Moneda { get; set; } = "PEN";

        [Column("tipo_cambio", TypeName = "decimal(10,4)")]
        public decimal TipoCambio { get; set; } = 1.0m;

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("impuesto", TypeName = "decimal(12,2)")]
        public decimal Impuesto { get; set; }

        [Column("total", TypeName = "decimal(12,2)")]
        public decimal Total { get; set; }

        [Column("saldo_pendiente", TypeName = "decimal(12,2)")]
        public decimal? SaldoPendiente { get; set; }

        [Column("id_estado_pago")]
        public long IdEstadoPago { get; set; }

        [MaxLength(500)]
        [Column("observaciones")]
        public string? Observaciones { get; set; }

        [ForeignKey("IdProveedor")]
        public virtual Proveedor Proveedor { get; set; } = null!;

        [NotMapped]
        public string? NombreAlmacen { get; set; }
        [NotMapped]
        public string? NombreTipoComprobante { get; set; }
        [NotMapped]
        public string? NombreTipoDocumentoProveedor { get; set; }

        public virtual ICollection<DetalleCompra> Detalles { get; set; } = new List<DetalleCompra>();
    }
}
