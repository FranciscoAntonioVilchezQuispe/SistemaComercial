namespace Ventas.API.Application.DTOs
{
    public class AnularVentaRequest
    {
        public string Motivo { get; set; } = string.Empty;
        public long UsuarioId { get; set; }
    }
}
