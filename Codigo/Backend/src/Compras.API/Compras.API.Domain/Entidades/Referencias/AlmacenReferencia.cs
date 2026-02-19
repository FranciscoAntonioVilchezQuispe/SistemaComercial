using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Referencias
{
    [Table("almacenes", Schema = "inventario")]
    public class AlmacenReferencia
    {
        [Key]
        [Column("id_almacen")]
        public long Id { get; set; }


        [Column("nombre_almacen")]
        public string NombreAlmacen { get; set; } = null!;
    }
}
