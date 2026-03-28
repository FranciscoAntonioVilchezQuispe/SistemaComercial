using System;

namespace Inventario.API.Application.DTOs
{
    public class MovimientoInventarioDto
    {
        public long Id { get; set; }
        public long IdTipoMovimiento { get; set; } // Catalog ID (TIPO_MOVIMIENTO_INVENTARIO)
        public long IdStock { get; set; }
        public long IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal CantidadAnterior { get; set; }
        public decimal CantidadNueva { get; set; }
        public decimal? CostoUnitarioMovimiento { get; set; }
        public decimal SaldoCantidad { get; set; }
        public decimal SaldoValorizado { get; set; }
        public decimal CostoPromedioActual { get; set; }
        public string? ReferenciaModulo { get; set; }
        public long? IdReferencia { get; set; }
        public string? Observaciones { get; set; }
        public string? ProductoNombre { get; set; }
        public string? AlmacenNombre { get; set; }
        public string? TipoMovimientoNombre { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string UsuarioCreacion { get; set; } = string.Empty;
    }
}
