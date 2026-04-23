using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Features.Turnos;

namespace Ventas.API.Endpoints
{
    public static class CajaEndpoints
    {
        public static void MapCajaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/cajas").WithTags("Cajas");

            grupo.MapGet("/", async (ICajaRepositorio repo) =>
            {
                var cajas = await repo.ObtenerTodasAsync();
                return Results.Ok(new ToReturnList<Caja>(cajas));
            });

            grupo.MapGet("/{id}", async (long id, ICajaRepositorio repo) =>
            {
                var caja = await repo.ObtenerPorIdAsync(id);
                if (caja == null) return Results.NotFound(new ToReturnError<Caja>("Caja no encontrada", 404));
                return Results.Ok(new ToReturn<Caja>(caja));
            });

            // NUEVO: Crear caja
            grupo.MapPost("/", async ([FromBody] CrearCajaRequest request, [FromHeader(Name = "X-User-Id")] string userIdHeader, [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                request.UsuarioId = userId;
                var result = await mediator.Send(request);
                return Results.Created($"/api/cajas/{result.Id}", result);
            })
            .WithName("CrearCaja");

            // NUEVO: Actualizar caja
            grupo.MapPut("/{id:long}", async (long id, [FromBody] ActualizarCajaRequest request, [FromServices] IMediator mediator) =>
            {
                request.Id = id;
                var result = await mediator.Send(request);
                return result != null ? Results.Ok(result) : Results.NotFound();
            })
            .WithName("ActualizarCaja");

            // NUEVO: Cambiar estado (activar/desactivar)
            grupo.MapPatch("/{id:long}/estado", async (long id, [FromBody] CambiarEstadoCajaRequest request, [FromServices] IMediator mediator) =>
            {
                request.Id = id;
                var result = await mediator.Send(request);
                return Results.Ok(result);
            })
            .WithName("CambiarEstadoCaja");

            // NUEVO: Registrar movimiento de caja
            grupo.MapPost("/{cajaId:long}/movimientos", async (
                long cajaId,
                [FromBody] RegistrarMovimientoRequest body,
                [FromHeader(Name = "X-User-Id")] string userIdHeader,
                [FromHeader(Name = "X-User-Nombre")] string? userNombreHeader,
                [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                var comando = new RegistrarMovimientoCajaComando
                {
                    IdCaja = cajaId,
                    IdTurnoVendedor = body.IdTurnoVendedor,
                    IdTipoMovimiento = body.IdTipoMovimiento,
                    Monto = body.Monto,
                    Concepto = body.Concepto,
                    UsuarioId = userId,
                    UsuarioNombre = userNombreHeader ?? userId.ToString()
                };
                var result = await mediator.Send(comando);
                return Results.Created($"/api/cajas/{cajaId}/movimientos/{result.Id}", result);
            })
            .WithName("RegistrarMovimientoCaja");

            // NUEVO: Listar movimientos del turno
            grupo.MapGet("/{cajaId:long}/movimientos", async (
                long cajaId,
                [FromQuery] long turnoId,
                [FromServices] IMediator mediator) =>
            {
                var query = new ObtenerMovimientosTurnoQuery { TurnoVendedorId = turnoId };
                var result = await mediator.Send(query);
                return Results.Ok(result);
            })
            .WithName("ObtenerMovimientosCaja");
        }
    }
}
