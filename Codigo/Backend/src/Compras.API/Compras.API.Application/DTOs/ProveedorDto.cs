namespace Compras.API.Application.DTOs
{


    public class ProveedorDto
    {
        public long Id { get; set; }
        public long IdTipoDocumento { get; set; }
        public string NumeroDocumento { get; set; } = null!;
        public string RazonSocial { get; set; } = null!;
        public string? NombreComercial { get; set; }
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public string? Email { get; set; }
        public string? PaginaWeb { get; set; }
    }
}
