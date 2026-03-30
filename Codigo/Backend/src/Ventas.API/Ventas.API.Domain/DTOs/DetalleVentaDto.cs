namespace Ventas.API.Domain.DTOs
{
    public class DetalleVentaDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public long? IdVariante { get; set; }
        public string? DescripcionProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal? PrecioListaOriginal { get; set; }
        public decimal PorcentajeImpuesto { get; set; }
        public decimal ImpuestoItem { get; set; }
        public decimal TotalItem { get; set; }

        // --- Campos SUNAT y Técnicos ---
        public string CodigoAfectacionIgv { get; set; } = "10"; // Catálogo 07 (10=Gravado por defecto)
        public string? CodigoTributo { get; set; } // Catálogo 05 (1000=IGV, 9997=EXO, etc.)
        public decimal PrecioUnitarioBase { get; set; } // Precio sin IGV
        public decimal DescuentoItem { get; set; } = 0;
        public decimal ValorItem { get; set; } // (Base * Cantidad) - Descuento
    }
}
