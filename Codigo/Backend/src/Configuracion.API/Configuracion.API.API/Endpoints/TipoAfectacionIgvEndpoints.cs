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
    public static class TipoAfectacionIgvEndpoints
    {
        public static void MapTipoAfectacionIgvEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/configuracion/tipo-afectacion").WithTags("Afectación IGV");

            grupo.MapGet("/", async (ITipoAfectacionIgvRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<TipoAfectacionIgv>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/todos", async (ITipoAfectacionIgvRepositorio repo) =>
            {
                var todos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<TipoAfectacionIgv>(todos));
            });

            grupo.MapGet("/{id}", async (long id, ITipoAfectacionIgvRepositorio repo) =>
            {
                var afectacion = await repo.ObtenerPorIdAsync(id);
                if (afectacion == null) return Results.NotFound(new ToReturnError<object>("Afectación no encontrada", 404));
                return Results.Ok(new ToReturn<TipoAfectacionIgv>(afectacion));
            });

            grupo.MapPost("/", async (TipoAfectacionIgvDto dto, ITipoAfectacionIgvRepositorio repo) =>
            {
                var afectacion = new TipoAfectacionIgv
                {
                    Codigo = dto.Codigo,
                    Descripcion = dto.Descripcion,
                    EsGravado = dto.EsGravado,
                    EsExonerado = dto.EsExonerado,
                    EsInafecto = dto.EsInafecto,
                    EsGratuito = dto.EsGratuito,
                    CodigoTributoDefault = dto.CodigoTributoDefault,
                    NombreTributoDefault = dto.NombreTributoDefault,
                    UsuarioCreacion = "SISTEMA",
                    Activado = true
                };
                var creado = await repo.AgregarAsync(afectacion);
                return Results.Created($"/api/configuracion/tipo-afectacion/{creado.Id}", new ToReturn<TipoAfectacionIgv>(creado));
            });

            grupo.MapPut("/{id}", async (long id, TipoAfectacionIgvDto dto, ITipoAfectacionIgvRepositorio repo) =>
            {
                var afectacion = await repo.ObtenerPorIdAsync(id);
                if (afectacion == null) return Results.NotFound(new ToReturnError<object>("Afectación no encontrada", 404));

                afectacion.Codigo = dto.Codigo;
                afectacion.Descripcion = dto.Descripcion;
                afectacion.EsGravado = dto.EsGravado;
                afectacion.EsExonerado = dto.EsExonerado;
                afectacion.EsInafecto = dto.EsInafecto;
                afectacion.EsGratuito = dto.EsGratuito;
                afectacion.CodigoTributoDefault = dto.CodigoTributoDefault;
                afectacion.NombreTributoDefault = dto.NombreTributoDefault;
                afectacion.UsuarioActualizacion = "SISTEMA";
                afectacion.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(afectacion);
                return Results.Ok(new ToReturn<TipoAfectacionIgv>(afectacion));
            });

            grupo.MapDelete("/{id}", async (long id, ITipoAfectacionIgvRepositorio repo) =>
            {
                var afectacion = await repo.ObtenerPorIdAsync(id);
                if (afectacion == null) return Results.NotFound(new ToReturnError<object>("Afectación no encontrada", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });

            grupo.MapPost("/inicializar", async (ITipoAfectacionIgvRepositorio repo) =>
            {
                await repo.InicializarAsync();
                return Results.Ok(new { message = "Catálogo de Afectación IGV inicializado correctamente." });
            });
        }
    }
}
