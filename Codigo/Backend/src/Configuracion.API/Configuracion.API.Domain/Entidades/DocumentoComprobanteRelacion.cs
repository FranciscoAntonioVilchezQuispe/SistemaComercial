using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("regla_documento_comprobante", Schema = "configuracion")]
    public class DocumentoComprobanteRelacion : EntidadBase
    {
        [Column("id_relacion")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo_documento")]
        public string CodigoDocumento { get; set; } = null!;

        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        // Navegación opcional
        [ForeignKey("IdTipoComprobante")]
        public virtual TipoComprobante TipoComprobante { get; set; } = null!;
    }
}
