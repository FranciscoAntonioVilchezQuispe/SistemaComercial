using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("nota_debito_detalle", Schema = "ventas")]
    public class NotaDebitoDetalle : EntidadBase
    {
        [Key]
        [Column("id_detalle")]
        public override long Id { get; set; }

        [Column("id_nota_debito")]
        public long IdNotaDebito { get; set; }

        [Column("id_venta_detalle")]
        public long? IdVentaDetalle { get; set; }

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

        [Column("id_afectacion_igv")]
        public long? IdAfectacionIgv { get; set; }

        [Column("id_tributo")]
        public long? IdTributo { get; set; }

        [Column("precio_unitario_base", TypeName = "decimal(12,4)")]
        public decimal? PrecioUnitarioBase { get; set; }

        [Column("valor_item", TypeName = "decimal(12,4)")]
        public decimal? ValorItem { get; set; }

        [Column("descuento_item", TypeName = "decimal(12,4)")]
        public decimal DescuentoItem { get; set; }

        [Column("porcentaje_impuesto", TypeName = "decimal(5,2)")]
        public decimal PorcentajeImpuesto { get; set; }

        [Column("numero_linea")]
        public int? NumeroLinea { get; set; }

        [Column("id_unidad_medida")]
        public long? IdUnidadMedida { get; set; }

        // Navegación
        [ForeignKey("IdNotaDebito")]
        public virtual NotaDebito NotaDebito { get; set; } = null!;

        [ForeignKey("IdVentaDetalle")]
        public virtual DetalleVenta? VentaDetalle { get; set; }
    }
}
