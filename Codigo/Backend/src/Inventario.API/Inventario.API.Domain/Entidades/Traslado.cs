using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades
{
    [Table("traslados", Schema = "inventario")]
    public class Traslado : EntidadBase
    {
        [Column("id_traslado")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("numero_traslado")]
        public string NumeroTraslado { get; set; } = null!;

        [Column("almacen_origen_id")]
        public long AlmacenOrigenId { get; set; }

        [Column("almacen_destino_id")]
        public long AlmacenDestinoId { get; set; }

        [Column("fecha_pedido")]
        public DateTime FechaPedido { get; set; } = DateTime.UtcNow;

        [Column("fecha_despacho")]
        public DateTime? FechaDespacho { get; set; }

        [Column("fecha_recepcion")]
        public DateTime? FechaRecepcion { get; set; }

        [MaxLength(10)]
        [Column("gr_serie")]
        public string? GrSerie { get; set; }

        [MaxLength(20)]
        [Column("gr_numero")]
        public string? GrNumero { get; set; }

        [MaxLength(20)]
        [Column("estado")]
        public string Estado { get; set; } = "PENDIENTE"; // PENDIENTE, EN_TRANSITO, RECIBIDO, ANULADO

        [Column("id_usuario_despacho")]
        public long? IdUsuarioDespacho { get; set; }

        [Column("id_usuario_recepcion")]
        public long? IdUsuarioRecepcion { get; set; }

        [Column("observaciones")]
        public string? Observaciones { get; set; }

        public virtual ICollection<TrasladoDetalle> Detalles { get; set; } = new List<TrasladoDetalle>();
    }
}
