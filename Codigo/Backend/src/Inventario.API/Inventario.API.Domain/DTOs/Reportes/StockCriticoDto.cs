using System;

namespace Inventario.API.Domain.DTOs.Reportes
{
    public class StockCriticoDto
    {
        public long IdProducto { get; set; }
        public string CodigoProducto { get; set; } = default!;
        public string NombreProducto { get; set; } = default!;
        public long IdAlmacen { get; set; }
        public string NombreAlmacen { get; set; } = default!;
        public decimal CantidadActual { get; set; }
        public decimal StockMinimo { get; set; }
        public decimal Diferencia => CantidadActual - StockMinimo;
        public int Total { get; set; } // Para paginación Dapper (COUNT(*) OVER())
    }
}
