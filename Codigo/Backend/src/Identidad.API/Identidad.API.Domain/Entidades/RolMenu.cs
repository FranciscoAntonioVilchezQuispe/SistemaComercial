using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("roles_menus", Schema = "identidad")]
    public class RolMenu : EntidadBase
    {
        [Column("id_rol_menu")]
        public override long Id { get; set; }

        [Required]
        [Column("id_rol")]
        public long IdRol { get; set; }

        [Required]
        [Column("id_menu")]
        public long IdMenu { get; set; }

        // Navegación
        [ForeignKey("IdRol")]
        public virtual Rol Rol { get; set; } = null!;

        [ForeignKey("IdMenu")]
        public virtual Menu Menu { get; set; } = null!;

        public virtual ICollection<RolMenuPermiso> Permisos { get; set; } = new List<RolMenuPermiso>();
    }
}
