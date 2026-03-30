using Compras.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;

namespace Compras.API.Endpoints
{
    public static class NotaSunatCompraEndpoints
    {
        public static void MapNotaSunatCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/compras/notas").WithTags("Notas SUNAT (Compras)");

            // Notas de Crédito Compra
            grupo.MapPost("/credito", async (CrearNotaCreditoCompraComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/compras/notas/credito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Notas de Débito Compra
            grupo.MapPost("/debito", async (CrearNotaDebitoCompraComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/compras/notas/debito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });
        }
    }
}
