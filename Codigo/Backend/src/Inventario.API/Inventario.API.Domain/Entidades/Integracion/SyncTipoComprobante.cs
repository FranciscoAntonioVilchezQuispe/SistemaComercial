using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Integracion
{
    [Table("sync_tipos_comprobante", Schema = "inventario")]
    public class SyncTipoComprobante
    {
        [Key]
        [Column("id_tipo_comprobante")]
        public long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("activo")]
        public bool Activo { get; set; } = true;
    }
}
