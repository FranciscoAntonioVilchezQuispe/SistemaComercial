using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contabilidad.API.Domain.Entidades
{
    [Table("asientos_contables", Schema = "contabilidad")]
    public class AsientoContable : EntidadBase
    {
        [Column("id_asiento")]
        public override long Id { get; set; }

        [Column("fecha_contable")]
        public DateTime FechaContable { get; set; }

        [Required]
        [MaxLength(7)]
        [Column("periodo")]
        public string Periodo { get; set; } = null!; // 2026-01

        [Required]
        [MaxLength(255)]
        [Column("glosa")]
        public string Glosa { get; set; } = null!;

        [Required]
        [MaxLength(50)]
        [Column("origen_modulo")]
        public string OrigenModulo { get; set; } = null!; // VENTAS, COMPRAS...

        [Column("id_origen_referencia")]
        public long? IdOrigenReferencia { get; set; }

        [Column("id_estado")]
        public long IdEstado { get; set; }

        [Column("total_debe", TypeName = "decimal(12,2)")]
        public decimal TotalDebe { get; set; }

        [Column("total_haber", TypeName = "decimal(12,2)")]
        public decimal TotalHaber { get; set; }

        public virtual ICollection<DetalleAsiento> Detalles { get; set; } = new List<DetalleAsiento>();
    }
}
