using System;
using System.Collections.Generic;

namespace Catalogo.Domain.DTOs
{
    /// <summary>
    /// DTO detallado para la ficha técnica y edición de productos.
    /// Incluye variantes, imágenes y datos exhaustivos de stock.
    /// </summary>
    public class ProductoDetalleDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }

        // Identificadores de Catálogos
        public long IdCategoria { get; set; }
        public string? CategoriaNombre { get; set; }
        public long IdMarca { get; set; }
        public string? MarcaNombre { get; set; }
        public long IdUnidadMedida { get; set; }
        public string? UnidadMedidaNombre { get; set; }
        public string? UnidadMedidaSigla { get; set; }
        
        // Identificadores Técnicos
        public long? IdTipoProducto { get; set; }
        public string? CodigoBarras { get; set; }
        public string? Sku { get; set; }

        // Precios y Costeo
        public decimal PrecioCompra { get; set; }
        public decimal PrecioVentaPublico { get; set; }
        public decimal PrecioVentaMayorista { get; set; }
        public decimal PrecioVentaDistribuidor { get; set; }

        // Inventario
        public decimal Stock { get; set; }
        public decimal StockMinimo { get; set; }
        public decimal? StockMaximo { get; set; }
        public bool TieneVariantes { get; set; }
        public bool PermiteInventarioNegativo { get; set; }
        public string MetodoValuacion { get; set; } = "PP";

        // Fiscal
        public bool GravadoImpuesto { get; set; }
        public decimal PorcentajeImpuesto { get; set; }

        // Medios
        public string? ImagenPrincipalUrl { get; set; }
        public List<ImagenProductoDto> Imagenes { get; set; } = new();
        public List<VarianteProductoDto> Variantes { get; set; } = new();

        // Auditoría
        public bool Activo { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
