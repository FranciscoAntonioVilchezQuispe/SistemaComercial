using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class UnidadMedidaEndpoints
    {
        public static void MapUnidadMedidaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/unidades-medida").WithTags("Unidades de Medida");

            grupo.MapGet("/", async (IUnidadMedidaRepositorio repo) =>
            {
                var unidades = await repo.ObtenerTodosAsync();
                var dtos = unidades.Select(u => new UnidadMedidaDto
                {
                    Id = u.Id,
                    Nombre = u.NombreUnidad,
                    CodigoSunat = u.CodigoSunat,
                    Simbolo = u.Simbolo
                });
                return Results.Ok(new ToReturnList<UnidadMedidaDto>(dtos));
            });

            grupo.MapGet("/{id}", async (long id, IUnidadMedidaRepositorio repo) =>
            {
                var unidad = await repo.ObtenerPorIdAsync(id);
                if (unidad == null) return Results.NotFound(new ToReturnError<UnidadMedidaDto>("Unidad no encontrada", 404));

                var dto = new UnidadMedidaDto
                {
                    Id = unidad.Id,
                    Nombre = unidad.NombreUnidad,
                    CodigoSunat = unidad.CodigoSunat,
                    Simbolo = unidad.Simbolo
                };
                return Results.Ok(new ToReturn<UnidadMedidaDto>(dto));
            });

            grupo.MapPost("/", async (CrearUnidadMedidaDto dto, IUnidadMedidaRepositorio repo) =>
            {
                var unidad = new UnidadMedida
                {
                    CodigoSunat = dto.CodigoSunat,
                    NombreUnidad = dto.Nombre,
                    Simbolo = dto.Simbolo,
                    UsuarioCreacion = "SISTEMA"
                };
                var creada = await repo.AgregarAsync(unidad);
                return Results.Created($"/api/unidades-medida/{creada.Id}", new ToReturn<UnidadMedida>(creada));
            });

            grupo.MapPut("/{id}", async (long id, CrearUnidadMedidaDto dto, IUnidadMedidaRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<UnidadMedida>("Unidad no encontrada", 404));

                existente.CodigoSunat = dto.CodigoSunat;
                existente.NombreUnidad = dto.Nombre;
                existente.Simbolo = dto.Simbolo;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<UnidadMedida>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IUnidadMedidaRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
