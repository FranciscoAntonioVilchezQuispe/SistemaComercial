namespace Catalogo.Application.DTOs
{
    public class CrearImagenProductoDto
    {
        public long IdProducto { get; set; }
        public string UrlImagen { get; set; } = null!;
        public bool EsPrincipal { get; set; }
        public int Orden { get; set; }
    }

    public class ImagenProductoDto : CrearImagenProductoDto
    {
        public long Id { get; set; }
    }
}
