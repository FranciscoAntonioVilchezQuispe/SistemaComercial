using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("tipo_afectacion_igv", Schema = "configuracion")]
    public class TipoAfectacionIgvRef
    {
        [Column("id_afectacion")]
        public long Id { get; set; }

        [Column("codigo_sunat")]
        public string CodigoSunat { get; set; } = null!;

        [Column("descripcion")]
        public string Descripcion { get; set; } = null!;

        [Column("es_gravado")]
        public bool EsGravado { get; set; }

        [Column("es_exonerado")]
        public bool EsExonerado { get; set; }

        [Column("es_inafecto")]
        public bool EsInafecto { get; set; }

        [Column("es_gratuito")]
        public bool EsGratuito { get; set; }
    }
}
