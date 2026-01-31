using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("metodos_pago", Schema = "ventas")]
    public class MetodoPago : EntidadBase
    {
        [Column("id_metodo_pago")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(50)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("requiere_referencia")]
        public bool RequiereReferencia { get; set; } = false;
    }
}
