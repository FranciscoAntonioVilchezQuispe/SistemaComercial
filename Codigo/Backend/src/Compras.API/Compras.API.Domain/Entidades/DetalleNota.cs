using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("detalle_notas", Schema = "compras")]
    public class DetalleNota : EntidadBase
    {
        [Column("id_detalle_nota")]
        public override long Id { get; set; }

        [Column("id_nota")]
        public long IdNota { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitario { get; set; }

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [ForeignKey("IdNota")]
        public virtual Nota Nota { get; set; } = null!;
    }
}
