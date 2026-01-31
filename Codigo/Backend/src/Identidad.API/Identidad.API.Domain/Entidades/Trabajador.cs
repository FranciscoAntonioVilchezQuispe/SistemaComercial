using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("trabajadores", Schema = "identidad")]
    public class Trabajador : EntidadBase
    {
        [Column("id_trabajador")]
        public override long Id { get; set; }

        [Required]
        [Column("id_tipo_documento")]
        public long IdTipoDocumento { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("numero_documento")]
        public string NumeroDocumento { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombres")]
        public string Nombres { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("apellidos")]
        public string Apellidos { get; set; } = null!;

        [Column("fecha_nacimiento")]
        public DateTime? FechaNacimiento { get; set; }

        [MaxLength(20)]
        [Column("telefono")]
        public string? Telefono { get; set; }

        [MaxLength(100)]
        [Column("email_corporativo")]
        public string? EmailCorporativo { get; set; }

        [Column("id_cargo")]
        public long? IdCargo { get; set; }

        [Column("id_usuario")]
        public long? IdUsuario { get; set; }

        [ForeignKey("IdCargo")]
        public virtual Cargo? Cargo { get; set; }

        [ForeignKey("IdUsuario")]
        public virtual Usuario? Usuario { get; set; }
    }
}
