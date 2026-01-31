namespace Catalogo.Application.DTOs
{
    public class CrearUnidadMedidaDto
    {
        public string? CodigoSunat { get; set; }
        public string Nombre { get; set; } = null!;
        public string Simbolo { get; set; } = null!;
    }

    public class UnidadMedidaDto : CrearUnidadMedidaDto
    {
        public long Id { get; set; }
    }
}
