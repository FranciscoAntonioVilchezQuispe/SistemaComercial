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

            grupo.MapGet("/", async (IOrdenCompraRepositorio repo) =>
            {
                var ordenes = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<OrdenCompra>(ordenes));
            });

            grupo.MapGet("/{id}", async (long id, IOrdenCompraRepositorio repo) =>
            {
                var orden = await repo.ObtenerPorIdAsync(id);
                if (orden == null) return Results.NotFound(new ToReturnError<OrdenCompra>("Orden de compra no encontrada", 404));
                return Results.Ok(new ToReturn<OrdenCompra>(orden));
            });

            grupo.MapPost("/", async (OrdenCompraDto dto, IOrdenCompraRepositorio repo) =>
            {
                var orden = new OrdenCompra
                {
                    CodigoOrden = dto.CodigoOrden,
                    IdProveedor = dto.IdProveedor,
                    IdAlmacenDestino = dto.IdAlmacenDestino,
                    FechaEmision = dto.FechaEmision,
                    FechaEntregaEstimada = dto.FechaEntregaEstimada,
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
                        UsuarioCreacion = "SISTEMA"
                    }).ToList()
                };
                var creado = await repo.AgregarAsync(orden);
                return Results.Created($"/api/ordenes-compra/{creado.Id}", new ToReturn<OrdenCompra>(creado));
            });
        }
    }
}
