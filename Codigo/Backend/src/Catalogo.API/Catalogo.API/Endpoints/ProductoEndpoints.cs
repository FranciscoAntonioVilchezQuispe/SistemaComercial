using Catalogo.Application.Comandos;
using Catalogo.Application.DTOs;
using Catalogo.Domain.Entidades;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers; // Import wrapper

namespace Catalogo.API.Endpoints
{
    public static class ProductoEndpoints
    {
        public static void MapProductoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/productos").WithTags("Productos");

            grupo.MapPost("/", async (CrearProductoComando comando, ISender sender) =>
            {
                try
                {
                    var id = await sender.Send(comando);
                    var response = new ToReturn<long>(id);
                    return Results.Created($"/api/productos/{id}", response);
                }
                catch (Exception ex)
                {
                    var inner = ex.InnerException != null ? ex.InnerException.Message : "No Inner";
                    var msg = $"ERR: {ex.Message} || INNER: {inner}";
                    Console.WriteLine(msg);

                    var response = new ToReturnError<long>(msg, 500);
                    return Results.Json(response, statusCode: 500);
                }
            });

            // GET List Endpoint
            grupo.MapGet("/", async (Catalogo.Domain.Interfaces.IProductoRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber ?? 1, request.PageSize ?? 10);

                var dtos = datos.Select(p => MapToDto(p));

                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<ProductoDto>(dtos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            // GET By Id Endpoint
            grupo.MapGet("/{id:long}", async (long id, Catalogo.Domain.Interfaces.IProductoRepositorio repo) =>
            {
                var producto = await repo.ObtenerPorIdAsync(id);
                if (producto == null)
                    return Results.NotFound(new ToReturnError<string>($"Producto con ID {id} no encontrado", 404));

                var response = new ToReturn<ProductoDto>(MapToDto(producto));
                return Results.Ok(response);
            });
        }

        private static ProductoDto MapToDto(Producto p) => new ProductoDto
        {
            Id = p.Id,
            Codigo = p.CodigoProducto,
            Nombre = p.NombreProducto,
            Descripcion = p.Descripcion,
            IdCategoria = p.IdCategoria,
            Categoria = p.Categoria != null ? new CategoriaDto
            {
                Id = p.Categoria.Id,
                Nombre = p.Categoria.NombreCategoria,
                Descripcion = p.Categoria.Descripcion,
                IdCategoriaPadre = p.Categoria.IdCategoriaPadre,
                ImagenUrl = p.Categoria.ImagenUrl,
                Activo = p.Categoria.Activado
            } : null,
            IdMarca = p.IdMarca,
            Marca = p.Marca != null ? new MarcaDto
            {
                Id = p.Marca.Id,
                Nombre = p.Marca.NombreMarca,
                Descripcion = null, // Marca no tiene descripción en la entidad
                PaisOrigen = p.Marca.PaisOrigen,
                Activo = p.Marca.Activado
            } : null,
            IdTipoProducto = p.IdTipoProducto,

            // Códigos adicionales
            CodigoBarras = p.CodigoBarras,
            Sku = p.Sku,

            // Precios
            PrecioCompra = p.PrecioCompra,
            PrecioVentaPublico = p.PrecioVentaPublico,
            PrecioVentaMayorista = p.PrecioVentaMayorista,
            PrecioVentaDistribuidor = p.PrecioVentaDistribuidor,

            // Stock (viene de Inventario API, por ahora 0)
            Stock = 0,
            StockMinimo = p.StockMinimo,
            StockMaximo = p.StockMaximo,

            // Configuración de inventario
            TieneVariantes = p.TieneVariantes,
            PermiteInventarioNegativo = p.PermiteInventarioNegativo,
            MetodoValuacion = p.MetodoValuacion,

            // Configuración fiscal
            GravadoImpuesto = p.GravadoImpuesto,
            PorcentajeImpuesto = p.PorcentajeImpuesto,

            // Imagen
            ImagenPrincipalUrl = p.ImagenPrincipalUrl,
            IdUnidadMedida = p.IdUnidadMedida,
            UnidadMedida = p.UnidadMedida != null ? new UnidadMedidaDto
            {
                Id = p.UnidadMedida.Id,
                CodigoSunat = p.UnidadMedida.CodigoSunat,
                Nombre = p.UnidadMedida.NombreUnidad,
                Simbolo = p.UnidadMedida.Simbolo
            } : null,
            // Auditoría
            Activo = p.Activado,
            FechaCreacion = p.FechaCreacion,
            FechaModificacion = p.FechaActualizacion
        };
    }
}
