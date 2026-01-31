namespace Clientes.API.Application.DTOs
{
    public class CrearContactoClienteDto
    {
        public long IdCliente { get; set; }
        public string Nombres { get; set; } = null!;
        public string? Cargo { get; set; }
        public string? Telefono { get; set; }
        public string? Email { get; set; }
        public bool EsPrincipal { get; set; }
    }

    public class ContactoClienteDto : CrearContactoClienteDto
    {
        public long Id { get; set; }
    }
}
