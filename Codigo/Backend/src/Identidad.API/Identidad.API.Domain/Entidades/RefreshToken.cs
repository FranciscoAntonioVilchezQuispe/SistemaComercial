using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("refresh_tokens", Schema = "identidad")]
    public class RefreshToken : EntidadBase
    {
        [Column("id_refresh_token")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(200)]
        [Column("token")]
        public string Token { get; set; } = null!;

        [Required]
        [Column("id_usuario")]
        public long UsuarioId { get; set; }

        [Column("fecha_expiracion")]
        public DateTime FechaExpiracion { get; set; }

        [Column("es_revocado")]
        public bool EsRevocado { get; set; }

        [ForeignKey("UsuarioId")]
        public virtual Usuario Usuario { get; set; } = null!;

        public bool EsActivo => EsRevocado == false && FechaExpiracion > DateTime.UtcNow;
    }
}
