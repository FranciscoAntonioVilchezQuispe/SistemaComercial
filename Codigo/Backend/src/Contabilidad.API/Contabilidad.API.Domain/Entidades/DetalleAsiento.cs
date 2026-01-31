using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contabilidad.API.Domain.Entidades
{
    [Table("detalle_asiento", Schema = "contabilidad")]
    public class DetalleAsiento : EntidadBase
    {
        [Column("id_detalle_asiento")]
        public override long Id { get; set; }

        [Column("id_asiento")]
        public long IdAsiento { get; set; }

        [Column("id_cuenta")]
        public long IdCuenta { get; set; }

        [Column("id_centro_costo")]
        public long? IdCentroCosto { get; set; }

        [Column("debe", TypeName = "decimal(12,2)")]
        public decimal Debe { get; set; } = 0;

        [Column("haber", TypeName = "decimal(12,2)")]
        public decimal Haber { get; set; } = 0;

        [MaxLength(255)]
        [Column("nota")]
        public string? Nota { get; set; }

        [ForeignKey("IdAsiento")]
        public virtual AsientoContable Asiento { get; set; } = null!;

        [ForeignKey("IdCuenta")]
        public virtual PlanCuenta Cuenta { get; set; } = null!;
    }
}
