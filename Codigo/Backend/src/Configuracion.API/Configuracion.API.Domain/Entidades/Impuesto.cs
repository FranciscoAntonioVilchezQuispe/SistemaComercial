using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("impuestos", Schema = "configuracion")]
    public class Impuesto : EntidadBase
    {
        [Column("id_impuesto")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("porcentaje", TypeName = "decimal(5,2)")]
        public decimal Porcentaje { get; set; }

        [Column("es_igv")]
        public bool EsIgv { get; set; }
    }
}
