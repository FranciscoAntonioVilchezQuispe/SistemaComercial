using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tipo_documento", Schema = "configuracion")]
    public class DocumentoIdentidadRegla : EntidadBase
    {
        [Column("id_regla")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("longitud")]
        public int Longitud { get; set; }

        [Column("es_numerico")]
        public bool EsNumerico { get; set; } = true;

        [Column("estado")]
        public bool Estado { get; set; } = true;
    }
}
