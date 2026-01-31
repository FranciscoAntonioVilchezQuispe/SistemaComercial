using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Catalogo.Domain.Entidades
{
    [Table("variantes_producto", Schema = "catalogo")]
    public class VarianteProducto : EntidadBase
    {
        [Column("id_variante")]
        public override long Id { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Required]
        [MaxLength(100)]
        [Column("sku_variante")]
        public string SkuVariante { get; set; } = null!;

        [MaxLength(100)]
        [Column("codigo_barras_variante")]
        public string? CodigoBarrasVariante { get; set; }

        [Required]
        [MaxLength(255)]
        [Column("nombre_completo_variante")]
        public string NombreCompletoVariante { get; set; } = null!;

        [Column("atributos_json", TypeName = "jsonb")]
        public string? AtributosJson { get; set; }

        [Column("precio_adicional", TypeName = "decimal(12,2)")]
        public decimal PrecioAdicional { get; set; }

        [ForeignKey("IdProducto")]
        public virtual Producto Producto { get; set; } = null!;
    }
}
