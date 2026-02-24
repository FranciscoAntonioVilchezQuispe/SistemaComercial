using Inventario.API.Application.Comandos;
using Inventario.API.Application.Consultas;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;

namespace Inventario.API.Endpoints
{
    public static class TrasladoEndpoints
    {
        public static void MapTrasladoEndpoints(this IEndpointRouteBuilder routes)
        {
            var group = routes.MapGroup("/api/inventario/traslados").WithTags("Traslados entre Almacenes");

            // 1. Crear y Despachar Traslado (Salida de Origen)
            group.MapPost("/", async ([FromBody] CrearTrasladoComando comando, IMediator mediator) =>
            {
                var id = await mediator.Send(comando);
                return Results.Ok(new { success = true, id_traslado = id, message = "Traslado despachado exitosamente" });
            });

            // 2. Confirmar Recepción de Traslado (Ingreso a Destino)
            group.MapPost("/recibir", async ([FromBody] RecibirTrasladoComando comando, IMediator mediator) =>
            {
                var resultado = await mediator.Send(comando);
                return Results.Ok(new { success = resultado, message = "Traslado recibido y stock actualizado" });
            });

            // 3. Obtener Traslados
            group.MapGet("/", async (IMediator mediator) =>
            {
                var traslados = await mediator.Send(new ObtenerTrasladosConsulta());
                return Results.Ok(traslados);
            });
        }
    }
}
