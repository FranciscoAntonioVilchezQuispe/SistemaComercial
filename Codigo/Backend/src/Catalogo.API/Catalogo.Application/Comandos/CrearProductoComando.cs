using MediatR;

namespace Catalogo.Application.Comandos
{
    public record CrearProductoComando(
        // Información básica
        string Codigo,
        string Nombre,
        string? Descripcion,

        // Relaciones
        long IdCategoria,
        long IdMarca,
        long IdUnidadMedida,
        long? IdTipoProducto,

        // Códigos adicionales
        string? CodigoBarras,
        string? Sku,

        // Precios
        decimal PrecioCompra,
        decimal PrecioVentaPublico,
        decimal PrecioVentaMayorista,
        decimal PrecioVentaDistribuidor,

        // Stock
        decimal StockMinimo,
        decimal? StockMaximo,

        // Configuración de inventario
        bool TieneVariantes,
        bool PermiteInventarioNegativo,

        // Configuración fiscal
        bool GravadoImpuesto,
        decimal PorcentajeImpuesto,

        // Imagen
        string? ImagenPrincipalUrl
    ) : IRequest<long>;
}

