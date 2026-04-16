using System;

namespace Ventas.API.Application.DTOs
{
    public class TurnoVendedorDto
    {
        public long Id { get; set; }
        public long UsuarioVendedorId { get; set; }
        public long CajaId { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public decimal MontoApertura { get; set; }
        public decimal? MontoCierre { get; set; }
        public string Estado { get; set; } = string.Empty;
    }

    public class CierreTurnoDto
    {
        public long Id { get; set; }
        public long TurnoVendedorId { get; set; }
        public DateTime FechaGeneracion { get; set; }
        public decimal TotalVentas { get; set; }
        public decimal TotalEfectivo { get; set; }
        public decimal TotalTarjeta { get; set; }
        public decimal TotalTransferencia { get; set; }
        public decimal TotalOtros { get; set; }
        public int CantidadTransacciones { get; set; }
        public string? Observaciones { get; set; }
        public string Estado { get; set; } = string.Empty;
    }
}
