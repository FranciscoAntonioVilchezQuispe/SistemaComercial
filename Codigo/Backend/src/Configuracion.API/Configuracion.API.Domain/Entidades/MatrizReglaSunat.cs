using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("matriz_regla_sunat", Schema = "configuracion")]
    public class MatrizReglaSunat : EntidadBase
    {
        [Column("id_regla")]
        public override long Id { get; set; }

        [Column("id_tipo_operacion")]
        public long IdTipoOperacion { get; set; }

        [Column("id_tipo_comprobante")]
        public long IdTipoComprobante { get; set; }

        [Column("nivel_obligatoriedad")]
        public int NivelObligatoriedad { get; set; } // 0=N/A, 1=🔵 (Ppal), 2=🟡 (Comp)

        [Column("activo")]
        public bool Activo { get; set; } = true;

        // Navegación
        [ForeignKey("IdTipoOperacion")]
        public virtual TipoOperacionSunat TipoOperacion { get; set; } = null!;

        [ForeignKey("IdTipoComprobante")]
        public virtual TipoComprobante TipoComprobante { get; set; } = null!;
    }
}
