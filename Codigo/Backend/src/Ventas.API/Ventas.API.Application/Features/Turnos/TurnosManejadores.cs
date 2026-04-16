using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;

namespace Ventas.API.Application.Features.Turnos
{
    public class AbrirTurnoManejador : IRequestHandler<AbrirTurnoComando, TurnoVendedorDto>
    {
        private readonly IVentasDbContext _context;

        public AbrirTurnoManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<TurnoVendedorDto> Handle(AbrirTurnoComando request, CancellationToken cancellationToken)
        {
            // Validar si ya tiene un turno abierto
            var turnoExistente = await _context.TurnosVendedor
                .Where(t => t.UsuarioVendedorId == request.UsuarioVendedorId && t.Estado == "ABIERTO")
                .FirstOrDefaultAsync(cancellationToken);

            if (turnoExistente != null)
            {
                throw new Exception("El usuario ya tiene un turno abierto.");
            }

            var turno = new TurnoVendedor
            {
                UsuarioVendedorId = request.UsuarioVendedorId,
                CajaId = request.CajaId,
                FechaInicio = DateTime.UtcNow, // De acuerdo a la regla general, deberíamos usar helper de fechas o se configurará Utc en BD
                MontoApertura = request.MontoApertura,
                Estado = "ABIERTO"
            };

            _context.TurnosVendedor.Add(turno);
            await _context.SaveChangesAsync(cancellationToken);

            return new TurnoVendedorDto
            {
                Id = turno.Id,
                UsuarioVendedorId = turno.UsuarioVendedorId,
                CajaId = turno.CajaId,
                FechaInicio = turno.FechaInicio,
                MontoApertura = turno.MontoApertura,
                Estado = turno.Estado
            };
        }
    }

    public class CerrarTurnoManejador : IRequestHandler<CerrarTurnoComando, CierreTurnoDto>
    {
        private readonly IVentasDbContext _context;

        public CerrarTurnoManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<CierreTurnoDto> Handle(CerrarTurnoComando request, CancellationToken cancellationToken)
        {
            var turno = await _context.TurnosVendedor
                .Include(t => t.Ventas)
                    .ThenInclude(v => v.Pagos)
                .Where(t => t.Id == request.TurnoVendedorId && t.UsuarioVendedorId == request.UsuarioVendedorId && t.Estado == "ABIERTO")
                .FirstOrDefaultAsync(cancellationToken);

            if (turno == null)
            {
                throw new Exception("Turno no encontrado o ya cerrado.");
            }

            var idAprobados = new[] { 1L, 2L }; // Ejemplo: 1 = Pago, etc. Depende de config (EstadoPago)
            // Calculamos totales a partir de los pagos (asumiendo MetodoPagoId nos indica efectivo, tarjeta, etc.)
            // EF evaluation (se puede hacer optimizado o directo con Dapper, pero aquí lo calculamos en memoria para los pocos de un turno diario)

            decimal totalVentas = turno.Ventas.Sum(v => v.TotalVenta);
            var pagos = turno.Ventas.SelectMany(v => v.Pagos).ToList();
            
            // Asumiendo IDs genéricos (1=Efectivo, 2=Tarjeta, 3=Transferencia) - Esto requeriría base de datos o constante, lo simplificaremos.
            decimal totalEfectivo = pagos.Where(p => p.IdMetodoPago == 1).Sum(p => p.MontoPago);
            decimal totalTarjeta = pagos.Where(p => p.IdMetodoPago == 2).Sum(p => p.MontoPago);
            decimal totalTransfer = pagos.Where(p => p.IdMetodoPago == 3).Sum(p => p.MontoPago);
            decimal totalOtros = pagos.Where(p => p.IdMetodoPago > 3).Sum(p => p.MontoPago);

            turno.FechaFin = DateTime.UtcNow;
            turno.Estado = "CERRADO";
            turno.MontoCierre = turno.MontoApertura + totalEfectivo; // Cierre en base a efectivo

            var cierre = new CierreTurno
            {
                TurnoVendedorId = turno.Id,
                FechaGeneracion = DateTime.UtcNow,
                TotalVentas = totalVentas,
                TotalEfectivo = totalEfectivo,
                TotalTarjeta = totalTarjeta,
                TotalTransferencia = totalTransfer,
                TotalOtros = totalOtros,
                CantidadTransacciones = turno.Ventas.Count,
                Observaciones = request.Observaciones,
                Estado = "CONFIRMADO"
            };

            _context.CierresTurno.Add(cierre);
            await _context.SaveChangesAsync(cancellationToken);

            return new CierreTurnoDto
            {
                Id = cierre.Id,
                TurnoVendedorId = cierre.TurnoVendedorId,
                FechaGeneracion = cierre.FechaGeneracion,
                TotalVentas = cierre.TotalVentas,
                TotalEfectivo = cierre.TotalEfectivo,
                TotalTarjeta = cierre.TotalTarjeta,
                TotalTransferencia = cierre.TotalTransferencia,
                TotalOtros = cierre.TotalOtros,
                CantidadTransacciones = cierre.CantidadTransacciones,
                Observaciones = cierre.Observaciones,
                Estado = cierre.Estado
            };
        }
    }

    public class ObtenerTurnoActualManejador : IRequestHandler<ObtenerTurnoActualQuery, TurnoVendedorDto?>
    {
        private readonly IVentasDbContext _context;

        public ObtenerTurnoActualManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<TurnoVendedorDto?> Handle(ObtenerTurnoActualQuery request, CancellationToken cancellationToken)
        {
            return await _context.TurnosVendedor
                .Where(t => t.UsuarioVendedorId == request.UsuarioVendedorId && t.Estado == "ABIERTO")
                .Select(t => new TurnoVendedorDto
                {
                    Id = t.Id,
                    UsuarioVendedorId = t.UsuarioVendedorId,
                    CajaId = t.CajaId,
                    FechaInicio = t.FechaInicio,
                    FechaFin = t.FechaFin,
                    MontoApertura = t.MontoApertura,
                    MontoCierre = t.MontoCierre,
                    Estado = t.Estado
                })
                .FirstOrDefaultAsync(cancellationToken);
        }
    }
}
