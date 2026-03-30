using System;

namespace Inventario.API.Domain.DTOs
{
    /// <summary>
    /// DTO optimizado para el kardex (listado de movimientos).
    /// Proporciona una vista rápida del movimiento físico en almacén.
    /// </summary>
    public class MovimientoListDto
    {
        public long Id { get; set; }
        public string ProductoNombre { get; set; } = string.Empty;
        public string AlmacenNombre { get; set; } = string.Empty;
        public string TipoMovimientoNombre { get; set; } = string.Empty;
        public decimal Cantidad { get; set; }
        public decimal CantidadNueva { get; set; } // Stock resultante después del movimiento
        public DateTime FechaCreacion { get; set; }
        public string UsuarioCreacion { get; set; } = string.Empty;

        // Propiedad técnica para PagedResponse
        public int TotalRegistros { get; set; }
    }
}
