namespace Catalogo.Application.DTOs
{
    public class CrearMarcaDto
    {
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }
        public string? PaisOrigen { get; set; }
    }

    public class MarcaDto : CrearMarcaDto
    {
        public long Id { get; set; }
     public bool Activo { get; set; }
        
    }
}
