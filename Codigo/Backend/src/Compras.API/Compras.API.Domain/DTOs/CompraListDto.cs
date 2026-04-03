using System;

namespace Compras.API.Domain.DTOs
{
    /// <summary>
    /// DTO optimizado para el listado de documentos de compra.
    /// Enfocado en rendimiento para grids y reportes rápidos.
    /// </summary>
    public class CompraListDto
    {
        public long Id { get; set; }
        public string SerieComprobante { get; set; } = null!;
        public string NumeroComprobante { get; set; } = null!;
        public string NumeroFormateado => $"{SerieComprobante}-{NumeroComprobante}";
        
        public DateTime FechaEmision { get; set; }
        public string RazonSocialProveedor { get; set; } = string.Empty;
        public string NumeroDocumentoProveedor { get; set; } = string.Empty;
        
        public string NombreTipoComprobante { get; set; } = string.Empty;
        public string Moneda { get; set; } = "PEN";
        public decimal Total { get; set; }
        public decimal SaldoPendiente { get; set; }
        
        public string EstadoNombre { get; set; } = "EMITIDO";
        public string NombreAlmacen { get; set; } = string.Empty;

        // Propiedad técnica para PagedResponse
        public int TotalRegistros { get; set; }
    }
}
