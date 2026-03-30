using System;

namespace Contabilidad.API.Domain.DTOs
{
    /// <summary>
    /// DTO optimizado para el listado del libro diario.
    /// Proporciona una vista rápida de la cabecera de los asientos contables.
    /// </summary>
    public class AsientoListDto
    {
        public long Id { get; set; }
        public DateTime FechaContable { get; set; }
        public string Periodo { get; set; } = null!;
        public string Glosa { get; set; } = null!;
        public string OrigenModulo { get; set; } = null!;
        public decimal TotalDebe { get; set; }
        public decimal TotalHaber { get; set; }
        public string EstadoNombre { get; set; } = "BORRADOR";

        // Propiedad técnica para PagedResponse
        public int TotalRegistros { get; set; }
    }
}
