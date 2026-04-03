using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("impuestos", Schema = "configuracion")]
    public class ImpuestoReferencia : EntidadBase
    {
        [Column("id_impuesto")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("codigo_sunat")]
        public string CodigoSunat { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("porcentaje", TypeName = "decimal(5,2)")]
        public decimal Porcentaje { get; set; }

        [Column("es_porcentaje")]
        public bool EsPorcentaje { get; set; }
    }
}
