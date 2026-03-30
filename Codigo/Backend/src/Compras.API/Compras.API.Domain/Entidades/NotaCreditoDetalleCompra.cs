using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("nota_credito_detalle", Schema = "compras")]
    public class NotaCreditoDetalleCompra : EntidadBase
    {
        [Key]
        [Column("id_detalle")]
        public override long Id { get; set; }

        [Column("id_nota_credito")]
        public long IdNotaCredito { get; set; }

        [Column("id_compra_detalle")]
        public long? IdCompraDetalle { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Required]
        [MaxLength(500)]
        [Column("descripcion")]
        public string Descripcion { get; set; } = null!;

        [Required]
        [MaxLength(10)]
        [Column("unidad_medida")]
        public string UnidadMedida { get; set; } = "NIU";

        [Column("cantidad", TypeName = "decimal(12,4)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario", TypeName = "decimal(12,4)")]
        public decimal PrecioUnitario { get; set; }

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("igv", TypeName = "decimal(12,2)")]
        public decimal Igv { get; set; }

        [Column("total", TypeName = "decimal(12,2)")]
        public decimal Total { get; set; }

        // Navegación
        [ForeignKey("IdNotaCredito")]
        public virtual NotaCreditoCompra NotaCredito { get; set; } = null!;

        [ForeignKey("IdCompraDetalle")]
        public virtual DetalleCompra? CompraDetalle { get; set; }
    }
}
