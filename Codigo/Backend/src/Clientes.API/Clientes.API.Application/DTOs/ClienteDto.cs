namespace Clientes.API.Application.DTOs
{
    public class CrearClienteDto
    {
        public long IdTipoDocumento { get; set; }
        public string NumeroDocumento { get; set; } = null!;
        public string RazonSocial { get; set; } = null!;
        public string? NombreComercial { get; set; }
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public string? Email { get; set; }
        public long? IdTipoCliente { get; set; }
        public decimal? LimiteCredito { get; set; }
        public int? DiasCredito { get; set; }
        public long? IdListaPrecioAsignada { get; set; }
    }

    public class ClienteDto : CrearClienteDto
    {
        public long Id { get; set; }
    }
}
