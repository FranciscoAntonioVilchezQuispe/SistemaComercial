using Inventario.API.Application.Comandos.Kardex;
using Inventario.API.Application.Consultas.Kardex;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using System;

namespace Inventario.API.Endpoints
{
    public static class KardexEndpoints
    {
        public static void MapKardexEndpoints(this IEndpointRouteBuilder routes)
        {
            var group = routes.MapGroup("/api/inventario/kardex").WithTags("Kardex");

            // 1. Reporte Formato 13.1 SUNAT
            group.MapGet("/reporte", async ([FromQuery] long almacenId, [FromQuery] long productoId, [FromQuery] DateTime desde, [FromQuery] DateTime hasta, IMediator mediator) =>
            {
                var result = await mediator.Send(new GenerarReporteKardexConsulta(almacenId, productoId, desde, hasta));
                return Results.Ok(result);
            });

            // 2. Control Periodos - Cerrar
            group.MapPost("/periodos/cerrar", async ([FromBody] CerrarPeriodoRequest req, IMediator mediator) =>
            {
                var result = await mediator.Send(new CerrarPeriodoComando(req.Periodo, req.UsuarioId));
                return Results.Ok(new { success = result, message = $"Periodo {req.Periodo} cerrado exitosamente." });
            });

            // 3. Control Periodos - Abrir
            group.MapPost("/periodos/abrir", async ([FromBody] AbrirPeriodoRequest req, IMediator mediator) =>
            {
                var result = await mediator.Send(new AbrirPeriodoComando(req.Periodo, req.UsuarioId));
                return Results.Ok(new { success = result, message = $"Periodo {req.Periodo} abierto exitosamente." });
            });

            // 4. Forzar Recálculo Retroactivo
            group.MapPost("/recalcular", async ([FromBody] RecalcularKardexRequest req, IMediator mediator) =>
            {
                var result = await mediator.Send(new RecalcularKardexComando(req.AlmacenId, req.ProductoId, req.DesdeFecha, req.Motivo, req.UsuarioId));
                return Results.Ok(new { success = result, message = "Recálculo ejecutado exitosamente." });
            });
        }
    }

    public record CerrarPeriodoRequest(string Periodo, long UsuarioId);
    public record AbrirPeriodoRequest(string Periodo, long UsuarioId);
    public record RecalcularKardexRequest(long AlmacenId, long ProductoId, DateTime DesdeFecha, string Motivo, long UsuarioId);
}
