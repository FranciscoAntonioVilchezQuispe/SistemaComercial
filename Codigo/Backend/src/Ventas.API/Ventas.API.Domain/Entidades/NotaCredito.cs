using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Ventas.API.Domain.Entidades
{
    [Table("nota_credito", Schema = "ventas")]
    public class NotaCredito : EntidadBase
    {
        [Key]
        [Column("id_nota")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Column("numero")]
        public long Numero { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("tipo_comprobante")]
        public string TipoComprobante { get; set; } = "07";

        [Column("id_venta_referencia")]
        public long IdVentaReferencia { get; set; }

        [Required]
        [MaxLength(4)]
        [Column("serie_referencia")]
        public string SerieReferencia { get; set; } = null!;

        [Column("numero_referencia")]
        public long NumeroReferencia { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("tipo_doc_referencia")]
        public string TipoDocReferencia { get; set; } = null!;

        [Column("id_tipo_nota")]
        public long IdTipoNota { get; set; }

        [Required]
        [Column("motivo_sustento", TypeName = "text")]
        public string MotivoSustento { get; set; } = null!;

        [Required]
        [MaxLength(2)]
        [Column("cliente_tipo_doc")]
        public string ClienteTipoDoc { get; set; } = null!;

        [Required]
        [MaxLength(15)]
        [Column("cliente_nro_doc")]
        public string ClienteNroDoc { get; set; } = null!;

        [Required]
        [MaxLength(250)]
        [Column("cliente_razon_social")]
        public string ClienteRazonSocial { get; set; } = null!;

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("igv", TypeName = "decimal(12,2)")]
        public decimal Igv { get; set; }

        [Column("total", TypeName = "decimal(12,2)")]
        public decimal Total { get; set; }

        [Column("porcentaje_igv", TypeName = "decimal(5,2)")]
        public decimal PorcentajeIgv { get; set; }

        [Required]
        [MaxLength(3)]
        [Column("moneda")]
        public string Moneda { get; set; } = "PEN";

        [Column("tipo_cambio", TypeName = "decimal(10,4)")]
        public decimal? TipoCambio { get; set; }

        [Column("afecta_stock")]
        public bool AfectaStock { get; set; } = false;

        [Column("fecha_emision", TypeName = "date")]
        public DateTime FechaEmision { get; set; }

        [Required]
        [MaxLength(20)]
        [Column("estado")]
        public string Estado { get; set; } = "PENDIENTE";

        [Column("fecha_envio_sunat")]
        public DateTime? FechaEnvioSunat { get; set; }

        [MaxLength(10)]
        [Column("respuesta_sunat_codigo")]
        public string? RespuestaSunatCodigo { get; set; }

        [Column("respuesta_sunat_desc", TypeName = "text")]
        public string? RespuestaSunatDesc { get; set; }

        [Column("hash_cdr", TypeName = "text")]
        public string? HashCdr { get; set; }

        [Column("xml_generado", TypeName = "text")]
        public string? XmlGenerado { get; set; }

        [Column("id_tipo_operacion")]
        public long? IdTipoOperacion { get; set; }

        [Column("hash_cpe")]
        public string? HashCpe { get; set; }

        [Column("subtotal_gravado", TypeName = "decimal(12,2)")]
        public decimal SubtotalGravado { get; set; }

        [Column("subtotal_exonerado", TypeName = "decimal(12,2)")]
        public decimal SubtotalExonerado { get; set; }

        [Column("subtotal_inafecto", TypeName = "decimal(12,2)")]
        public decimal SubtotalInafecto { get; set; }

        [Column("id_empresa")]
        public long? IdEmpresa { get; set; }

        [Column("numero_ticket_sunat")]
        [MaxLength(100)]
        public string? NumeroTicketSunat { get; set; }

        [Column("id_estado_cpe")]
        [MaxLength(20)]
        public string? IdEstadoCpe { get; set; }

        // Navegación
        [ForeignKey("IdVentaReferencia")]
        public virtual Venta Venta { get; set; } = null!;

        public virtual ICollection<NotaCreditoDetalle> Detalles { get; set; } = new List<NotaCreditoDetalle>();
    }
}
