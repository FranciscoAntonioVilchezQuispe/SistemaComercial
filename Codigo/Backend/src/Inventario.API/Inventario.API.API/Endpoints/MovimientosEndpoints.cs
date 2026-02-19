using Inventario.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;

namespace Inventario.API.Endpoints
{
    public static class MovimientosEndpoints
    {
        public static void MapMovimientosEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/movimientos").WithTags("Movimientos");

            grupo.MapPost("/", async (CrearMovimientoInventarioComando comando, IMediator mediator) =>
            {
                var id = await mediator.Send(comando);
                return Results.Created($"/api/movimientos/{id}", id);
            });

            grupo.MapGet("/{id}", async (long id, IMediator mediator) =>
            {
                var consulta = new Inventario.API.Application.Consultas.ObtenerMovimientoInventarioPorIdConsulta(id);
                var resultado = await mediator.Send(consulta);

                if (resultado == null)
                {
                    return Results.NotFound(new { Message = $"Movimiento con ID {id} no encontrado" });
                }

                return Results.Ok(resultado);
            });

            grupo.MapDelete("/referencia/{modulo}/{idReferencia}", async (string modulo, long idReferencia, IMediator mediator) =>
            {
                var exito = await mediator.Send(new EliminarMovimientosPorReferenciaComando(modulo, idReferencia));
                return exito ? Results.Ok(true) : Results.NotFound(false);
            });
        }
    }
}
