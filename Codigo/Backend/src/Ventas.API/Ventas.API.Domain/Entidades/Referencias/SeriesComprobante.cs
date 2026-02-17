using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("series_comprobantes", Schema = "configuracion")]
    public class SeriesComprobante : EntidadBase
    {
        [Column("id_serie")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("correlativo_actual")]
        public long CorrelativoActual { get; set; }

        [Column("id_almacen")]
        public long? IdAlmacen { get; set; }

        [Column("id_tipo_comprobante")]
        public long? IdTipoComprobante { get; set; }
    }
}
