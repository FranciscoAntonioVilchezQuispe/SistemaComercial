using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class CategoriaEndpoints
    {
        public static void MapCategoriaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/categorias").WithTags("Categorias");

            grupo.MapGet("/", async (ICategoriaRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber, request.PageSize);

                var dtos = datos.Select(c => new CategoriaDto
                {
                    Id = c.Id,
                    Nombre = c.NombreCategoria,
                    Descripcion = c.Descripcion,
                    IdCategoriaPadre = c.IdCategoriaPadre,
                    ImagenUrl = c.ImagenUrl,
                    Activo = c.Activado
                });

                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<CategoriaDto>(dtos, request.PageNumber, request.PageSize, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, ICategoriaRepositorio repo) =>
            {
                var categoria = await repo.ObtenerPorIdAsync(id);
                if (categoria == null) return Results.NotFound(new ToReturnError<CategoriaDto>("Categoría no encontrada", 404));

                var dto = new CategoriaDto
                {
                    Id = categoria.Id,
                    Nombre = categoria.NombreCategoria,
                    Descripcion = categoria.Descripcion,
                    IdCategoriaPadre = categoria.IdCategoriaPadre,
                    ImagenUrl = categoria.ImagenUrl,
                    Activo = categoria.Activado
                };
                var response = new ToReturn<CategoriaDto>(dto);
                return Results.Ok(response);
            });

            grupo.MapPost("/", async (CrearCategoriaDto dto, ICategoriaRepositorio repo) =>
            {
                var categoria = new Categoria
                {
                    NombreCategoria = dto.Nombre,
                    Descripcion = dto.Descripcion,
                    IdCategoriaPadre = dto.IdCategoriaPadre,
                    ImagenUrl = dto.ImagenUrl,
                    UsuarioCreacion = "SISTEMA"
                };

                var creada = await repo.AgregarAsync(categoria);
                return Results.Created($"/api/categorias/{creada.Id}", new ToReturn<Categoria>(creada));
            });

            grupo.MapPut("/{id}", async (long id, CrearCategoriaDto dto, ICategoriaRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<Categoria>("Categoría no encontrada", 404));

                existente.NombreCategoria = dto.Nombre;
                existente.Descripcion = dto.Descripcion;
                existente.IdCategoriaPadre = dto.IdCategoriaPadre;
                existente.ImagenUrl = dto.ImagenUrl;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<Categoria>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, ICategoriaRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
