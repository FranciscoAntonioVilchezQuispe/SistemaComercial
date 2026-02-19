using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Application.DTOs;
using Compras.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;

namespace Compras.API.Endpoints
{
    public static class CompraEndpoints
    {
        public static void MapCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/compras").WithTags("Compras");

            grupo.MapGet("/", async (ICompraRepositorio repo) =>
            {
                var compras = await repo.ObtenerTodosAsync();
                var dtos = compras.Select(c => MapToDto(c)).ToList();
                return Results.Ok(new ToReturnList<CompraDto>(dtos));
            });

            grupo.MapGet("/{id}", async (long id, ICompraRepositorio repo) =>
            {
                var compra = await repo.ObtenerPorIdAsync(id);
                if (compra == null) return Results.NotFound(new ToReturnError<CompraDto>("Compra no encontrada", 404));
                return Results.Ok(new ToReturn<CompraDto>(MapToDto(compra)));
            });

            grupo.MapPost("/", async (CompraDto dto, IMediator mediator) =>
            {
                var id = await mediator.Send(new CrearCompraComando(dto));
                return Results.Created($"/api/compras/{id}", new ToReturn<long>(id));
            });

            grupo.MapDelete("/{id}", async (long id, IMediator mediator) =>
            {
                var exito = await mediator.Send(new EliminarCompraComando(id));
                if (!exito) return Results.NotFound(new ToReturnError<bool>("Compra no encontrada", 404));
                return Results.Ok(new ToReturn<bool>(true));
            });
        }

        private static CompraDto MapToDto(Compra c) => new CompraDto
        {
            Id = c.Id,
            IdProveedor = c.IdProveedor,
            RazonSocialProveedor = c.Proveedor?.RazonSocial,
            IdAlmacen = c.IdAlmacen,
            // NombreAlmacen se poblaría aquí si tuviéramos la referencia en la entidad, 
            // pero como lo hicimos vía join en el repo, aseguramos que se pase.
            // Para simplicidad en este paso, asumimos que el repo ya enriqueció la entidad si es posible,
            // o lo mapeamos directamente si tenemos acceso a las propiedades de navegación.
            IdOrdenCompraRef = c.IdOrdenCompraRef,
            IdTipoComprobante = c.IdTipoComprobante,
            SerieComprobante = c.SerieComprobante,
            NumeroComprobante = c.NumeroComprobante,
            FechaEmision = c.FechaEmision,
            FechaContable = c.FechaContable,
            IdMoneda = c.Moneda == "USD" ? 2 : 1,
            Moneda = c.Moneda,
            TipoCambio = c.TipoCambio,
            Subtotal = c.Subtotal,
            Impuesto = c.Impuesto,
            Total = c.Total,
            SaldoPendiente = c.SaldoPendiente,
            IdEstadoPago = c.IdEstadoPago,
            Observaciones = c.Observaciones,
            NombreAlmacen = c.NombreAlmacen,
            NombreTipoComprobante = c.NombreTipoComprobante,
            NumeroDocumentoProveedor = c.Proveedor?.NumeroDocumento,
            NombreTipoDocumentoProveedor = c.NombreTipoDocumentoProveedor,
            Detalles = c.Detalles?.Select(d => new DetalleCompraDto
            {
                Id = d.Id,
                IdProducto = d.IdProducto,
                NombreProducto = d.Descripcion, // El repo puso el nombre en Descripcion
                IdVariante = d.IdVariante,
                Descripcion = d.Descripcion,
                Cantidad = d.Cantidad,
                PrecioUnitarioCompra = d.PrecioUnitarioCompra,
                Subtotal = d.Subtotal
            }).ToList() ?? new()
        };
    }
}
