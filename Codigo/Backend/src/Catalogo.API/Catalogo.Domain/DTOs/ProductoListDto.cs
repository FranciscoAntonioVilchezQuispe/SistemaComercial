using System;

namespace Catalogo.Domain.DTOs
{
    /// <summary>
    /// DTO optimizado para el listado de productos en grids y buscadores.
    /// Enfocado en velocidad de respuesta y bajo consumo de memoria.
    /// </summary>
    public class ProductoListDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string CategoriaNombre { get; set; } = string.Empty;
        public string MarcaNombre { get; set; } = string.Empty;
        public string UnidadMedidaSigla { get; set; } = string.Empty;
        
        public decimal PrecioVentaPublico { get; set; }
        public decimal StockActual { get; set; }
        
        public string? ImagenPrincipalUrl { get; set; }
        public bool Activo { get; set; }

        // Propiedad técnica para PagedResponse
        public int TotalRegistros { get; set; }
    }
}
