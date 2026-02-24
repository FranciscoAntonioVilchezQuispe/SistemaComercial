using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tipo_operacion_sunat", Schema = "configuracion")]
    public class TipoOperacionSunat : EntidadBase
    {
        [Column("id_tipo_operacion")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!; // Código SUNAT (ej. 01, 02, 11)

        [Required]
        [MaxLength(200)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("activo")]
        public bool Activo { get; set; } = true;
    }
}
