using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System;

namespace Configuracion.API.Endpoints
{
    public static class TipoTributoEndpoints
    {
        public static void MapTipoTributoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/configuracion/tipo-tributo").WithTags("Tipos de Tributo");

            grupo.MapGet("/", async (ITipoTributoRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<TipoTributo>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/todos", async (ITipoTributoRepositorio repo) =>
            {
                var todos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<TipoTributo>(todos));
            });

            grupo.MapGet("/{id}", async (long id, ITipoTributoRepositorio repo) =>
            {
                var tributo = await repo.ObtenerPorIdAsync(id);
                if (tributo == null) return Results.NotFound(new ToReturnError<object>("Tributo no encontrado", 404));
                return Results.Ok(new ToReturn<TipoTributo>(tributo));
            });

            grupo.MapPost("/", async (TipoTributoDto dto, ITipoTributoRepositorio repo) =>
            {
                var tributo = new TipoTributo
                {
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    CodigoInternacional = dto.CodigoInternacional,
                    Descripcion = dto.Descripcion,
                    UsuarioCreacion = "SISTEMA",
                    Activado = true
                };
                var creado = await repo.AgregarAsync(tributo);
                return Results.Created($"/api/configuracion/tipo-tributo/{creado.Id}", new ToReturn<TipoTributo>(creado));
            });

            grupo.MapPut("/{id}", async (long id, TipoTributoDto dto, ITipoTributoRepositorio repo) =>
            {
                var tributo = await repo.ObtenerPorIdAsync(id);
                if (tributo == null) return Results.NotFound(new ToReturnError<object>("Tributo no encontrado", 404));

                tributo.Codigo = dto.Codigo;
                tributo.Nombre = dto.Nombre;
                tributo.CodigoInternacional = dto.CodigoInternacional;
                tributo.Descripcion = dto.Descripcion;
                tributo.UsuarioActualizacion = "SISTEMA";
                tributo.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(tributo);
                return Results.Ok(new ToReturn<TipoTributo>(tributo));
            });

            grupo.MapDelete("/{id}", async (long id, ITipoTributoRepositorio repo) =>
            {
                var tributo = await repo.ObtenerPorIdAsync(id);
                if (tributo == null) return Results.NotFound(new ToReturnError<object>("Tributo no encontrado", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });

            grupo.MapPost("/inicializar", async (ITipoTributoRepositorio repo) =>
            {
                await repo.InicializarAsync();
                return Results.Ok(new { message = "Catálogo de Tipos de Tributo inicializado correctamente." });
            });
        }
    }
}
