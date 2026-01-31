using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("roles", Schema = "identidad")]
    public class Rol : EntidadBase
    {
        [Column("id_rol")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("nombre_rol")]
        public string NombreRol { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        // Navegación
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
        public virtual ICollection<RolPermiso> RolesPermisos { get; set; } = new List<RolPermiso>();
        public virtual ICollection<RolMenu> RolesMenus { get; set; } = new List<RolMenu>();
    }
}
