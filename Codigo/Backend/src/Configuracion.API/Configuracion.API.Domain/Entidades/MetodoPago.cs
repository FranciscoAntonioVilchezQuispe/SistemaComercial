using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("metodo_pago", Schema = "configuracion")]
    public class MetodoPago : EntidadBase
    {
        [Column("id_metodo_pago")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("es_efectivo")]
        public bool EsEfectivo { get; set; }

        [Column("id_tipo_documento_pago")]
        public long? IdTipoDocumentoPago { get; set; }
    }
}
