using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Integracion
{
    [Table("sync_tipos_comprobante", Schema = "inventario")]
    public class SyncTipoComprobante
    {
        [Key]
        [Column("id_tipo_comprobante")]
        public long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("codigo")]
        public string Codigo { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        [Column("nombre")]
        public string Nombre { get; set; } = null!;

        [Column("activado")]
        public bool Activado { get; set; } = true;

        [Column("mueve_stock")]
        public bool MueveStock { get; set; }

        [Column("tipo_movimiento_stock")]
        [MaxLength(20)]
        public string? TipoMovimientoStock { get; set; }

        [Column("movimiento_stock_venta")]
        [MaxLength(20)]
        public string? MovimientoStockVenta { get; set; }

        [Column("movimiento_stock_compra")]
        [MaxLength(20)]
        public string? MovimientoStockCompra { get; set; }
    }
}
