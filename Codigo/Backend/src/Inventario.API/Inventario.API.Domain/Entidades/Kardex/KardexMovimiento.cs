using Nucleo.Comun.Domain;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Inventario.API.Domain.Entidades.Kardex
{
    [Table("inv_kardex_movimiento", Schema = "inventario")]
    public class KardexMovimiento : EntidadBase
    {
        [Column("id")]
        public override long Id { get; set; }

        [Required]
        [MaxLength(36)]
        [Column("uuid")]
        public string Uuid { get; set; } = Guid.NewGuid().ToString();

        [Required]
        [MaxLength(7)]
        [Column("periodo")]
        public string Periodo { get; set; } = null!; // 'YYYY-MM'

        [Column("correlativo_kardex")]
        public long CorrelativoKardex { get; set; }

        // Fecha y hora
        [Column("fecha_movimiento", TypeName = "date")]
        public DateTime FechaMovimiento { get; set; }

        [Column("hora_movimiento", TypeName = "time")]
        public TimeSpan HoraMovimiento { get; set; }

        [Column("fecha_hora_compuesta")]
        public DateTime FechaHoraCompuesta { get; set; }

        // Documento fuente
        [Required]
        [MaxLength(30)]
        [Column("modulo_origen")]
        public string ModuloOrigen { get; set; } = null!;

        [Required]
        [MaxLength(2)]
        [Column("tipo_documento")]
        public string TipoDocumento { get; set; } = null!; // Tabla SUNAT (01=FAC, 03=BOL, etc.)

        [Required]
        [MaxLength(10)]
        [Column("serie_documento")]
        public string SerieDocumento { get; set; } = null!;

        [Required]
        [MaxLength(20)]
        [Column("numero_documento")]
        public string NumeroDocumento { get; set; } = null!;

        [Column("anulado")]
        public bool Anulado { get; set; } = false;

        [Column("fecha_anulacion", TypeName = "date")]
        public DateTime? FechaAnulacion { get; set; }

        [Column("motivo_anulacion", TypeName = "text")]
        public string? MotivoAnulacion { get; set; }

        // Tipo de operación
        [Required]
        [MaxLength(1)]
        [Column("tipo_operacion")]
        public string TipoOperacion { get; set; } = null!; // 'E'=Entrada / 'S'=Salida

        [Required]
        [MaxLength(2)]
        [Column("motivo_traslado_sunat")]
        public string MotivoTrasladoSunat { get; set; } = null!; // Tabla 12 SUNAT

        [Required]
        [MaxLength(255)]
        [Column("descripcion_movimiento")]
        public string DescripcionMovimiento { get; set; } = null!;

        // Almacén
        [Column("almacen_id")]
        public long AlmacenId { get; set; }

        [Column("almacen_origen_id")]
        public long? AlmacenOrigenId { get; set; }

        [Column("almacen_destino_id")]
        public long? AlmacenDestinoId { get; set; }

        // Producto
        [Column("producto_id")]
        public long ProductoId { get; set; }

        [Required]
        [MaxLength(10)]
        [Column("unidad_medida_codigo")]
        public string UnidadMedidaCodigo { get; set; } = null!; // Código SUNAT (KG, UND, LT...)

        [Column("factor_conversion", TypeName = "decimal(18,6)")]
        public decimal FactorConversion { get; set; } = 1;

        // Movimiento (columna ENTRADA)
        [Column("entrada_cantidad", TypeName = "decimal(18,6)")]
        public decimal? EntradaCantidad { get; set; } = 0;

        [Column("entrada_costo_unitario", TypeName = "decimal(18,6)")]
        public decimal? EntradaCostoUnitario { get; set; } = 0;

        [Column("entrada_costo_total", TypeName = "decimal(18,6)")]
        public decimal? EntradaCostoTotal { get; set; } = 0;

        // Movimiento (columna SALIDA)
        [Column("salida_cantidad", TypeName = "decimal(18,6)")]
        public decimal? SalidaCantidad { get; set; } = 0;

        [Column("salida_costo_unitario", TypeName = "decimal(18,6)")]
        public decimal? SalidaCostoUnitario { get; set; } = 0;

        [Column("salida_costo_total", TypeName = "decimal(18,6)")]
        public decimal? SalidaCostoTotal { get; set; } = 0;

        // Saldo resultante
        [Column("saldo_cantidad", TypeName = "decimal(18,6)")]
        public decimal SaldoCantidad { get; set; } = 0;

        [Column("saldo_costo_unitario", TypeName = "decimal(18,6)")]
        public decimal SaldoCostoUnitario { get; set; } = 0;

        [Column("saldo_costo_total", TypeName = "decimal(18,6)")]
        public decimal SaldoCostoTotal { get; set; } = 0;

        // Trazabilidad
        [Column("referencia_id")]
        public long? ReferenciaId { get; set; }

        [MaxLength(50)]
        [Column("referencia_tipo")]
        public string? ReferenciaTipo { get; set; } // 'movimiento_inventario', 'orden_compra'...

        [Column("lote_id")]
        public long? LoteId { get; set; }

        [Column("proveedor_cliente_id")]
        public long? ProveedorClienteId { get; set; }

        [Column("observaciones", TypeName = "text")]
        public string? Observaciones { get; set; }

        // Auditoría
        [Column("usuario_registro_id")]
        public long UsuarioRegistroId { get; set; }

        [Column("usuario_anulacion_id")]
        public long? UsuarioAnulacionId { get; set; }

        [Column("recalculado_at")]
        public DateTime? RecalculadoAt { get; set; }
    }
}
