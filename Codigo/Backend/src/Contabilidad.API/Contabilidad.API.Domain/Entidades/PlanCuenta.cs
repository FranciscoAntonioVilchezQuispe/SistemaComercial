using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contabilidad.API.Domain.Entidades
{
    [Table("plan_cuentas", Schema = "contabilidad")]
    public class PlanCuenta : EntidadBase
    {
        [Column("id_cuenta")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo_cuenta")]
        public string CodigoCuenta { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        [Column("nombre_cuenta")]
        public string NombreCuenta { get; set; } = null!;

        [Required]
        [Column("id_tipo_cuenta")]
        public long IdTipoCuenta { get; set; }

        [Column("nivel")]
        public int Nivel { get; set; } = 1;

        [Column("id_cuenta_padre")]
        public long? IdCuentaPadre { get; set; }

        [Column("permite_asientos")]
        public bool PermiteAsientos { get; set; } = true;

        [ForeignKey("IdCuentaPadre")]
        public virtual PlanCuenta? CuentaPadre { get; set; }
        public virtual ICollection<PlanCuenta> SubCuentas { get; set; } = new List<PlanCuenta>();
    }
}
