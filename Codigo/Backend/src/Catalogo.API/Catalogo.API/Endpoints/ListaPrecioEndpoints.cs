using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class ListaPrecioEndpoints
    {
        public static void MapListaPrecioEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/listas-precios").WithTags("Listas de Precios");

            grupo.MapGet("/", async (IListaPrecioRepositorio repo) =>
            {
                var listas = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<ListaPrecio>(listas));
            });

            grupo.MapGet("/{id}", async (long id, IListaPrecioRepositorio repo) =>
            {
                var lista = await repo.ObtenerPorIdAsync(id);
                if (lista == null) return Results.NotFound(new ToReturnError<ListaPrecio>("Lista de precio no encontrada", 404));
                return Results.Ok(new ToReturn<ListaPrecio>(lista));
            });

            grupo.MapPost("/", async (CrearListaPrecioDto dto, IListaPrecioRepositorio repo) =>
            {
                var lista = new ListaPrecio
                {
                    NombreLista = dto.NombreLista,
                    EsBase = dto.EsBase,
                    PorcentajeGananciaSugerido = dto.PorcentajeGananciaSugerido,
                    UsuarioCreacion = "SISTEMA"
                };
                var creada = await repo.AgregarAsync(lista);
                return Results.Created($"/api/listas-precios/{creada.Id}", new ToReturn<ListaPrecio>(creada));
            });

            grupo.MapPut("/{id}", async (long id, CrearListaPrecioDto dto, IListaPrecioRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<ListaPrecio>("Lista de precio no encontrada", 404));

                existente.NombreLista = dto.NombreLista;
                existente.EsBase = dto.EsBase;
                existente.PorcentajeGananciaSugerido = dto.PorcentajeGananciaSugerido;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<ListaPrecio>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IListaPrecioRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
