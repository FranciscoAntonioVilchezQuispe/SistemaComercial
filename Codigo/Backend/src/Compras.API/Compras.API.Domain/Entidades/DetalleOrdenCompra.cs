using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("detalle_orden_compra", Schema = "compras")]
    public class DetalleOrdenCompra : EntidadBase
    {
        [Column("id_detalle_oc")]
        public override long Id { get; set; }

        [Column("id_orden_compra")]
        public long IdOrdenCompra { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [Column("cantidad_solicitada", TypeName = "decimal(10,3)")]
        public decimal CantidadSolicitada { get; set; }

        [Column("precio_unitario_pactado", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitarioPactado { get; set; }

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("cantidad_recibida", TypeName = "decimal(10,3)")]
        public decimal? CantidadRecibida { get; set; } = 0;

        [ForeignKey("IdOrdenCompra")]
        public virtual OrdenCompra OrdenCompra { get; set; } = null!;
    }
}
