using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Referencias
{
    [Table("series_comprobantes", Schema = "configuracion")]
    public class SerieComprobanteReferencia
    {
        [Key]
        [Column("id_serie")]
        public long Id { get; set; }

        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [ForeignKey("IdTipoComprobante")]
        public TipoComprobanteReferencia? TipoComprobante { get; set; }

        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("correlativo_actual")]
        public int CorrelativoActual { get; set; }

        [Column("fecha_creacion")]
        public DateTime FechaCreacion { get; set; }
    }
}
