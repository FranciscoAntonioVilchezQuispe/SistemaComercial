using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tablas_generales_detalle", Schema = "configuracion")]
    public class TablaGeneralDetalle : EntidadBase
    {
        [Column("id_detalle")]
        public override long Id { get; set; }

        [Column("id_tabla")]
        public long IdTablaGeneral { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("orden")]
        public int Orden { get; set; } = 0;

        [Column("estado")]
        public bool Estado { get; set; } = true;

        // Navegación
        [ForeignKey("IdTablaGeneral")]
        public virtual TablaGeneral TablaGeneral { get; set; } = null!;
    }
}
