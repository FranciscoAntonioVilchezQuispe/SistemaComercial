using System;
using System.Collections.Generic;

namespace Contabilidad.API.Domain.DTOs
{
    /// <summary>
    /// DTO detallado para la ficha técnica del asiento contable.
    /// Incluye la partida doble completa y referencias de origen.
    /// </summary>
    public class AsientoDetalleDto
    {
        public long Id { get; set; }
        public DateTime FechaContable { get; set; }
        public string Periodo { get; set; } = null!;
        public string Glosa { get; set; } = null!;
        public string OrigenModulo { get; set; } = null!;
        public long? IdOrigenReferencia { get; set; }
        public long IdEstado { get; set; }
        public string? EstadoNombre { get; set; }
        
        public decimal TotalDebe { get; set; }
        public decimal TotalHaber { get; set; }

        public List<DetalleAsientoDto> Detalles { get; set; } = new();
    }
}
