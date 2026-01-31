using System;

namespace Inventario.API.Application.DTOs
{
    public class MovimientoInventarioDto
    {
        public long Id { get; set; }
        public long IdTipoMovimiento { get; set; } // Catalog ID (TIPO_MOVIMIENTO_INVENTARIO)
        public long IdStock { get; set; }
        public decimal Cantidad { get; set; }
        public decimal CantidadAnterior { get; set; }
        public decimal CantidadNueva { get; set; }
        public decimal? CostoUnitarioMovimiento { get; set; }
        public string? ReferenciaModulo { get; set; }
        public long? IdReferencia { get; set; }
        public string? Observaciones { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string UsuarioCreacion { get; set; } = string.Empty;
    }
}
