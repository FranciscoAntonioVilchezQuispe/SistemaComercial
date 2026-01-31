using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Referencias
{
    [Table("tablas_generales_detalle", Schema = "configuracion")]
    public class TipoMovimientoReferencia
    {
        [Column("id_detalle")]
        public long Id { get; set; }

        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;
    }
}
