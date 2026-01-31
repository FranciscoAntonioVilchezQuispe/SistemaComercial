using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("cotizaciones", Schema = "ventas")]
    public class Cotizacion : EntidadBase
    {
        [Column("id_cotizacion")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("numero")]
        public long Numero { get; set; }

        [Column("id_cliente")]
        public long IdCliente { get; set; }

        [Column("id_usuario_vendedor")]
        public long IdUsuarioVendedor { get; set; }

        [Column("fecha_emision")]
        public DateTime FechaEmision { get; set; }

        [Column("fecha_vencimiento")]
        public DateTime FechaVencimiento { get; set; }

        [Required]
        [Column("id_estado")]
        public long IdEstado { get; set; }

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

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        [ForeignKey("IdCliente")]
        public virtual Cliente Cliente { get; set; } = null!;

        public virtual ICollection<DetalleCotizacion> Detalles { get; set; } = new List<DetalleCotizacion>();
    }
}
