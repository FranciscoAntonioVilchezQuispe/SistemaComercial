using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("cajas", Schema = "ventas")]
    public class Caja : EntidadBase
    {
        [Column("id_caja")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(50)]
        [Column("nombre_caja")]
        public string NombreCaja { get; set; } = null!;

        [Column("id_almacen")]
        public long IdAlmacen { get; set; }

        [Column("id_estado")]
        public long IdEstado { get; set; }

        [Column("monto_apertura", TypeName = "decimal(12,2)")]
        public decimal? MontoApertura { get; set; } = 0;

        [Column("monto_actual", TypeName = "decimal(12,2)")]
        public decimal? MontoActual { get; set; } = 0;

        [Column("fecha_apertura")]
        public DateTime? FechaApertura { get; set; }

        [Column("fecha_cierre")]
        public DateTime? FechaCierre { get; set; }

        [Column("id_usuario_cajero")]
        public long? IdUsuarioCajero { get; set; }
    }
}
