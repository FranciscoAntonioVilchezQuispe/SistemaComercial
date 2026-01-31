using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("pagos", Schema = "ventas")]
    public class Pago : EntidadBase
    {
        [Column("id_pago")]
        public override long Id { get; set; }

        [Column("id_venta")]
        public long IdVenta { get; set; }

        [Column("id_metodo_pago")]
        public long IdMetodoPago { get; set; }

        [Column("monto_pago", TypeName = "decimal(12,2)")]
        public decimal MontoPago { get; set; }

        [MaxLength(100)]
        [Column("referencia_pago")]
        public string? ReferenciaPago { get; set; }

        [Column("fecha_pago")]
        public DateTime FechaPago { get; set; } = DateTime.UtcNow;

        [ForeignKey("IdVenta")]
        public virtual Venta Venta { get; set; } = null!;

        [ForeignKey("IdMetodoPago")]
        public virtual MetodoPago MetodoPago { get; set; } = null!;
    }
}
