namespace Configuracion.API.Application.DTOs
{
    /// <summary>
    /// DTO que combina un catálogo con sus valores
    /// </summary>
    public class CatalogoCompletoDto
    {
        public TablaGeneralDto Catalogo { get; set; } = null!;
        public List<TablaGeneralDetalleDto> Valores { get; set; } = new();
    }
}
