using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("detalle_venta", Schema = "ventas")]
    public class DetalleVenta : EntidadBase
    {
        [Column("id_detalle_venta")]
        public override long Id { get; set; }

        [Column("id_venta")]
        public long IdVenta { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [MaxLength(255)]
        [Column("descripcion_producto")]
        public string? DescripcionProducto { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitario { get; set; }

        [Column("precio_lista_original", TypeName = "decimal(12,2)")]
        public decimal? PrecioListaOriginal { get; set; }

        [Column("porcentaje_impuesto", TypeName = "decimal(5,2)")]
        public decimal PorcentajeImpuesto { get; set; } = 18.0m;

        [Column("impuesto_item", TypeName = "decimal(12,2)")]
        public decimal ImpuestoItem { get; set; }

        [Column("total_item", TypeName = "decimal(12,2)")]
        public decimal TotalItem { get; set; }

        [ForeignKey("IdVenta")]
        public virtual Venta Venta { get; set; } = null!;
    }
}
