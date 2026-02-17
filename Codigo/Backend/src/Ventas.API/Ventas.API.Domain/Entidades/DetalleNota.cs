using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("detalle_notas", Schema = "ventas")]
    public class DetalleNota : EntidadBase
    {
        [Column("id_detalle_nota")]
        public override long Id { get; set; }

        [Column("id_nota")]
        public long IdNota { get; set; }

        [Column("id_producto")]
        public long IdProducto { get; set; }

        [Column("id_variante")]
        public long? IdVariante { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("precio_unitario", TypeName = "decimal(12,2)")]
        public decimal PrecioUnitario { get; set; }

        [Column("impuesto_item", TypeName = "decimal(12,2)")]
        public decimal ImpuestoItem { get; set; }

        [Column("total_item", TypeName = "decimal(12,2)")]
        public decimal TotalItem { get; set; }

        [ForeignKey("IdNota")]
        public virtual Nota Nota { get; set; } = null!;
    }
}
