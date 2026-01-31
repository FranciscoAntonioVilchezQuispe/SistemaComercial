namespace Configuracion.API.Application.DTOs
{
    /// <summary>
    /// DTO para representar un catálogo maestro (TablaGeneral)
    /// </summary>
    public class TablaGeneralDto
    {
        public long IdTabla { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public string? Descripcion { get; set; }
        public bool EsSistema { get; set; }
        public int CantidadValores { get; set; }
    }
}
