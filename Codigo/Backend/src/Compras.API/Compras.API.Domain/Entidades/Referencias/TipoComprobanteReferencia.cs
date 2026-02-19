using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Referencias
{
    [Table("tipo_comprobante", Schema = "configuracion")]
    public class TipoComprobanteReferencia
    {
        [Key]
        [Column("id_tipo_comprobante")]
        public long Id { get; set; }

        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("es_compra")]
        public bool EsCompra { get; set; }

        [Column("es_orden_compra")]
        public bool EsOrdenCompra { get; set; }

        [Column("activado")]
        public bool Activado { get; set; }
    }
}
