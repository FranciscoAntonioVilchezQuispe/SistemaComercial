using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("tipo_documento", Schema = "configuracion")]
    public class TipoDocumentoReferencia
    {
        [Column("id_regla")]
        public long Id { get; set; }

        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;
    }
}
