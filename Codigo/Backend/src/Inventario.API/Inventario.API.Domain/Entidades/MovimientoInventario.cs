using Nucleo.Comun.Domain;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades
{
    [Table("movimientos_inventario", Schema = "inventario")]
    public class MovimientoInventario : EntidadBase
    {
        [Column("id_movimiento")]
        public override long Id { get; set; }

        [Required]
        [Column("id_tipo_movimiento")]
        public long IdTipoMovimiento { get; set; }

        [Column("id_stock")]
        public long IdStock { get; set; }

        [Column("cantidad", TypeName = "decimal(10,3)")]
        public decimal Cantidad { get; set; }

        [Column("cantidad_anterior", TypeName = "decimal(10,3)")]
        public decimal CantidadAnterior { get; set; }

        [Column("cantidad_nueva", TypeName = "decimal(10,3)")]
        public decimal CantidadNueva { get; set; }

        [Column("costo_unitario_movimiento", TypeName = "decimal(12,4)")]
        public decimal? CostoUnitarioMovimiento { get; set; }

        [MaxLength(50)]
        [Column("referencia_modulo")]
        public string? ReferenciaModulo { get; set; }

        [Column("id_referencia")]
        public long? IdReferencia { get; set; }

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        [ForeignKey("IdStock")]
        public virtual Stock Stock { get; set; } = null!;
    }
}
