namespace Catalogo.Application.DTOs
{
    /// <summary>
    /// DTO de entrada para actualizar un producto desde el endpoint PUT /api/productos/{id}.
    /// El Id se provee por la URL, no en el body.
    /// </summary>
    public class ActualizarProductoRequest
    {
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }

        public long IdCategoria { get; set; }
        public long IdMarca { get; set; }
        public long IdUnidadMedida { get; set; }
        public long? IdTipoProducto { get; set; }

        public string? CodigoBarras { get; set; }
        public string? Sku { get; set; }

        public decimal PrecioCompra { get; set; }
        public decimal PrecioVentaPublico { get; set; }
        public decimal PrecioVentaMayorista { get; set; }
        public decimal PrecioVentaDistribuidor { get; set; }

        public decimal StockMinimo { get; set; }
        public decimal? StockMaximo { get; set; }

        public bool TieneVariantes { get; set; }
        public bool PermiteInventarioNegativo { get; set; }

        public bool GravadoImpuesto { get; set; }
        public decimal PorcentajeImpuesto { get; set; }

        public string? ImagenPrincipalUrl { get; set; }
        public bool Activo { get; set; } = true;
    }
}
