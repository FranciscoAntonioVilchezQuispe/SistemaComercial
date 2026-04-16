namespace Identidad.API.Application.Features.Roles.ActualizarAccesoRol
{
    public class AccesoMenuDto
    {
        public long IdMenu { get; set; }
        public List<long> TiposPermisoIds { get; set; } = new();
    }
}
