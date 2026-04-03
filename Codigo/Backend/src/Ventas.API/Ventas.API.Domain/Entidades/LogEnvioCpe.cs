using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("log_envio_cpe", Schema = "sunat")]
    public class LogEnvioCpe : EntidadBase
    {
        [Key]
        [Column("id_log")]
        public override long Id { get; set; }

        [Column("id_venta")]
        public long? IdVenta { get; set; }

        [Column("id_nota_credito")]
        public long? IdNotaCredito { get; set; }

        [Column("id_nota_debito")]
        public long? IdNotaDebito { get; set; }

        [Column("tipo_documento")]
        [MaxLength(10)]
        public string TipoDocumento { get; set; } = null!;

        [Column("fecha_envio")]
        public DateTime FechaEnvio { get; set; } = DateTime.UtcNow;

        [Column("xml_enviado", TypeName = "text")]
        public string? XmlEnviado { get; set; }

        [Column("xml_respuesta", TypeName = "text")]
        public string? XmlRespuesta { get; set; }

        [Column("codigo_respuesta")]
        [MaxLength(50)]
        public string? CodigoRespuesta { get; set; }

        [Column("mensaje_respuesta", TypeName = "text")]
        public string? MensajeRespuesta { get; set; }

        [Column("ticket")]
        [MaxLength(100)]
        public string? Ticket { get; set; }

        [Column("id_estado_cpe")]
        [MaxLength(20)]
        public string? IdEstadoCpe { get; set; }

        [Column("exito")]
        public bool Exito { get; set; } = false;

        // Navegación
        [ForeignKey("IdVenta")]
        public virtual Venta? Venta { get; set; }

        [ForeignKey("IdNotaCredito")]
        public virtual NotaCredito? NotaCredito { get; set; }

        [ForeignKey("IdNotaDebito")]
        public virtual NotaDebito? NotaDebito { get; set; }
    }
}
