namespace Ventas.API.Domain.DTOs.Reportes
{
    public class TopClienteDto
    {
        public long IdCliente { get; set; }
        public string RazonSocial { get; set; } = default!;
        public string NumeroDocumento { get; set; } = default!;
        public int CantidadOperaciones { get; set; }
        public decimal TotalComprado { get; set; }
    }
}
