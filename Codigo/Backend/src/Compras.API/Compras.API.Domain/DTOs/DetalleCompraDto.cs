namespace Compras.API.Domain.DTOs
{
    /// <summary>
    /// DTO de línea de detalle para compras.
    /// Utilizado tanto en proyecciones de alto rendimiento como en entrada de datos.
    /// </summary>
    public class DetalleCompraDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public string? NombreProducto { get; set; }
        public long? IdVariante { get; set; }
        public string? Descripcion { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitarioCompra { get; set; }
        public decimal Subtotal { get; set; }
        public string AfectacionIgv { get; set; } = "10";
    }
}
