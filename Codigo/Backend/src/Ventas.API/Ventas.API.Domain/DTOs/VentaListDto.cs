using System;

namespace Ventas.API.Domain.DTOs
{
    /// <summary>
    /// DTO plano para resultados de consultas paginadas con Dapper.
    /// Sigue la convención de 'GEMINI.md' para eficiencia y tipado estricto.
    /// Se ubica en el Dominio para ser el contrato de retorno del Repositorio.
    /// </summary>
    public class VentaListDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public DateTime FechaEmision { get; set; }
        
        // Datos de Joins (Planos)
        public string ClienteRazonSocial { get; set; } = default!;
        public string ClienteNumeroDocumento { get; set; } = default!;
        public string TipoComprobanteNombre { get; set; } = default!;
        public string EstadoNombre { get; set; } = default!;
        public string EstadoPagoNombre { get; set; } = default!;
        
        // IDs para lógica visual (colores en el grid)
        public long IdEstado { get; set; }
        public long IdEstadoPago { get; set; }
        
        // Totales básicos
        public decimal TotalVenta { get; set; }
        
        // Paginación (Window Function: COUNT(*) OVER())
        public int Total { get; set; }
    }
}
