using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades
{
    [Table("stock", Schema = "inventario")]
    public class Stock : EntidadBase
    {
        [Column("id_stock")]
        public override long Id { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [Column("id_almacen")]
        public long IdAlmacen { get; set; }

        [Column("cantidad_actual", TypeName = "decimal(10,3)")]
        public decimal CantidadActual { get; set; } = 0;

        [Column("cantidad_reservada", TypeName = "decimal(10,3)")]
        public decimal? CantidadReservada { get; set; } = 0;

        [MaxLength(50)]
        [Column("ubicacion_fisica")]
        public string? UbicacionFisica { get; set; }

        [ForeignKey("IdAlmacen")]
        public virtual Almacen Almacen { get; set; } = null!;
    }
}
