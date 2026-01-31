using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class ImagenProductoEndpoints
    {
        public static void MapImagenProductoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/imagenes-producto").WithTags("Imágenes de Producto");

            grupo.MapGet("/producto/{idProducto}", async (long idProducto, IImagenProductoRepositorio repo) =>
            {
                var imagenes = await repo.ObtenerPorProductoAsync(idProducto);
                return Results.Ok(new ToReturnList<ImagenProducto>(imagenes));
            });

            grupo.MapPost("/", async (CrearImagenProductoDto dto, IImagenProductoRepositorio repo) =>
            {
                var imagen = new ImagenProducto
                {
                    IdProducto = dto.IdProducto,
                    UrlImagen = dto.UrlImagen,
                    EsPrincipal = dto.EsPrincipal,
                    Orden = dto.Orden,
                    UsuarioCreacion = "SISTEMA"
                };
                var creada = await repo.AgregarAsync(imagen);
                return Results.Created($"/api/imagenes-producto/{creada.Id}", new ToReturn<ImagenProducto>(creada));
            });

            grupo.MapDelete("/{id}", async (long id, IImagenProductoRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
