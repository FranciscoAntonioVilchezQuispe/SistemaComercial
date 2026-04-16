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
    }

    public class ObtenerTurnoActualQuery : IRequest<TurnoVendedorDto?>
    {
        public long UsuarioVendedorId { get; set; }
    }
}
