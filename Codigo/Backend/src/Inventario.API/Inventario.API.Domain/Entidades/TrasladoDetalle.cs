using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades
{
    [Table("traslados_detalle", Schema = "inventario")]
    public class TrasladoDetalle
    {
        [Key]
        [Column("id_detalle_traslado")]
        public long Id { get; set; }

        [Column("id_traslado")]
        public long TrasladoId { get; set; }

        [Column("id_producto")]
        public long ProductoId { get; set; }

        [Column("cantidad_solicitada", TypeName = "decimal(18,6)")]
        public decimal CantidadSolicitada { get; set; }

        [Column("cantidad_despachada", TypeName = "decimal(18,6)")]
        public decimal CantidadDespachada { get; set; }

        [Column("cantidad_recibida", TypeName = "decimal(18,6)")]
        public decimal CantidadRecibida { get; set; }

        [Column("costo_unitario_despacho", TypeName = "decimal(18,6)")]
        public decimal? CostoUnitarioDespacho { get; set; }

        [Column("observaciones")]
        public string? Observaciones { get; set; }

        [ForeignKey("TrasladoId")]
        public virtual Traslado Traslado { get; set; } = null!;
    }
}
