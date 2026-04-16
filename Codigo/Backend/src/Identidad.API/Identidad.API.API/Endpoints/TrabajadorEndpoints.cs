using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Endpoints
{
    public static class TrabajadorEndpoints
    {
        public static void MapTrabajadorEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/trabajadores").WithTags("Trabajadores");

            grupo.MapGet("/", async (ITrabajadorRepositorio repo) =>
            {
                var trabajadores = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Trabajador>(trabajadores));
            });

            grupo.MapGet("/{id}", async (long id, ITrabajadorRepositorio repo) =>
            {
                var trabajador = await repo.ObtenerPorIdAsync(id);
                return trabajador != null 
                    ? Results.Ok(new ToReturn<Trabajador>(trabajador)) 
                    : Results.NotFound();
            });

            // Endpoints para auxiliares: Cargos y Áreas
            app.MapGet("/api/cargos", async (ICargoRepositorio repo) =>
            {
                var datos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Cargo>(datos));
            }).WithTags("Auxiliares");

            app.MapGet("/api/areas", async (IAreaRepositorio repo) =>
            {
                var datos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Area>(datos));
            }).WithTags("Auxiliares");
        }
    }
}
