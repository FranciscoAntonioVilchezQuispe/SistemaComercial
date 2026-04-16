using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tipo_tributo", Schema = "configuracion")]
    public class TipoTributo : EntidadBase
    {
        [Column("id_tributo")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("codigo_sunat")]
        public string Codigo { get; set; } = null!; // Ejemplo: 1000, 2000, 9995

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!; // Ejemplo: IGV, ISC, EXP

        [Required]
        [MaxLength(10)]
        [Column("codigo_internacional")]
        public string CodigoInternacional { get; set; } = null!; // Ejemplo: VAT, EXC, FRE

        [MaxLength(200)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }
    }
}
