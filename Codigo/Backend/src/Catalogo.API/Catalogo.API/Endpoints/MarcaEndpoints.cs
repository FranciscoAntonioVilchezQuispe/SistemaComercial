using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class MarcaEndpoints
    {
        public static void MapMarcaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/marcas").WithTags("Marcas");

            grupo.MapGet("/", async (IMarcaRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber, request.PageSize);

                var dtos = datos.Select(m => new MarcaDto
                {
                    Id = m.Id,
                    Nombre = m.NombreMarca,
                    Activo = m.Activado,
                    PaisOrigen = m.PaisOrigen
                });

                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<MarcaDto>(dtos, request.PageNumber, request.PageSize, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, IMarcaRepositorio repo) =>
            {
                var marca = await repo.ObtenerPorIdAsync(id);
                if (marca == null) return Results.NotFound(new ToReturnError<MarcaDto>("Marca no encontrada", 404));

                var dto = new MarcaDto
                {
                    Id = marca.Id,
                    Nombre = marca.NombreMarca,
                    Activo = marca.Activado,
                    PaisOrigen = marca.PaisOrigen
                };
                return Results.Ok(new ToReturn<MarcaDto>(dto));
            });

            grupo.MapPost("/", async (CrearMarcaDto dto, IMarcaRepositorio repo) =>
            {
                var marca = new Marca
                {
                    NombreMarca = dto.Nombre,
                    PaisOrigen = dto.PaisOrigen,
                    UsuarioCreacion = "SISTEMA"
                };
                var creada = await repo.AgregarAsync(marca);
                return Results.Created($"/api/marcas/{creada.Id}", new ToReturn<Marca>(creada));
            });

            grupo.MapPut("/{id}", async (long id, CrearMarcaDto dto, IMarcaRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<Marca>("Marca no encontrada", 404));

                existente.NombreMarca = dto.Nombre;
                existente.PaisOrigen = dto.PaisOrigen;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<Marca>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IMarcaRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
