using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Catalogo.Domain.Entidades
{
    [Table("categorias", Schema = "catalogo")]
    public class Categoria : EntidadBase
    {
        [Column("id_categoria")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_categoria")]
        public string NombreCategoria { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [Column("id_categoria_padre")]
        public long? IdCategoriaPadre { get; set; }

        [MaxLength(500)]
        [Column("imagen_url")]
        public string? ImagenUrl { get; set; }

        [ForeignKey("IdCategoriaPadre")]
        public virtual Categoria? CategoriaPadre { get; set; }
        public virtual ICollection<Categoria> SubCategorias { get; set; } = new List<Categoria>();
    }

    [Table("marcas", Schema = "catalogo")]
    public class Marca : EntidadBase
    {
        [Column("id_marca")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("nombre_marca")]
        public string NombreMarca { get; set; } = null!;

        [MaxLength(100)]
        [Column("pais_origen")]
        public string? PaisOrigen { get; set; }
    }

    [Table("unidades_medida", Schema = "catalogo")]
    public class UnidadMedida : EntidadBase
    {
        [Column("id_unidad")]
        public override long Id { get; set; }

        [MaxLength(10)]
        [Column("codigo_sunat")]
        public string? CodigoSunat { get; set; }

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
