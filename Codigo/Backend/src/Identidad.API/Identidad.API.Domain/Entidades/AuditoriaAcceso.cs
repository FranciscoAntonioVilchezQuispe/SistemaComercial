using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Identidad.API.Domain.Entidades
{
    [Table("auditoria_accesos", Schema = "identidad")]
    public class AuditoriaAcceso
    {
        [Key]
        [Column("id_auditoria")]
        public long IdAuditoria { get; set; }

        [Column("id_usuario")]
        public long IdUsuario { get; set; }

        [MaxLength(50)]
        [Column("ip_origen")]
        public string? IpOrigen { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("accion")]
        public string Accion { get; set; } = null!; // LOGIN, LOGOUT...

        [Column("detalles", TypeName = "text")]
        public string? Detalles { get; set; }

        [Column("fecha_evento")]
        public DateTime FechaEvento { get; set; } = DateTime.UtcNow;
    }
}
