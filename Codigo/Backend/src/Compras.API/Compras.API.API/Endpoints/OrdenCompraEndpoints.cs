using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;

namespace Compras.API.Endpoints
{
    public static class OrdenCompraEndpoints
    {
        public static void MapOrdenCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/ordenes-compra").WithTags("Ordenes de Compra");

            grupo.MapGet("/ping", () => Results.Ok("pong"));

            grupo.MapGet("/", async ([AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request, IOrdenCompraRepositorio repo) =>
            {
                var (ordenes, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber ?? 1, request.PageSize ?? 10);
                var dtos = ordenes.Select(o => MapToDto(o)).ToList();
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<OrdenCompraDto>(dtos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/siguiente-numero", async (IOrdenCompraRepositorio repo) =>
            {
                var siguiente = await repo.ObtenerSiguienteNumeroAsync();
                return Results.Ok(new ToReturn<string>(siguiente));
            });

            grupo.MapGet("/{id}", async (long id, IOrdenCompraRepositorio repo) =>
            {
                var orden = await repo.ObtenerPorIdAsync(id);
                if (orden == null) return Results.NotFound(new ToReturnError<OrdenCompraDto>("Orden de compra no encontrada", 404));
                return Results.Ok(new ToReturn<OrdenCompraDto>(MapToDto(orden)));
            });

            grupo.MapPost("/", async (OrdenCompraDto dto, IOrdenCompraRepositorio repo) =>
            {
                try
                {
                    var orden = new OrdenCompra
                    {
                        CodigoOrden = dto.CodigoOrden ?? string.Empty,
                        IdProveedor = dto.IdProveedor,
                        IdAlmacenDestino = dto.IdAlmacenDestino,
                        FechaEmision = DateTime.SpecifyKind(dto.FechaEmision, DateTimeKind.Utc),
                        FechaEntregaEstimada = dto.FechaEntregaEstimada.HasValue
                            ? DateTime.SpecifyKind(dto.FechaEntregaEstimada.Value, DateTimeKind.Utc)
                            : null,
                        IdEstado = dto.IdEstado,
                        TotalImporte = dto.TotalImporte,
                        Observaciones = dto.Observaciones,
                        UsuarioCreacion = "SISTEMA",
                        Detalles = dto.Detalles.Select(d => new DetalleOrdenCompra
                        {
                            IdProducto = d.IdProducto,
                            IdVariante = d.IdVariante,
                            CantidadSolicitada = d.CantidadSolicitada,
                            PrecioUnitarioPactado = d.PrecioUnitarioPactado,
                            Subtotal = d.Subtotal,
                            CantidadRecibida = 0,
                            UsuarioCreacion = "SISTEMA"
                        }).ToList()
                    };
                    var creado = await repo.AgregarAsync(orden);
                    // Retornar objeto simplificado para evitar ciclos de serialización
                    var resultado = new { creado.Id, creado.CodigoOrden };
                    return Results.Created($"/api/ordenes-compra/{creado.Id}", new ToReturn<object>(resultado));
                }
                catch (System.Exception ex)
                {
                    var mensaje = ex.InnerException?.Message ?? ex.Message;
                    return Results.Json(new ToReturnError<object>(mensaje, 500), statusCode: 500);
                }
            });

            grupo.MapPatch("/{id}/estado", async (long id, long idEstado, IOrdenCompraRepositorio repo) =>
            {
                var orden = await repo.ActualizarEstadoAsync(id, idEstado);
                if (orden == null) return Results.NotFound(new ToReturnError<OrdenCompraDto>("Orden de compra no encontrada", 404));
                
                // Recargar para obtener datos enriquecidos si el Repo no los devuelve al actualizar
                var ordenEnriquecida = await repo.ObtenerPorIdAsync(id);
                return Results.Ok(new ToReturn<OrdenCompraDto>(MapToDto(ordenEnriquecida!)));
            });
        }

        private static OrdenCompraDto MapToDto(OrdenCompra o)
        {
            return new OrdenCompraDto
            {
                Id = o.Id,
                CodigoOrden = o.CodigoOrden,
                IdProveedor = o.IdProveedor,
                IdAlmacenDestino = o.IdAlmacenDestino,
                FechaEmision = o.FechaEmision,
                FechaEntregaEstimada = o.FechaEntregaEstimada,
                IdEstado = o.IdEstado,
                TotalImporte = o.TotalImporte,
                Observaciones = o.Observaciones,
                IdTipoComprobante = o.IdTipoComprobante,
                Serie = o.Serie,
                Numero = o.Numero,
                RazonSocialProveedor = o.RazonSocialProveedor,
                IdTipoDocumentoProveedor = o.IdTipoDocumentoProveedor,
                NumeroDocumentoProveedor = o.NumeroDocumentoProveedor,
                NombreAlmacen = o.NombreAlmacen,
                Detalles = o.Detalles.Select(d => new DetalleOrdenCompraDto
                {
                    Id = d.Id,
                    IdProducto = d.IdProducto,
                    IdVariante = d.IdVariante,
                    CantidadSolicitada = d.CantidadSolicitada,
                    PrecioUnitarioPactado = d.PrecioUnitarioPactado,
                    Subtotal = d.Subtotal,
                    CantidadRecibida = d.CantidadRecibida,
                    NombreProducto = d.NombreProducto,
                    UnidadMedidaSimbolo = d.UnidadMedidaSimbolo
                }).ToList()
            };
        }
    }
}
