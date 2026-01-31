using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("permisos", Schema = "identidad")]
    public class Permiso : EntidadBase
    {
        [Column("id_permiso")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("codigo_permiso")]
        public string CodigoPermiso { get; set; } = null!; // Ej: VENTAS_CREAR

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [MaxLength(50)]
        [Column("modulo")]
        public string? Modulo { get; set; }

        public virtual ICollection<RolPermiso> RolesPermisos { get; set; } = new List<RolPermiso>();
    }
}
