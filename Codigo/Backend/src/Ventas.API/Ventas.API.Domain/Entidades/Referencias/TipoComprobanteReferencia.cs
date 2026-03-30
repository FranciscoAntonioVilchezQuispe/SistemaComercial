using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades.Referencias
{
    [Table("tipo_comprobante", Schema = "configuracion")]
    public class TipoComprobanteReferencia : EntidadBase
    {
        [Column("id_tipo_comprobante")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!; // SUNAT: 01, 03, 07, 08

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;
    }
}
