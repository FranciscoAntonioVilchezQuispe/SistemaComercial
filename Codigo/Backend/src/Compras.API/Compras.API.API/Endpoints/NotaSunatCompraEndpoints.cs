using Compras.API.Application.Comandos;
using Compras.API.Application.DTOs;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace Compras.API.Endpoints
{
    public static class NotaSunatCompraEndpoints
    {
        public static void MapNotaSunatCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/compras/notas").WithTags("Notas SUNAT (Compras)");

            // Notas de Crédito Compra
            grupo.MapPost("/credito", async (NotaCreditoCompraDto dto, IMediator mediator) =>
            {
                try
                {
                    var resultado = await mediator.Send(new CrearNotaCreditoCompraComando(dto));
                    return Results.Created($"/api/compras/notas/credito/{resultado.Id}", resultado);
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Notas de Débito Compra
            grupo.MapPost("/debito", async (NotaDebitoCompraDto dto, IMediator mediator) =>
            {
                try
                {
                    var resultado = await mediator.Send(new CrearNotaDebitoCompraComando(dto));
                    return Results.Created($"/api/compras/notas/debito/{resultado.Id}", resultado);
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });
        }
    }
}
