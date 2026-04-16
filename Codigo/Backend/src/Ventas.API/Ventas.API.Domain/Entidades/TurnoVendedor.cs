using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("turno_vendedor", Schema = "ventas")]
    public class TurnoVendedor : EntidadBase
    {
        [Column("id_turno_vendedor")]
        public override long Id { get; set; }

        [Required]
        [Column("id_usuario_vendedor")]
        public long UsuarioVendedorId { get; set; }

        [Required]
        [Column("id_caja")]
        public long CajaId { get; set; }

        [Required]
        [Column("fecha_inicio")]
        public DateTime FechaInicio { get; set; }

        [Column("fecha_fin")]
        public DateTime? FechaFin { get; set; }

        [Required]
        [Column("monto_apertura", TypeName = "decimal(12,2)")]
        public decimal MontoApertura { get; set; }

        [Column("monto_cierre", TypeName = "decimal(12,2)")]
        public decimal? MontoCierre { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("estado")]
        public string Estado { get; set; } = "ABIERTO"; // ABIERTO, CERRADO

        [ForeignKey("CajaId")]
        public virtual Caja Caja { get; set; } = null!;

        public virtual ICollection<Venta> Ventas { get; set; } = new List<Venta>();
        
        // Relación 1 a 1 con CierreTurno
        public virtual CierreTurno? CierreTurno { get; set; }
    }
}
