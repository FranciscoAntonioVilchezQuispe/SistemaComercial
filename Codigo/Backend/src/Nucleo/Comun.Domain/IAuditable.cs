using System;

namespace Nucleo.Comun.Domain
{
    public interface IAuditable
    {
        bool Activado { get; set; }
        DateTime FechaCreacion { get; set; }
        string UsuarioCreacion { get; set; }
        DateTime? FechaActualizacion { get; set; }
        string? UsuarioActualizacion { get; set; }
    }
}
