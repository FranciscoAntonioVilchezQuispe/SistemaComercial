using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Configuracion.API.Domain.Entidades
{
    [Table("tipos_comprobantes", Schema = "configuracion")]
    public class TipoComprobante : EntidadBase
    {
        [Column("id_tipo_comprobante")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!; // Código SUNAT (ej. 01, 03, 07)

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("mueve_stock")]
        public bool MueveStock { get; set; }

        // Enum para indicar si suma o resta, o depende de la operación (Venta/Compra)
        // Por simplicidad en la BD lo guardamos como string o int. Usaremos string para claridad.
        // Valores: "ENTRADA", "SALIDA", "NEUTRO", "DEPENDIENTE"
        [MaxLength(20)]
        [Column("tipo_movimiento_stock")]
        public string TipoMovimientoStock { get; set; } = "DEPENDIENTE"; 

        [Column("activado")]
        public bool Activado { get; set; } = true;
    }
}
