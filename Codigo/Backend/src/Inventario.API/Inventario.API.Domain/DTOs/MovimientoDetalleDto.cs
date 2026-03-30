using System;

namespace Inventario.API.Domain.DTOs
{
    /// <summary>
    /// DTO detallado para la auditoría física y valorizada del movimiento.
    /// Proporciona la traza completa desde el origen (Venta, Compra, Ajuste).
    /// </summary>
    public class MovimientoDetalleDto
    {
        public long Id { get; set; }
        public long IdTipoMovimiento { get; set; }
        public string? TipoMovimientoNombre { get; set; }
        
        public long IdStock { get; set; }
        public long IdProducto { get; set; }
        public string? ProductoNombre { get; set; }
        public string? AlmacenNombre { get; set; }

        // Cantidades y Costos (Auditoría Técnica)
        public decimal Cantidad { get; set; }
        public decimal CantidadAnterior { get; set; }
        public decimal CantidadNueva { get; set; }
        public decimal? CostoUnitarioMovimiento { get; set; }
        
        // Kardex Valorizado (Auditoría Contable Indirecta)
        public decimal SaldoCantidad { get; set; }
        public decimal SaldoValorizado { get; set; }
        public decimal CostoPromedioActual { get; set; }

        // Origen y Trazabilidad
        public string? ReferenciaModulo { get; set; }
        public long? IdReferencia { get; set; }
        public string? Observaciones { get; set; }

        public DateTime FechaCreacion { get; set; }
        public string UsuarioCreacion { get; set; } = string.Empty;
    }
}
