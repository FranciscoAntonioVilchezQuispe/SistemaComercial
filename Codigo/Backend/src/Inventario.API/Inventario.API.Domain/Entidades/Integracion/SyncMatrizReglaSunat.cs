using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Integracion
{
    [Table("matriz_regla_sunat", Schema = "configuracion")]
    public class SyncMatrizReglaSunat
    {
        [Key]
        [Column("id_regla")]
        public long Id { get; set; }

        [Column("id_tipo_operacion")]
        public long IdTipoOperacion { get; set; }

        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [Column("nivel_obligatoriedad")]
        public int NivelObligatoriedad { get; set; }

        [Column("activo")]
        public bool Activo { get; set; }
    }
}
