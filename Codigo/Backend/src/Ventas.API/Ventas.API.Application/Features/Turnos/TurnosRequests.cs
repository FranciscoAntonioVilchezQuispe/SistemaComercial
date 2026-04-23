using MediatR;
using Ventas.API.Application.DTOs;

namespace Ventas.API.Application.Features.Turnos
{
    public class AbrirTurnoComando : IRequest<TurnoVendedorDto>
    {
        public long CajaId { get; set; }
        public decimal MontoApertura { get; set; }
        public long UsuarioVendedorId { get; set; } // Obtenido del Header
    }

    public class CerrarTurnoComando : IRequest<CierreTurnoDto>
    {
        public long TurnoVendedorId { get; set; }
        public string? Observaciones { get; set; }
        public long UsuarioVendedorId { get; set; }
        public decimal MontoFisicoContado { get; set; } // NUEVO
    }

    public class ObtenerTurnoActualQuery : IRequest<TurnoVendedorDto?>
    {
        public long UsuarioVendedorId { get; set; }
    }

    public class ObtenerResumenPrevioCierreQuery : IRequest<TurnoResumenPrevioDto>
    {
        public long TurnoVendedorId { get; set; }
        public long UsuarioVendedorId { get; set; }
    }

    public class ObtenerHistorialTurnosQuery : IRequest<Nucleo.Comun.Application.Paginacion.PagedResponse<TurnoHistorialDto>>
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
        public long? CajaId { get; set; }
        public string? Estado { get; set; }
        public DateTime? FechaDesde { get; set; }
        public DateTime? FechaHasta { get; set; }
    }

    public class RegistrarMovimientoCajaComando : IRequest<MovimientoListDto>
    {
        public long IdCaja { get; set; }
        public long? IdTurnoVendedor { get; set; }
        public long IdTipoMovimiento { get; set; }
        public decimal Monto { get; set; }
        public string Concepto { get; set; } = string.Empty;
        public long UsuarioId { get; set; }
        public string UsuarioNombre { get; set; } = string.Empty;
    }

    public class ObtenerMovimientosTurnoQuery : IRequest<System.Collections.Generic.List<MovimientoListDto>>
    {
        public long TurnoVendedorId { get; set; }
    }

    public class CrearCajaRequest : IRequest<Ventas.API.Domain.Entidades.Caja>
    {
        public string NombreCaja { get; set; } = string.Empty;
        public long IdAlmacen { get; set; }
        public long UsuarioId { get; set; }
    }

    public class ActualizarCajaRequest : IRequest<Ventas.API.Domain.Entidades.Caja?>
    {
        public long Id { get; set; }
        public string NombreCaja { get; set; } = string.Empty;
        public long IdAlmacen { get; set; }
    }

    public class CambiarEstadoCajaRequest : IRequest<Ventas.API.Domain.Entidades.Caja>
    {
        public long Id { get; set; }
        public bool Activado { get; set; }
    }
}
