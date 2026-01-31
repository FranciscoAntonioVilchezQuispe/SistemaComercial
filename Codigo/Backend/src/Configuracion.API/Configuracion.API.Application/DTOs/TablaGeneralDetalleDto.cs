namespace Configuracion.API.Application.DTOs
{
    /// <summary>
    /// DTO para representar un valor de catálogo (TablaGeneralDetalle)
    /// </summary>
    public class TablaGeneralDetalleDto
    {
        public long IdDetalle { get; set; }
        public long IdTabla { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
        public int Orden { get; set; }
        public bool Estado { get; set; }
    }
}
