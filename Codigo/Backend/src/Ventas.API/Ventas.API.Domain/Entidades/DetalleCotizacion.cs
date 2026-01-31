using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("detalle_cotizacion", Schema = "ventas")]
    public class DetalleCotizacion : EntidadBase
    {
        [Column("id_detalle_cot")]
        public override long Id { get; set; }

        [Column("id_cotizacion")]
        public long IdCotizacion { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; } // Referencia a Catalogo

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitario { get; set; }

        [Column("porcentaje_descuento", TypeName = "decimal(5,2)")]
        public decimal? PorcentajeDescuento { get; set; } = 0;

        [Column("monto_descuento", TypeName = "decimal(12,2)")]
        public decimal? MontoDescuento { get; set; } = 0;

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [ForeignKey("IdCotizacion")]
        public virtual Cotizacion Cotizacion { get; set; } = null!;
    }
}
