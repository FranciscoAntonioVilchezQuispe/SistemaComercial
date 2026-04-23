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
        public decimal TotalIngresosManualles { get; set; }
        public decimal TotalEgresosManualles { get; set; }
        public decimal MontoEsperado { get; set; }
        public decimal MontoFisicoContado { get; set; }
        public decimal DiferenciaArqueo { get; set; }
        public string? Observaciones { get; set; }
        public string Estado { get; set; } = string.Empty;
    }

    public class MovimientoListDto
    {
        public long Id { get; set; }
        public long IdCaja { get; set; }
        public long? IdTurnoVendedor { get; set; }
        public long IdTipoMovimiento { get; set; }
        public string TipoMovimientoNombre { get; set; } = string.Empty;
        public decimal Monto { get; set; }
        public string Concepto { get; set; } = string.Empty;
        public DateTime FechaMovimiento { get; set; }
        public string UsuarioResponsable { get; set; } = string.Empty;
    }

    public class RegistrarMovimientoRequest
    {
        public long IdCaja { get; set; }
        public long? IdTurnoVendedor { get; set; }
        public long IdTipoMovimiento { get; set; }
        public decimal Monto { get; set; }
        public string Concepto { get; set; } = string.Empty;
    }

    public class TurnoResumenPrevioDto
    {
        public long TurnoId { get; set; }
        public decimal MontoApertura { get; set; }
        public decimal TotalVentas { get; set; }
        public decimal TotalEfectivo { get; set; }
        public decimal TotalTarjeta { get; set; }
        public decimal TotalTransferencia { get; set; }
        public decimal TotalOtros { get; set; }
        public decimal TotalIngresosManualles { get; set; }
        public decimal TotalEgresosManualles { get; set; }
        public decimal MontoEsperadoEnCaja { get; set; }
        public int CantidadVentas { get; set; }
        public System.Collections.Generic.List<MovimientoListDto> MovimientosManuales { get; set; } = new();
    }

    public class TurnoHistorialDto
    {
        public long Id { get; set; }
        public long CajaId { get; set; }
        public string NombreCaja { get; set; } = string.Empty;
        public long UsuarioVendedorId { get; set; }
        public string NombreVendedor { get; set; } = string.Empty;
        public DateTime FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public decimal MontoApertura { get; set; }
        public decimal? MontoCierre { get; set; }
        public string Estado { get; set; } = string.Empty;
        public decimal TotalVentas { get; set; }
        public int CantidadTransacciones { get; set; }
        public int Total { get; set; } // Para paginación con COUNT(*) OVER()
    }
}
