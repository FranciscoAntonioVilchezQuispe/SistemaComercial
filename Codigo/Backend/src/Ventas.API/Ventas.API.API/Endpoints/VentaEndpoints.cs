using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;

namespace Ventas.API.Endpoints
{
    public static class VentaEndpoints
    {
        public static void MapVentaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/ventas").WithTags("Ventas");

            grupo.MapGet("/", async (IVentaRepositorio repo) =>
            {
                var ventas = await repo.ObtenerTodasAsync();
                var dtos = ventas.Select(v => MapVentaToDto(v)).ToList();
                return Results.Ok(new ToReturnList<VentaDto>(dtos));
            });

            grupo.MapGet("/{id}", async (long id, IVentaRepositorio repo) =>
            {
                var venta = await repo.ObtenerPorIdAsync(id);
                if (venta == null) return Results.NotFound(new ToReturnError<VentaDto>("Venta no encontrada", 404));
                return Results.Ok(new ToReturn<VentaDto>(MapVentaToDto(venta)));
            });

            grupo.MapPost("/", async (VentaDto dto, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(new CrearVentaComando(dto));
                    return Results.Created($"/api/ventas/{id}", new ToReturn<long>(id));
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new ToReturnError<long>(ex.Message, 400));
                }
            });
        }

        private static VentaDto MapVentaToDto(Venta v) => new VentaDto
        {
            Id = v.Id,
            IdEmpresa = v.IdEmpresa,
            IdAlmacen = v.IdAlmacen,
            IdCaja = v.IdCaja,
            IdCliente = v.IdCliente,
            IdUsuarioVendedor = v.IdUsuarioVendedor,
            IdCotizacionOrigen = v.IdCotizacionOrigen,
            IdTipoComprobante = v.IdTipoComprobante,
            Serie = v.Serie,
            Numero = v.Numero,
            FechaEmision = v.FechaEmision,
            FechaVencimientoPago = v.FechaVencimientoPago,
            IdEstado = v.IdEstado,
            Moneda = v.Moneda,
            TipoCambio = v.TipoCambio,
            SubtotalGravado = v.SubtotalGravado,
            SubtotalExonerado = v.SubtotalExonerado,
            SubtotalInafecto = v.SubtotalInafecto,
            TotalImpuesto = v.TotalImpuesto,
            TotalDescuentoGlobal = v.TotalDescuentoGlobal,
            TotalVenta = v.TotalVenta,
            SaldoPendiente = v.SaldoPendiente,
            IdEstadoPago = v.IdEstadoPago,
            Observaciones = v.Observaciones,
            Detalles = v.Detalles?.Select(d => new DetalleVentaDto
            {
                Id = d.Id,
                IdProducto = d.IdProducto,
                IdVariante = d.IdVariante,
                DescripcionProducto = d.DescripcionProducto,
                Cantidad = d.Cantidad,
                PrecioUnitario = d.PrecioUnitario,
                PrecioListaOriginal = d.PrecioListaOriginal,
                PorcentajeImpuesto = d.PorcentajeImpuesto,
                ImpuestoItem = d.ImpuestoItem,
                TotalItem = d.TotalItem
            }).ToList() ?? new()
        };
    }

    public static class CotizacionEndpoints
    {
        public static void MapCotizacionEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/cotizaciones").WithTags("Cotizaciones");

            grupo.MapGet("/", async (ICotizacionRepositorio repo) =>
            {
                var cotizaciones = await repo.ObtenerTodasAsync();
                var dtos = cotizaciones.Select(c => MapCotizacionToDto(c)).ToList();
                return Results.Ok(new ToReturnList<CotizacionDto>(dtos));
            });

            grupo.MapGet("/{id}", async (long id, ICotizacionRepositorio repo) =>
            {
                var cotizacion = await repo.ObtenerPorIdAsync(id);
                if (cotizacion == null) return Results.NotFound(new ToReturnError<CotizacionDto>("Cotización no encontrada", 404));
                return Results.Ok(new ToReturn<CotizacionDto>(MapCotizacionToDto(cotizacion)));
            });
        }

        private static CotizacionDto MapCotizacionToDto(Cotizacion c) => new CotizacionDto
        {
            Id = c.Id,
            Serie = c.Serie,
            Numero = c.Numero,
            IdCliente = c.IdCliente,
            IdUsuarioVendedor = c.IdUsuarioVendedor,
            FechaEmision = c.FechaEmision,
            FechaVencimiento = c.FechaVencimiento,
            IdEstado = c.IdEstado,
            Moneda = c.Moneda,
            TipoCambio = c.TipoCambio,
            Subtotal = c.Subtotal,
            Impuesto = c.Impuesto,
            Total = c.Total,
            Observaciones = c.Observaciones,
            Detalles = c.Detalles?.Select(d => new DetalleCotizacionDto
            {
                Id = d.Id,
                IdProducto = d.IdProducto,
                IdVariante = d.IdVariante,
                Cantidad = d.Cantidad,
                PrecioUnitario = d.PrecioUnitario,
                Subtotal = d.Subtotal
            }).ToList() ?? new()
        };
    }
}
