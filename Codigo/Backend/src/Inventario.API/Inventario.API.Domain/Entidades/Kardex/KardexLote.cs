using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Kardex
{
    [Table("inv_kardex_lote", Schema = "inventario")]
    public class KardexLote : EntidadBase
    {
        [Column("id")]
        public override long Id { get; set; }

        [Column("producto_id")]
        public long ProductoId { get; set; }

        [Column("almacen_id")]
        public long AlmacenId { get; set; }

        [Column("fecha_entrada", TypeName = "date")]
        public DateTime FechaEntrada { get; set; }

        [Column("hora_entrada", TypeName = "time")]
        public TimeSpan HoraEntrada { get; set; }

        [Column("movimiento_origen_id")]
        public long MovimientoOrigenId { get; set; }

        [Column("costo_unitario", TypeName = "decimal(18,6)")]
        public decimal CostoUnitario { get; set; }

        [Column("cantidad_original", TypeName = "decimal(18,6)")]
        public decimal CantidadOriginal { get; set; }

        [Column("cantidad_disponible", TypeName = "decimal(18,6)")]
        public decimal CantidadDisponible { get; set; }

        [Required]
        [MaxLength(1)]
        [Column("estado")]
        public string Estado { get; set; } = "A"; // A=Activo, C=Consumido
    }
}
