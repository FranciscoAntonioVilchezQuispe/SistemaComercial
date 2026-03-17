
namespace Inventario.API.Application.DTOs
{
    public class AjusteStockDto
    {
        public long IdProducto { get; set; }
        public long IdAlmacen { get; set; }
        public decimal NuevaCantidad { get; set; }
        public string Motivo { get; set; } = null!;
    }
}
