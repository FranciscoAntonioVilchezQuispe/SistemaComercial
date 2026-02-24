using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Kardex
{
    [Table("inv_kardex_periodo_control", Schema = "inventario")]
    public class KardexPeriodoControl
    {
        [Key]
        [MaxLength(7)]
        [Column("periodo")]
        public string Periodo { get; set; } = null!; // 'YYYY-MM'

        [Required]
        [MaxLength(1)]
        [Column("estado")]
        public string Estado { get; set; } = "A"; // 'A'=Abierto, 'C'=Cerrado, 'B'=Bloqueado

        [Column("fecha_cierre", TypeName = "date")]
        public DateTime? FechaCierre { get; set; }

        [Column("usuario_cierre_id")]
        public long? UsuarioCierreId { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        [Column("updated_at")]
        public DateTime? UpdatedAt { get; set; }
    }
}
