using System;

namespace Compras.API.Domain.DTOs.Reportes
{
    public class CompraProveedorDto
    {
        public long IdProveedor { get; set; }
        public string RazonSocial { get; set; } = default!;
        public string NumeroDocumento { get; set; } = default!;
        public int CantidadFacturas { get; set; }
        public decimal TotalComprado { get; set; }
        public DateTime? FechaUltimaCompra { get; set; }
    }
}
