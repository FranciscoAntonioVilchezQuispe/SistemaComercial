using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Catalogo.Domain.Entidades
{
    [Table("imagenes_producto", Schema = "catalogo")]
    public class ImagenProducto : EntidadBase
    {
        [Column("id_imagen")]
        public override long Id { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Required]
        [MaxLength(500)]
        [Column("url_imagen")]
        public string UrlImagen { get; set; } = null!;

        [Column("es_principal")]
        public bool EsPrincipal { get; set; }

        [Column("orden")]
        public int Orden { get; set; } = 0;

        [ForeignKey("IdProducto")]
        public virtual Producto Producto { get; set; } = null!;
    }
}
