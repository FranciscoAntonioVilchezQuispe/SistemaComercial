using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Integracion
{
    [Table("tipo_operacion_sunat", Schema = "configuracion")]
    public class SyncTipoOperacionSunat
    {
        [Key]
        [Column("id_tipo_operacion")]
        public long Id { get; set; }

        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("activo")]
        public bool Activo { get; set; }
    }
}
