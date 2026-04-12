namespace Compras.API.Application.DTOs
{
    public class AnularCompraRequest
    {
        public string Motivo { get; set; } = string.Empty;
        public long UsuarioId { get; set; }
    }
}
