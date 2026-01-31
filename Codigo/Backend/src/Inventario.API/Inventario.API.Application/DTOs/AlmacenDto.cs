namespace Inventario.API.Application.DTOs
{
    public class AlmacenDto
    {
        public long Id { get; set; }
        public string NombreAlmacen { get; set; } = null!;
        public string? Direccion { get; set; }
        public bool EsPrincipal { get; set; }
    }
}
