using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contabilidad.API.Domain.Entidades
{
    [Table("centros_costo", Schema = "contabilidad")]
    public class CentroCosto : EntidadBase
    {
        [Column("id_centro_costo")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;
    }
}
