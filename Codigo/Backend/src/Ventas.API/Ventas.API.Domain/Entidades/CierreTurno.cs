using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("cierre_turno", Schema = "ventas")]
    public class CierreTurno : EntidadBase
    {
        [Column("id_cierre_turno")]
        public override long Id { get; set; }

        [Required]
        [Column("id_turno_vendedor")]
        public long TurnoVendedorId { get; set; }

        [Required]
        [Column("fecha_generacion")]
        public DateTime FechaGeneracion { get; set; }

        [Column("total_ventas", TypeName = "decimal(12,2)")]
        public decimal TotalVentas { get; set; }

        [Column("total_efectivo", TypeName = "decimal(12,2)")]
        public decimal TotalEfectivo { get; set; }

        [Column("total_tarjeta", TypeName = "decimal(12,2)")]
        public decimal TotalTarjeta { get; set; }

        [Column("total_transferencia", TypeName = "decimal(12,2)")]
        public decimal TotalTransferencia { get; set; }

        [Column("total_otros", TypeName = "decimal(12,2)")]
        public decimal TotalOtros { get; set; }

        [Column("cantidad_transacciones")]
        public int CantidadTransacciones { get; set; }

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("estado")]
        public string Estado { get; set; } = "CONFIRMADO"; // BORRADOR, CONFIRMADO

        [ForeignKey("TurnoVendedorId")]
        public virtual TurnoVendedor TurnoVendedor { get; set; } = null!;
    }
}
