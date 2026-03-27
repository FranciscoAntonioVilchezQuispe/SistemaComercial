using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Maestros
{
    [Table("unidades_medida", Schema = "catalogo")]
    public class UnidadMedida : EntidadBase
    {
        [Column("id_unidad")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("nombre_unidad")]
        public string NombreUnidad { get; set; } = null!;

        [Required]
        [MaxLength(10)]
        [Column("simbolo")]
        public string Simbolo { get; set; } = null!;
    }
}
