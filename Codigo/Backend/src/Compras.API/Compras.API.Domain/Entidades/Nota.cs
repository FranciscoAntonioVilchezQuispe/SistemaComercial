using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("notas", Schema = "compras")]
    public class Nota : EntidadBase
    {
        [Column("id_nota")]
        public override long Id { get; set; }

        [Column("id_compra_referencia")]
        public long IdCompraReferencia { get; set; }

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

        [Required]
        [Column("motivo_sustento", TypeName = "text")]
        public string MotivoSustento { get; set; } = null!;

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("impuesto", TypeName = "decimal(12,2)")]
        public decimal Impuesto { get; set; }

        [Column("total", TypeName = "decimal(12,2)")]
        public decimal Total { get; set; }

        [ForeignKey("IdCompraReferencia")]
        public virtual Compra Compra { get; set; } = null!;

        public virtual ICollection<DetalleNota> Detalles { get; set; } = new List<DetalleNota>();
    }
}
