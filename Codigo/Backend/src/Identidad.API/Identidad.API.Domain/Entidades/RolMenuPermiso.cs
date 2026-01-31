using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("roles_menus_permisos", Schema = "identidad")]
    public class RolMenuPermiso : EntidadBase
    {
        [Column("id_rol_menu_permiso")]
        public override long Id { get; set; }

        [Required]
        [Column("id_rol_menu")]
        public long IdRolMenu { get; set; }

        [Required]
        [Column("id_tipo_permiso")]
        public long IdTipoPermiso { get; set; }

        // Navegación
        [ForeignKey("IdRolMenu")]
        public virtual RolMenu RolMenu { get; set; } = null!;

        [ForeignKey("IdTipoPermiso")]
        public virtual TipoPermiso TipoPermiso { get; set; } = null!;
    }
}
