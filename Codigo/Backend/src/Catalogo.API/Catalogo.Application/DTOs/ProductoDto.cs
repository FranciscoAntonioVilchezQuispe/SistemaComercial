namespace Catalogo.Application.DTOs
{
    public class ProductoDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }

        // Relaciones
        public long IdCategoria { get; set; }
        public CategoriaDto? Categoria { get; set; }
        public long IdMarca { get; set; }
        public MarcaDto? Marca { get; set; }
        public long IdUnidadMedida { get; set; }
        public UnidadMedidaDto? UnidadMedida { get; set; }
        public long? IdTipoProducto { get; set; }

        // Códigos adicionales
        public string? CodigoBarras { get; set; }
        public string? Sku { get; set; }

        // Precios
        public decimal PrecioCompra { get; set; }
        public decimal PrecioVentaPublico { get; set; }
        public decimal PrecioVentaMayorista { get; set; }
        public decimal PrecioVentaDistribuidor { get; set; }

        // Stock (viene de Inventario, por ahora 0)
        public decimal Stock { get; set; }
        public decimal StockMinimo { get; set; }
        public decimal? StockMaximo { get; set; }

        // Configuración de inventario
        public bool TieneVariantes { get; set; }
        public bool PermiteInventarioNegativo { get; set; }

        // Configuración fiscal
        public bool GravadoImpuesto { get; set; }
        public decimal PorcentajeImpuesto { get; set; }

        // Imagen
        public string? ImagenPrincipalUrl { get; set; }

        // Auditoría
        public bool Activo { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
