using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Referencias
{
    [Table("productos", Schema = "catalogo")]
    public class ProductoReferencia
    {
        [Key]
        [Column("id_producto")]
        public long Id { get; set; }

        [Column("nombre_producto")]
        public string NombreProducto { get; set; } = null!;
    }
}
