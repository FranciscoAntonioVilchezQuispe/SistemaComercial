using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Kardex
{
    [Table("inv_kardex_recalculo_log", Schema = "inventario")]
    public class KardexRecalculoLog
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("id")]
        public long Id { get; set; }

        [Column("almacen_id")]
        public int AlmacenId { get; set; }

        [Column("producto_id")]
        public int ProductoId { get; set; }

        [Column("desde_fecha")]
        public DateOnly DesdeFecha { get; set; }

        [Required]
        [MaxLength(30)]
        [Column("motivo")]
        public string Motivo { get; set; } = null!; // ENUM texto: 'ANULACION', etc.

        [Column("registros_afect")]
        public int RegistrosAfect { get; set; }

        [Column("usuario_id")]
        public int UsuarioId { get; set; }

        [Column("duracion_ms")]
        public int? DuracionMs { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
