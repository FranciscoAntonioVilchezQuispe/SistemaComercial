using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;

namespace Ventas.API.Endpoints
{
    public static class NotaSunatEndpoints
    {
        public static void MapNotaSunatEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/notas").WithTags("Notas SUNAT (Ventas)");

            // Notas de Crédito
            grupo.MapPost("/credito", async (CrearNotaCreditoComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/notas/credito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Notas de Débito
            grupo.MapPost("/debito", async (CrearNotaDebitoComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/notas/debito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });
        }
    }
}
