using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("detalle_compra", Schema = "compras")]
    public class DetalleCompra : EntidadBase
    {
        [Column("id_detalle_compra")]
        public override long Id { get; set; }

        [Column("id_compra")]
        public long IdCompra { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [MaxLength(255)]
        [Column("descripcion")]
        public string? Descripcion { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario_compra", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitarioCompra { get; set; }

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("afectacion_igv")]
        public string AfectacionIgv { get; set; } = "10";

        [MaxLength(4)]
        [Column("codigo_tributo")]
        public string? CodigoTributo { get; set; }

        [Column("precio_unitario_base", TypeName = "decimal(12,4)")]
        public decimal? PrecioUnitarioBase { get; set; }

        [Column("descuento_item", TypeName = "decimal(12,4)")]
        public decimal DescuentoItem { get; set; } = 0;

        [Column("valor_item", TypeName = "decimal(12,4)")]
        public decimal? ValorItem { get; set; }

        [ForeignKey("IdComprao")]
        public virtual Compra Compra { get; set; } = null!;
    }
}
