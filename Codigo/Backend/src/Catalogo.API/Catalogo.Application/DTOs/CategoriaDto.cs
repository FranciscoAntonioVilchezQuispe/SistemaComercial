namespace Catalogo.Application.DTOs
{
    public class CrearCategoriaDto
    {
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }
        public long? IdCategoriaPadre { get; set; }
        public string? ImagenUrl { get; set; }
    }

    public class CategoriaDto : CrearCategoriaDto
    {
        public long Id { get; set; }
        public bool Activo { get; set; }
    }
}
