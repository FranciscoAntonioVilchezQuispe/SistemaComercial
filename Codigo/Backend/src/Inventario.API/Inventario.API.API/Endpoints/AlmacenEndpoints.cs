using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Inventario.API.Endpoints
{
    public static class AlmacenEndpoints
    {
        public static void MapAlmacenEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/almacenes").WithTags("Almacenes");

            grupo.MapGet("/", async (IAlmacenRepositorio repo) =>
            {
                var almacenes = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Almacen>(almacenes));
            });

            grupo.MapPost("/", async (AlmacenDto dto, IAlmacenRepositorio repo) =>
            {
                var almacen = new Almacen
                {
                    NombreAlmacen = dto.NombreAlmacen,
                    Direccion = dto.Direccion,
                    EsPrincipal = dto.EsPrincipal,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(almacen);
                return Results.Created($"/api/almacenes/{creado.Id}", new ToReturn<Almacen>(creado));
            });
        }
    }
}
