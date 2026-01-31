using Nucleo.Comun.Domain;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tablas_generales", Schema = "configuracion")]
    public class TablaGeneral : EntidadBase
    {
        [Column("id_tabla")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [Column("es_sistema")]
        public bool EsSistema { get; set; } = false;

        // Navegación
        public virtual ICollection<TablaGeneralDetalle> Detalles { get; set; } = new List<TablaGeneralDetalle>();
    }
}
