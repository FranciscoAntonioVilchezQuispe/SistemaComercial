using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("usuarios_roles", Schema = "identidad")]
    public class UsuarioRol : EntidadBase
    {
        [Column("id_usuario_rol")]
        public override long Id { get; set; }

        [Required]
        [Column("id_usuario")]
        public long IdUsuario { get; set; }

        [Required]
        [Column("id_rol")]
        public long IdRol { get; set; }

        // Navegación
        [ForeignKey("IdUsuario")]
        public virtual Usuario Usuario { get; set; } = null!;

        [ForeignKey("IdRol")]
        public virtual Rol Rol { get; set; } = null!;
    }
}
