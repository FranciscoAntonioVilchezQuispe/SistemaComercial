using System;

namespace Clientes.API.Domain.DTOs
{
    /// <summary>
    /// DTO optimizado para el listado de socios de negocio (Clientes).
    /// Proporciona información de contacto rápida para grids de selección.
    /// </summary>
    public class ClienteListDto
    {
        public long Id { get; set; }
        public long IdTipoDocumento { get; set; }
        public string TipoDocumentoNombre { get; set; } = string.Empty;
        public string NumeroDocumento { get; set; } = null!;
        public string RazonSocial { get; set; } = null!;
        public string? Email { get; set; }
        public string? Telefono { get; set; }
        public bool Activado { get; set; }

        // Propiedad técnica para PagedResponse
        public int TotalRegistros { get; set; }
    }
}
