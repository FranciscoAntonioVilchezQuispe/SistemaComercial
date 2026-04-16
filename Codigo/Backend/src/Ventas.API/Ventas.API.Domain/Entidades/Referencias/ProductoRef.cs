using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("productos", Schema = "catalogo")]
    public class ProductoRef
    {
        [Column("id_producto")]
        public long Id { get; set; }

        [Column("nombre_producto")]
        public string Nombre { get; set; } = null!;

        [Column("id_afectacion_igv")]
        public long? IdTipoAfectacionIgv { get; set; }

        [Column("id_tipo_tributo")]
        public long? IdTipoTributo { get; set; }
    }
}
