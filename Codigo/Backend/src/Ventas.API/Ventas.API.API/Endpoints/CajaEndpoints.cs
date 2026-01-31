using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

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
        }
    }
}
