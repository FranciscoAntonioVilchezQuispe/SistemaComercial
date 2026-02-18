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

            grupo.MapGet("/", async (IOrdenCompraRepositorio repo) =>
            {
                var ordenes = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<OrdenCompra>(ordenes));
            });

            grupo.MapGet("/siguiente-numero", async (IOrdenCompraRepositorio repo) =>
            {
                var siguiente = await repo.ObtenerSiguienteNumeroAsync();
                return Results.Ok(new ToReturn<string>(siguiente));
            });

            grupo.MapGet("/{id}", async (long id, IOrdenCompraRepositorio repo) =>
            {
                var orden = await repo.ObtenerPorIdAsync(id);
                if (orden == null) return Results.NotFound(new ToReturnError<OrdenCompra>("Orden de compra no encontrada", 404));
                return Results.Ok(new ToReturn<OrdenCompra>(orden));
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
                if (orden == null) return Results.NotFound(new ToReturnError<OrdenCompra>("Orden de compra no encontrada", 404));
                return Results.Ok(new ToReturn<OrdenCompra>(orden));
            });
        }
    }
}
