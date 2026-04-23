using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Interfaces;
using Ventas.API.Domain.Entidades;
using Dapper;
using System.Data;
using System.Text;

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
                .Where(t => t.Id == request.TurnoVendedorId 
                       && t.UsuarioVendedorId == request.UsuarioVendedorId 
                       && t.Estado == "ABIERTO")
                .FirstOrDefaultAsync(cancellationToken);

            if (turno == null)
                throw new Exception("Turno no encontrado o ya cerrado.");

            // Cargar métodos de pago para mapear por Código (evitar IDs hardcodeados)
            var metodosPago = await _context.MetodosPago.ToListAsync(cancellationToken);
            var idEfectivo = metodosPago.FirstOrDefault(m => m.Codigo == "EFECTIVO")?.Id ?? 0;
            var idTarjeta = metodosPago.FirstOrDefault(m => m.Codigo == "TARJETA")?.Id ?? 0;
            var idTransferencia = metodosPago.FirstOrDefault(m => m.Codigo == "TRANSFERENCIA")?.Id ?? 0;

            var pagos = turno.Ventas
                .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65) // excluir anulados
                .SelectMany(v => v.Pagos)
                .ToList();

            decimal totalVentas = turno.Ventas
                .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65)
                .Sum(v => v.TotalVenta);

            decimal totalEfectivo = pagos.Where(p => p.IdMetodoPago == idEfectivo).Sum(p => p.MontoPago);
            decimal totalTarjeta = pagos.Where(p => p.IdMetodoPago == idTarjeta).Sum(p => p.MontoPago);
            decimal totalTransfer = pagos.Where(p => p.IdMetodoPago == idTransferencia).Sum(p => p.MontoPago);
            decimal totalOtros = pagos
                .Where(p => p.IdMetodoPago != idEfectivo && p.IdMetodoPago != idTarjeta && p.IdMetodoPago != idTransferencia)
                .Sum(p => p.MontoPago);

            // Calcular movimientos manuales del turno
            var movimientosTurno = await _context.MovimientosCaja
                .Where(m => m.IdTurnoVendedor == turno.Id && m.IdPagoRelacionado == null)
                .ToListAsync(cancellationToken);

            // Ingresos manuales = movimientos con Monto > 0 y sin pago relacionado
            // Egresos manuales = movimientos con Monto < 0 y sin pago relacionado
            decimal totalIngresosManualles = movimientosTurno.Where(m => m.Monto > 0).Sum(m => m.Monto);
            decimal totalEgresosManualles = movimientosTurno.Where(m => m.Monto < 0).Sum(m => Math.Abs(m.Monto));

            // MontoEsperado = apertura + efectivo ventas + ingresos manuales - egresos manuales
            decimal montoEsperado = turno.MontoApertura + totalEfectivo + totalIngresosManualles - totalEgresosManualles;

            turno.FechaFin = DateTime.UtcNow;
            turno.Estado = "CERRADO";
            turno.MontoCierre = request.MontoFisicoContado;

            var cierre = new CierreTurno
            {
                TurnoVendedorId = turno.Id,
                FechaGeneracion = DateTime.UtcNow,
                TotalVentas = totalVentas,
                TotalEfectivo = totalEfectivo,
                TotalTarjeta = totalTarjeta,
                TotalTransferencia = totalTransfer,
                TotalOtros = totalOtros,
                CantidadTransacciones = turno.Ventas.Count(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65),
                TotalIngresosManualles = totalIngresosManualles,
                TotalEgresosManualles = totalEgresosManualles,
                MontoEsperado = montoEsperado,
                MontoFisicoContado = request.MontoFisicoContado,
                DiferenciaArqueo = request.MontoFisicoContado - montoEsperado,
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
                TotalIngresosManualles = cierre.TotalIngresosManualles,
                TotalEgresosManualles = cierre.TotalEgresosManualles,
                MontoEsperado = cierre.MontoEsperado,
                MontoFisicoContado = cierre.MontoFisicoContado,
                DiferenciaArqueo = cierre.DiferenciaArqueo,
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

    public class ObtenerResumenPrevioCierreManejador : IRequestHandler<ObtenerResumenPrevioCierreQuery, TurnoResumenPrevioDto>
    {
        private readonly IVentasDbContext _context;

        public ObtenerResumenPrevioCierreManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<TurnoResumenPrevioDto> Handle(ObtenerResumenPrevioCierreQuery request, CancellationToken cancellationToken)
        {
            var turno = await _context.TurnosVendedor
                .Include(t => t.Ventas)
                    .ThenInclude(v => v.Pagos)
                .Where(t => t.Id == request.TurnoVendedorId && t.Estado == "ABIERTO")
                .FirstOrDefaultAsync(cancellationToken);

            if (turno == null)
                throw new Exception("Turno no encontrado o ya cerrado.");

            // Verificar que el usuario sea el dueño del turno
            if (turno.UsuarioVendedorId != request.UsuarioVendedorId)
                throw new Exception("No tienes permiso para ver este turno.");

            var metodosPago = await _context.MetodosPago.ToListAsync(cancellationToken);
            var idEfectivo = metodosPago.FirstOrDefault(m => m.Codigo == "EFECTIVO")?.Id ?? 0;
            var idTarjeta = metodosPago.FirstOrDefault(m => m.Codigo == "TARJETA")?.Id ?? 0;
            var idTransferencia = metodosPago.FirstOrDefault(m => m.Codigo == "TRANSFERENCIA")?.Id ?? 0;

            var ventasActivas = turno.Ventas
                .Where(v => v.IdEstado != 61 && v.IdEstado != 64 && v.IdEstado != 65)
                .ToList();
            var pagos = ventasActivas.SelectMany(v => v.Pagos).ToList();

            decimal totalEfectivo = pagos.Where(p => p.IdMetodoPago == idEfectivo).Sum(p => p.MontoPago);
            decimal totalTarjeta = pagos.Where(p => p.IdMetodoPago == idTarjeta).Sum(p => p.MontoPago);
            decimal totalTransferencia = pagos.Where(p => p.IdMetodoPago == idTransferencia).Sum(p => p.MontoPago);
            decimal totalOtros = pagos
                .Where(p => p.IdMetodoPago != idEfectivo && p.IdMetodoPago != idTarjeta && p.IdMetodoPago != idTransferencia)
                .Sum(p => p.MontoPago);

            var movimientosManuales = await _context.MovimientosCaja
                .Where(m => m.IdTurnoVendedor == turno.Id && m.IdPagoRelacionado == null)
                .ToListAsync(cancellationToken);

            decimal totalIngresos = movimientosManuales.Where(m => m.Monto > 0).Sum(m => m.Monto);
            decimal totalEgresos = movimientosManuales.Where(m => m.Monto < 0).Sum(m => Math.Abs(m.Monto));
            decimal montoEsperado = turno.MontoApertura + totalEfectivo + totalIngresos - totalEgresos;

            return new TurnoResumenPrevioDto
            {
                TurnoId = turno.Id,
                MontoApertura = turno.MontoApertura,
                TotalVentas = ventasActivas.Sum(v => v.TotalVenta),
                TotalEfectivo = totalEfectivo,
                TotalTarjeta = totalTarjeta,
                TotalTransferencia = totalTransferencia,
                TotalOtros = totalOtros,
                TotalIngresosManualles = totalIngresos,
                TotalEgresosManualles = totalEgresos,
                MontoEsperadoEnCaja = montoEsperado,
                CantidadVentas = ventasActivas.Count,
                MovimientosManuales = movimientosManuales.Select(m => new MovimientoListDto
                {
                    Id = m.Id,
                    IdCaja = m.IdCaja,
                    IdTurnoVendedor = m.IdTurnoVendedor,
                    Monto = m.Monto,
                    Concepto = m.Concepto,
                    FechaMovimiento = m.FechaMovimiento,
                    UsuarioResponsable = m.UsuarioResponsable
                }).ToList()
            };
        }
    }

    public class RegistrarMovimientoCajaManejador : IRequestHandler<RegistrarMovimientoCajaComando, MovimientoListDto>
    {
        private readonly IVentasDbContext _context;

        public RegistrarMovimientoCajaManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<MovimientoListDto> Handle(RegistrarMovimientoCajaComando request, CancellationToken cancellationToken)
        {
            if (request.Monto == 0)
                throw new Exception("El monto no puede ser cero.");

            var movimiento = new MovimientoCaja
            {
                IdCaja = request.IdCaja,
                IdTurnoVendedor = request.IdTurnoVendedor,
                IdTipoMovimiento = request.IdTipoMovimiento,
                Monto = request.Monto, // positivo = ingreso, negativo = egreso
                Concepto = request.Concepto,
                FechaMovimiento = DateTime.UtcNow,
                UsuarioResponsable = request.UsuarioNombre
            };

            _context.MovimientosCaja.Add(movimiento);
            await _context.SaveChangesAsync(cancellationToken);

            return new MovimientoListDto
            {
                Id = movimiento.Id,
                IdCaja = movimiento.IdCaja,
                IdTurnoVendedor = movimiento.IdTurnoVendedor,
                IdTipoMovimiento = movimiento.IdTipoMovimiento,
                Monto = movimiento.Monto,
                Concepto = movimiento.Concepto,
                FechaMovimiento = movimiento.FechaMovimiento,
                UsuarioResponsable = movimiento.UsuarioResponsable
            };
        }
    }

    public class ObtenerHistorialTurnosManejador : IRequestHandler<ObtenerHistorialTurnosQuery, Nucleo.Comun.Application.Paginacion.PagedResponse<TurnoHistorialDto>>
    {
        private readonly IVentasDbContext _context;

        public ObtenerHistorialTurnosManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<Nucleo.Comun.Application.Paginacion.PagedResponse<TurnoHistorialDto>> Handle(ObtenerHistorialTurnosQuery request, CancellationToken cancellationToken)
        {
            var connection = _context.Database.GetDbConnection();
            if (connection.State != ConnectionState.Open)
                await connection.OpenAsync(cancellationToken);

            var offset = (request.PageNumber - 1) * request.PageSize;

            var whereClause = new StringBuilder("WHERE tv.activado = true");
            var parametros = new DynamicParameters();
            parametros.Add("pageSize", request.PageSize);
            parametros.Add("offset", offset);

            if (request.CajaId.HasValue)
            {
                whereClause.Append(" AND tv.id_caja = @cajaId");
                parametros.Add("cajaId", request.CajaId.Value);
            }
            if (!string.IsNullOrWhiteSpace(request.Estado))
            {
                whereClause.Append(" AND tv.estado = @estado");
                parametros.Add("estado", request.Estado);
            }
            if (request.FechaDesde.HasValue)
            {
                whereClause.Append(" AND tv.fecha_inicio >= @fechaDesde");
                parametros.Add("fechaDesde", request.FechaDesde.Value);
            }
            if (request.FechaHasta.HasValue)
            {
                whereClause.Append(" AND tv.fecha_inicio <= @fechaHasta");
                parametros.Add("fechaHasta", request.FechaHasta.Value);
            }

            var sql = $@"
                SELECT
                    tv.id_turno_vendedor AS Id,
                    tv.id_caja AS CajaId,
                    c.nombre_caja AS NombreCaja,
                    tv.id_usuario_vendedor AS UsuarioVendedorId,
                    '' AS NombreVendedor,
                    tv.fecha_inicio AS FechaInicio,
                    tv.fecha_fin AS FechaFin,
                    tv.monto_apertura AS MontoApertura,
                    tv.monto_cierre AS MontoCierre,
                    tv.estado AS Estado,
                    COALESCE(SUM(v.total_venta) FILTER (WHERE v.id_estado NOT IN (61,64,65)), 0) AS TotalVentas,
                    COUNT(v.id_venta) FILTER (WHERE v.id_estado NOT IN (61,64,65)) AS CantidadTransacciones,
                    COUNT(*) OVER() AS Total
                FROM ventas.turno_vendedor tv
                INNER JOIN ventas.cajas c ON c.id_caja = tv.id_caja
                LEFT JOIN ventas.ventas v ON v.id_turno_vendedor = tv.id_turno_vendedor
                {whereClause}
                GROUP BY tv.id_turno_vendedor, tv.id_caja, c.nombre_caja, tv.id_usuario_vendedor,
                         tv.fecha_inicio, tv.fecha_fin, tv.monto_apertura, tv.monto_cierre, tv.estado
                ORDER BY tv.fecha_inicio DESC
                LIMIT @pageSize OFFSET @offset";

            var rows = (await connection.QueryAsync<TurnoHistorialDto>(sql, parametros)).ToList();
            var total = rows.FirstOrDefault()?.Total ?? 0;

            return new Nucleo.Comun.Application.Paginacion.PagedResponse<TurnoHistorialDto>(
                rows, request.PageNumber, request.PageSize, total);
        }
    }

    public class ObtenerMovimientosTurnoManejador : IRequestHandler<ObtenerMovimientosTurnoQuery, List<MovimientoListDto>>
    {
        private readonly IVentasDbContext _context;

        public ObtenerMovimientosTurnoManejador(IVentasDbContext context)
        {
            _context = context;
        }

        public async Task<List<MovimientoListDto>> Handle(ObtenerMovimientosTurnoQuery request, CancellationToken cancellationToken)
        {
            return await _context.MovimientosCaja
                .Where(m => m.IdTurnoVendedor == request.TurnoVendedorId && m.IdPagoRelacionado == null)
                .OrderBy(m => m.FechaMovimiento)
                .Select(m => new MovimientoListDto
                {
                    Id = m.Id,
                    IdCaja = m.IdCaja,
                    IdTurnoVendedor = m.IdTurnoVendedor,
                    IdTipoMovimiento = m.IdTipoMovimiento,
                    Monto = m.Monto,
                    Concepto = m.Concepto,
                    FechaMovimiento = m.FechaMovimiento,
                    UsuarioResponsable = m.UsuarioResponsable
                })
                .ToListAsync(cancellationToken);
        }
    }

    public class CrearCajaManejador : IRequestHandler<CrearCajaRequest, Caja>
    {
        private readonly IVentasDbContext _context;
        public CrearCajaManejador(IVentasDbContext context) { _context = context; }
        public async Task<Caja> Handle(CrearCajaRequest request, CancellationToken cancellationToken)
        {
            var caja = new Caja
            {
                NombreCaja = request.NombreCaja,
                IdAlmacen = request.IdAlmacen,
                IdEstado = 60, // Registrado/Activo según tablas generales
                MontoApertura = 0,
                MontoActual = 0
            };

            _context.Cajas.Add(caja);
            await _context.SaveChangesAsync(cancellationToken);
            return caja;
        }
    }

    public class ActualizarCajaManejador : IRequestHandler<ActualizarCajaRequest, Caja?>
    {
        private readonly IVentasDbContext _context;
        public ActualizarCajaManejador(IVentasDbContext context) { _context = context; }
        public async Task<Caja?> Handle(ActualizarCajaRequest request, CancellationToken cancellationToken)
        {
            var caja = await _context.Cajas.FindAsync(new object[] { request.Id }, cancellationToken);
            if (caja == null) return null;
            caja.NombreCaja = request.NombreCaja;
            caja.IdAlmacen = request.IdAlmacen;
            await _context.SaveChangesAsync(cancellationToken);
            return caja;
        }
    }

    public class CambiarEstadoCajaManejador : IRequestHandler<CambiarEstadoCajaRequest, Caja>
    {
        private readonly IVentasDbContext _context;
        public CambiarEstadoCajaManejador(IVentasDbContext context) { _context = context; }
        public async Task<Caja> Handle(CambiarEstadoCajaRequest request, CancellationToken cancellationToken)
        {
            var caja = await _context.Cajas.FindAsync(new object[] { request.Id }, cancellationToken)
                ?? throw new Exception("Caja no encontrada.");
            caja.Activado = request.Activado;
            await _context.SaveChangesAsync(cancellationToken);
            return caja;
        }
    }
}
