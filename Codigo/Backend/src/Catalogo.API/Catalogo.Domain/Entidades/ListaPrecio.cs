using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Catalogo.Domain.Entidades
{
    [Table("listas_precios", Schema = "catalogo")]
    public class ListaPrecio : EntidadBase
    {
        [Column("id_lista_precio")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("nombre_lista")]
        public string NombreLista { get; set; } = null!;

        [Column("es_base")]
        public bool EsBase { get; set; } = false;

        [Column("porcentaje_ganancia_sugerido", TypeName = "decimal(5,2)")]
        public decimal? PorcentajeGananciaSugerido { get; set; }
    }
}
