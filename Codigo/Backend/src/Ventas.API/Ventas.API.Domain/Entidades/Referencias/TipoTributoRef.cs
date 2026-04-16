using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("tipo_tributo", Schema = "configuracion")]
    public class TipoTributoRef
    {
        [Column("id_tributo")]
        public long Id { get; set; }

        [Column("codigo_sunat")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("codigo_internacional")]
        public string CodigoInternacional { get; set; } = null!;

        [Column("descripcion")]
        public string? Descripcion { get; set; }
    }
}
