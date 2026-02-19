using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades.Referencias
{
    [Table("tipo_documento", Schema = "configuracion")]
    public class TipoDocumentoReferencia
    {
        [Key]
        [Column("id_regla")]
        public long Id { get; set; }

        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;
    }
}
