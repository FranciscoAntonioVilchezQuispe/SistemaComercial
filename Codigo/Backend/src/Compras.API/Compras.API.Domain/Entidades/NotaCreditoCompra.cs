using Nucleo.Comun.Domain;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Compras.API.Domain.Entidades
{
    [Table("nota_credito", Schema = "compras")]
    public class NotaCreditoCompra : EntidadBase
    {
        [Key]
        [Column("id_nota")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("serie")]
        public string Serie { get; set; } = null!;

        [Required]
        [MaxLength(20)]
        [Column("numero")]
        public string Numero { get; set; } = null!;

        [Required]
        [MaxLength(2)]
        [Column("tipo_comprobante")]
        public string TipoComprobante { get; set; } = "07";

        [Column("id_compra_referencia")]
        public long IdCompraReferencia { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("serie_referencia")]
        public string SerieReferencia { get; set; } = null!;

        [Required]
        [MaxLength(20)]
        [Column("numero_referencia")]
        public string NumeroReferencia { get; set; } = null!;

        [Required]
        [MaxLength(2)]
        [Column("tipo_doc_referencia")]
        public string TipoDocReferencia { get; set; } = null!;

        [Column("id_tipo_nota")]
        public long IdTipoNota { get; set; }

        [Required]
        [Column("motivo_sustento", TypeName = "text")]
        public string MotivoSustento { get; set; } = null!;

        [Column("id_proveedor")]
        public long IdProveedor { get; set; }

        [Required]
        [MaxLength(2)]
        [Column("proveedor_tipo_doc")]
        public string ProveedorTipoDoc { get; set; } = null!;

        [Required]
        [MaxLength(15)]
        [Column("proveedor_nro_doc")]
        public string ProveedorNroDoc { get; set; } = null!;

        [Required]
        [MaxLength(250)]
        [Column("proveedor_razon_social")]
        public string ProveedorRazonSocial { get; set; } = null!;

        [Column("subtotal", TypeName = "decimal(12,2)")]
        public decimal Subtotal { get; set; }

        [Column("igv", TypeName = "decimal(12,2)")]
        public decimal Igv { get; set; }

        [Column("total", TypeName = "decimal(12,2)")]
        public decimal Total { get; set; }

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

        [Column("id_estado")]
        public long IdEstado { get; set; } = 60; // Registrado

        [Required]
        [MaxLength(20)]
        [Column("estado")]
        public string Estado { get; set; } = "PENDIENTE";

        // Navegación
        [ForeignKey("IdCompraReferencia")]
        public virtual Compra Compra { get; set; } = null!;

        [ForeignKey("IdProveedor")]
        public virtual Proveedor Proveedor { get; set; } = null!;

        public virtual ICollection<NotaCreditoDetalleCompra> Detalles { get; set; } = new List<NotaCreditoDetalleCompra>();
    }
}
