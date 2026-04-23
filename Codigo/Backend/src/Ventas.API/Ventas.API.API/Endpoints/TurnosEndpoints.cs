using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Features.Turnos;

namespace Ventas.API.API.Endpoints
{
    public static class TurnosEndpoints
    {
        public static void MapTurnosEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/turnos").WithTags("Turnos");

            group.MapPost("/abrir", async ([FromBody] AbrirTurnoComando comando, [FromHeader(Name = "X-User-Id")] string userIdHeader, [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                comando.UsuarioVendedorId = userId;
                
                var result = await mediator.Send(comando);
                return Results.Ok(result);
            })
            .WithName("AbrirTurno")
            .Produces<TurnoVendedorDto>(StatusCodes.Status200OK);

            group.MapPost("/cerrar", async ([FromBody] CerrarTurnoComando comando, [FromHeader(Name = "X-User-Id")] string userIdHeader, [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                comando.UsuarioVendedorId = userId;
                
                var result = await mediator.Send(comando);
                return Results.Ok(result);
            })
            .WithName("CerrarTurno")
            .Produces<CierreTurnoDto>(StatusCodes.Status200OK);

            group.MapGet("/actual", async ([FromHeader(Name = "X-User-Id")] string userIdHeader, [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                
                var query = new ObtenerTurnoActualQuery { UsuarioVendedorId = userId };
                var result = await mediator.Send(query);
                
                if (result == null) return Results.NotFound("No hay turno abierto.");
                return Results.Ok(result);
            })
            .WithName("ObtenerTurnoActual")
            .Produces<TurnoVendedorDto>(StatusCodes.Status200OK);

            group.MapGet("/resumen-previo/{turnoId:long}", async (
                long turnoId,
                [FromHeader(Name = "X-User-Id")] string userIdHeader,
                [FromServices] IMediator mediator) =>
            {
                if (!long.TryParse(userIdHeader, out long userId)) return Results.Unauthorized();
                var query = new ObtenerResumenPrevioCierreQuery { TurnoVendedorId = turnoId, UsuarioVendedorId = userId };
                var result = await mediator.Send(query);
                return Results.Ok(result);
            })
            .WithName("ObtenerResumenPrevioCierre")
            .Produces<TurnoResumenPrevioDto>(StatusCodes.Status200OK);

            group.MapGet("/historial", async (
                [FromQuery] int pageNumber,
                [FromQuery] int pageSize,
                [FromQuery] long? cajaId,
                [FromQuery] string? estado,
                [FromQuery] DateTime? fechaDesde,
                [FromQuery] DateTime? fechaHasta,
                [FromServices] IMediator mediator) =>
            {
                var query = new ObtenerHistorialTurnosQuery
                {
                    PageNumber = pageNumber <= 0 ? 1 : pageNumber,
                    PageSize = pageSize <= 0 ? 20 : pageSize,
                    CajaId = cajaId,
                    Estado = estado,
                    FechaDesde = fechaDesde,
                    FechaHasta = fechaHasta
                };
                var result = await mediator.Send(query);
                return Results.Ok(result);
            })
            .WithName("ObtenerHistorialTurnos")
            .Produces<Nucleo.Comun.Application.Paginacion.PagedResponse<TurnoHistorialDto>>(StatusCodes.Status200OK);
        }
    }
}
