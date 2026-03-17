
namespace Inventario.API.Application.DTOs
{
    public class TipoMovimientoDto
    {
        public long Id { get; set; }
        public string Codigo { get; set; } = null!;
        public string Nombre { get; set; } = null!;
    }
}
