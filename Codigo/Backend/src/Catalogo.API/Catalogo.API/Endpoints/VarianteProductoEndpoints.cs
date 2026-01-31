using Catalogo.Domain.Entidades;
using Catalogo.Domain.Interfaces;
using Catalogo.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Catalogo.API.Endpoints
{
    public static class VarianteProductoEndpoints
    {
        public static void MapVarianteProductoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/variantes-producto").WithTags("Variantes de Producto");

            grupo.MapGet("/producto/{idProducto}", async (long idProducto, IVarianteProductoRepositorio repo) =>
            {
                var variantes = await repo.ObtenerPorProductoAsync(idProducto);
                return Results.Ok(new ToReturnList<VarianteProducto>(variantes));
            });

            grupo.MapGet("/{id}", async (long id, IVarianteProductoRepositorio repo) =>
            {
                var variante = await repo.ObtenerPorIdAsync(id);
                if (variante == null) return Results.NotFound(new ToReturnError<VarianteProducto>("Variante no encontrada", 404));
                return Results.Ok(new ToReturn<VarianteProducto>(variante));
            });

            grupo.MapPost("/", async (CrearVarianteProductoDto dto, IVarianteProductoRepositorio repo) =>
            {
                var variante = new VarianteProducto
                {
                    IdProducto = dto.IdProducto,
                    SkuVariante = dto.SkuVariante,
                    CodigoBarrasVariante = dto.CodigoBarrasVariante,
                    NombreCompletoVariante = dto.NombreCompletoVariante,
                    AtributosJson = dto.AtributosJson,
                    PrecioAdicional = dto.PrecioAdicional,
                    UsuarioCreacion = "SISTEMA"
                };
                var creada = await repo.AgregarAsync(variante);
                return Results.Created($"/api/variantes-producto/{creada.Id}", new ToReturn<VarianteProducto>(creada));
            });

            grupo.MapPut("/{id}", async (long id, CrearVarianteProductoDto dto, IVarianteProductoRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<VarianteProducto>("Variante no encontrada", 404));

                existente.SkuVariante = dto.SkuVariante;
                existente.CodigoBarrasVariante = dto.CodigoBarrasVariante;
                existente.NombreCompletoVariante = dto.NombreCompletoVariante;
                existente.AtributosJson = dto.AtributosJson;
                existente.PrecioAdicional = dto.PrecioAdicional;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<VarianteProducto>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IVarianteProductoRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
