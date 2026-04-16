using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tipo_afectacion_igv", Schema = "configuracion")]
    public class TipoAfectacionIgv : EntidadBase
    {
        [Column("id_afectacion")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("codigo_sunat")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(150)]
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

        [MaxLength(4)]
        [Column("codigo_tributo_default")]
        public string? CodigoTributoDefault { get; set; } // Ejemplo: 1000 para IGV, 9997 para EXO

        [MaxLength(10)]
        [Column("nombre_tributo_default")]
        public string? NombreTributoDefault { get; set; } // Ejemplo: IGV, VAT, EXO
    }
}
