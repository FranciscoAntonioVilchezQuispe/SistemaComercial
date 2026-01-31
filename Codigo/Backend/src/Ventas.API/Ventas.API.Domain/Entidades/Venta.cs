using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("ventas", Schema = "ventas")]
    public class Venta : EntidadBase
    {
        [Column("id_venta")]
        public override long Id { get; set; }

        [Column("id_empresa")]
        public long IdEmpresa { get; set; } = 1;

        [Column("id_almacen")]
        public long IdAlmacen { get; set; }

        [Column("id_caja")]
        public long? IdCaja { get; set; }

        [Column("id_cliente")]
        public long IdCliente { get; set; }

        [Column("id_usuario_vendedor")]
        public long IdUsuarioVendedor { get; set; }

        [Column("id_cotizacion_origen")]
        public long? IdCotizacionOrigen { get; set; }

        [Required]
        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("numero")]
        public long Numero { get; set; }

        [Column("fecha_emision")]
        public DateTime FechaEmision { get; set; }

        [Column("fecha_vencimiento_pago")]
        public DateTime? FechaVencimientoPago { get; set; }

        [Required]
        [Column("id_estado")]
        public long IdEstado { get; set; }

        [MaxLength(3)]
        [Column("moneda")]
        public string Moneda { get; set; } = "PEN";

        [Column("tipo_cambio", TypeName = "decimal(10,4)")]
        public decimal TipoCambio { get; set; } = 1.0m;

        [Column("subtotal_gravado", TypeName = "decimal(12,2)")]
        public decimal SubtotalGravado { get; set; }

        [Column("subtotal_exonerado", TypeName = "decimal(12,2)")]
        public decimal SubtotalExonerado { get; set; }

        [Column("subtotal_inafecto", TypeName = "decimal(12,2)")]
        public decimal SubtotalInafecto { get; set; }

        [Column("total_impuesto", TypeName = "decimal(12,2)")]
        public decimal TotalImpuesto { get; set; }

        [Column("total_descuento_global", TypeName = "decimal(12,2)")]
        public decimal TotalDescuentoGlobal { get; set; }

        [Column("total_venta", TypeName = "decimal(12,2)")]
        public decimal TotalVenta { get; set; }

        [Column("saldo_pendiente", TypeName = "decimal(12,2)")]
        public decimal SaldoPendiente { get; set; } = 0;

        [Column("id_estado_pago")]
        public long IdEstadoPago { get; set; }

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        [ForeignKey("IdCliente")]
        public virtual Cliente Cliente { get; set; } = null!;

        [ForeignKey("IdCaja")]
        public virtual Caja? Caja { get; set; }

        public virtual ICollection<DetalleVenta> Detalles { get; set; } = new List<DetalleVenta>();
        public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();
    }
}
