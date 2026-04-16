namespace Ventas.API.Domain.DTOs.Reportes
{
    public class RankingProductoDto
    {
        public long IdProducto { get; set; }
        public string CodigoProducto { get; set; } = default!;
        public string NombreProducto { get; set; } = default!;
        public decimal CantidadVendida { get; set; }
        public decimal TotalVendido { get; set; }
    }
}
