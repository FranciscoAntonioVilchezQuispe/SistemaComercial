using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("notas", Schema = "ventas")]
    public class Nota : EntidadBase
    {
        [Column("id_nota")]
        public override long Id { get; set; }

        [Column("id_venta_referencia")]
        public long IdVentaReferencia { get; set; }

        [Column("id_tipo_nota")]
        public long IdTipoNota { get; set; }

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

        [Required]
        [Column("motivo_sustento", TypeName = "text")]
        public string MotivoSustento { get; set; } = null!;

        [Required]
        [MaxLength(3)]
        [Column("moneda")]
        public string Moneda { get; set; } = "PEN";

        [Column("tipo_cambio", TypeName = "decimal(10,4)")]
        public decimal TipoCambio { get; set; } = 1.0m;

        [Column("subtotal_gravado", TypeName = "decimal(12,2)")]
        public decimal SubtotalGravado { get; set; }

        [Column("total_impuesto", TypeName = "decimal(12,2)")]
        public decimal TotalImpuesto { get; set; }

        [Column("total_nota", TypeName = "decimal(12,2)")]
        public decimal TotalNota { get; set; }

        [Column("id_estado")]
        public long IdEstado { get; set; }

        [ForeignKey("IdVentaReferencia")]
        public virtual Venta Venta { get; set; } = null!;

        public virtual ICollection<DetalleNota> Detalles { get; set; } = new List<DetalleNota>();
    }
}
