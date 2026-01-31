namespace Catalogo.Application.DTOs
{
    public class CrearVarianteProductoDto
    {
        public long IdProducto { get; set; }
        public string SkuVariante { get; set; } = null!;
        public string? CodigoBarrasVariante { get; set; }
        public string NombreCompletoVariante { get; set; } = null!;
        public string? AtributosJson { get; set; }
        public decimal PrecioAdicional { get; set; }
    }

    public class VarianteProductoDto : CrearVarianteProductoDto
    {
        public long Id { get; set; }
    }
}
