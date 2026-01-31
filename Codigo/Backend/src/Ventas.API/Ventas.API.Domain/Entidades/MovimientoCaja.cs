using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("movimientos_caja", Schema = "ventas")]
    public class MovimientoCaja : EntidadBase
    {
        [Column("id_movimiento_caja")]
        public override long Id { get; set; }

        [Column("id_caja")]
        public long IdCaja { get; set; }

        [Required]
        [Column("id_tipo_movimiento")]
        public long IdTipoMovimiento { get; set; }

        [Column("monto", TypeName = "decimal(12,2)")]
        public decimal Monto { get; set; }

        [Required]
        [MaxLength(255)]
        [Column("concepto")]
        public string Concepto { get; set; } = null!;

        [Column("id_pago_relacionado")]
        public long? IdPagoRelacionado { get; set; }

        [Column("fecha_movimiento")]
        public DateTime FechaMovimiento { get; set; } = DateTime.UtcNow;

        [Required]
        [MaxLength(100)]
        [Column("usuario_responsable")]
        public string UsuarioResponsable { get; set; } = null!;

        [ForeignKey("IdCaja")]
        public virtual Caja Caja { get; set; } = null!;

        [ForeignKey("IdPagoRelacionado")]
        public virtual Pago? PagoRelacionado { get; set; }
    }
}
