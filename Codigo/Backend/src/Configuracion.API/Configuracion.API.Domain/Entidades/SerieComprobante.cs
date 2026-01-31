using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("series_comprobantes", Schema = "configuracion")]
    public class SerieComprobante : EntidadBase
    {
        [Column("id_serie")]
        public override long Id { get; set; }

        [Required]
        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [ForeignKey("IdTipoComprobante")]
        public TipoComprobante? TipoComprobante { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("correlativo_actual")]
        public long CorrelativoActual { get; set; } = 0;

        [Column("id_almacen")]
        public long? IdAlmacen { get; set; }
    }
}
