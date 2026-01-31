using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("ordenes_compra", Schema = "compras")]
    public class OrdenCompra : EntidadBase
    {
        [Column("id_orden_compra")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("codigo_orden")]
        public string CodigoOrden { get; set; } = null!;

        [Column("id_proveedor")]
        public long IdProveedor { get; set; }

        [Column("id_almacen_destino")]
        public long IdAlmacenDestino { get; set; }

        [Column("fecha_emision")]
        public DateTime FechaEmision { get; set; }

        [Column("fecha_entrega_estimada")]
        public DateTime? FechaEntregaEstimada { get; set; }

        [Required]
        [Column("id_estado")]
        public long IdEstado { get; set; }

        [Column("total_importe", TypeName = "decimal(12,2)")]
        public decimal TotalImporte { get; set; }

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        [ForeignKey("IdProveedor")]
        public virtual Proveedor Proveedor { get; set; } = null!;

        public virtual ICollection<DetalleOrdenCompra> Detalles { get; set; } = new List<DetalleOrdenCompra>();
    }
}
