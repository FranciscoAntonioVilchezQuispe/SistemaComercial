using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("venta_cuota_pago", Schema = "ventas")]
    public class VentaCuotaPago : EntidadBase
    {
        [Key]
        [Column("id_cuota")]
        public override long Id { get; set; }

        [Column("id_venta")]
        public long IdVenta { get; set; }

        [Column("numero_cuota")]
        public int NumeroCuota { get; set; }

        [Column("monto_cuota", TypeName = "decimal(18,2)")]
        public decimal MontoCuota { get; set; }

        [Column("fecha_vencimiento", TypeName = "date")]
        public DateTime FechaVencimiento { get; set; }

        [Column("fecha_pago", TypeName = "date")]
        public DateTime? FechaPago { get; set; }

        [Column("pagado")]
        public bool Pagado { get; set; } = false;

        [ForeignKey("IdVenta")]
        public virtual Venta Venta { get; set; } = null!;
    }
}
