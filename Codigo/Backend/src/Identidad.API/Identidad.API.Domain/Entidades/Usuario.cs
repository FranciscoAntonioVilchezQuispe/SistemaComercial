using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("usuarios", Schema = "identidad")]
    public class Usuario : EntidadBase
    {
        [Column("id_usuario")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("username")]
        public string Username { get; set; } = null!;

        [Required]
        [MaxLength(255)]
        [Column("password_hash")]
        public string PasswordHash { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("email")]
        public string Email { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombres")]
        public string Nombres { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("apellidos")]
        public string Apellidos { get; set; } = null!;

        [Column("ultimo_acceso")]
        public DateTime? UltimoAcceso { get; set; }

        // Navegación - Un usuario puede tener múltiples roles
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
    }
}
