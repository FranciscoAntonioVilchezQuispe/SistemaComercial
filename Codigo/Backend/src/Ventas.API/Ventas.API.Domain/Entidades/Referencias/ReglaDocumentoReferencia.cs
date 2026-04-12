using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("regla_documento_comprobante", Schema = "configuracion")]
    public class ReglaDocumentoReferencia
    {
        [Column("id_relacion")]
        public long Id { get; set; }

        [Column("codigo_documento")]
        public string CodigoDocumento { get; set; } = null!;

        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }
        
        [Column("activado")]
        public bool Activado { get; set; }
    }
}
