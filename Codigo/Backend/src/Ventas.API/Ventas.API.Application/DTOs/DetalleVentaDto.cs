namespace Ventas.API.Application.DTOs
{
    public class DetalleVentaDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public long? IdVariante { get; set; }
        public string? DescripcionProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal? PrecioListaOriginal { get; set; }
        public decimal PorcentajeImpuesto { get; set; }
        public decimal ImpuestoItem { get; set; }
        public decimal TotalItem { get; set; }
    }
}
