using Ventas.API.Domain.Entidades;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Domain.DTOs;
using Ventas.API.Application.DTOs;
using Ventas.API.Application.Comandos;
using Ventas.API.Infrastructure.Datos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Nucleo.Comun.Application.Wrappers;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace Ventas.API.Endpoints
{
    public static class VentaEndpoints
    {
        public static void MapVentaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/ventas").WithTags("Ventas");

            grupo.MapGet("/", async (IVentaRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<VentaListDto>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            // IMPORTANTE: rutas con segmentos fijos DEBEN ir ANTES de /{id}
            grupo.MapGet("/series", async (long? idTipoComprobante, long? idAlmacen, VentasDbContext db) =>
            {
                var query = db.SeriesComprobantes.AsQueryable();
                if (idTipoComprobante.HasValue)
                    query = query.Where(s => s.IdTipoComprobante == idTipoComprobante.Value);
                if (idAlmacen.HasValue)
                    query = query.Where(s => s.IdAlmacen == idAlmacen.Value);
                var series = await query.OrderBy(s => s.Serie).ToListAsync();
                return Results.Ok(new ToReturnList<Ventas.API.Domain.Entidades.Referencias.SeriesComprobante>(series));
            });

            grupo.MapGet("/hoy", async (IVentaRepositorio repo) =>
            {
                var ventas = await repo.ObtenerTodasAsync();
                var hoy = DateTime.UtcNow.Date;
                // Para efectos de simplicidad en este endpoint temporal, devolvemos una lista simplificada
                var ventasHoy = ventas.Where(v => v.FechaEmision.Date == hoy)
                                      .Select(v => new { v.Id, v.Serie, v.Numero, v.TotalVenta }).ToList();
                return Results.Ok(new ToReturnList<object>(ventasHoy));
            });

            grupo.MapGet("/estadisticas", async (string? fechaInicio, string? fechaFin, IVentaRepositorio repo) =>
            {
                var ventas = await repo.ObtenerTodasAsync();
                var lista = ventas.AsQueryable();
                if (!string.IsNullOrEmpty(fechaInicio) && DateTime.TryParse(fechaInicio, out var fi))
                    lista = lista.Where(v => v.FechaEmision >= fi);
                if (!string.IsNullOrEmpty(fechaFin) && DateTime.TryParse(fechaFin, out var ff))
                    lista = lista.Where(v => v.FechaEmision <= ff);
                var resumen = new { total = lista.Sum(v => v.TotalVenta), cantidad = lista.Count() };
                return Results.Ok(new ToReturn<object>(resumen));
            });

            grupo.MapGet("/{id}", async (long id, IVentaRepositorio repo) =>
            {
                var venta = await repo.ObtenerDetallePorIdAsync(id);
                if (venta == null) return Results.NotFound(new ToReturnError<VentaDetalleDto>("Venta no encontrada", 404));
                return Results.Ok(new ToReturn<VentaDetalleDto>(venta));
            });

            grupo.MapPatch("/{id}/anular", async (long id, [FromBody] AnularVentaRequest request, IMediator mediator) =>
            {
                try
                {
                    var exito = await mediator.Send(new AnularVentaComando(id, string.IsNullOrWhiteSpace(request?.Motivo) ? "Anulación solicitada por el usuario" : request.Motivo, request?.UsuarioId ?? 0));
                    return exito ? Results.Ok(new ToReturn<bool>(true)) : Results.BadRequest(new ToReturnError<bool>("No se pudo anular la venta", 400));
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new ToReturnError<bool>(ex.Message, 400));
                }
            });

            grupo.MapPost("/", async (VentaDto dto, IMediator mediator) =>
            {
                try
                {
                    var resultDto = await mediator.Send(new CrearVentaComando(dto));
                    return Results.Created($"/api/ventas/{resultDto.Id}", new ToReturn<VentaDto>(resultDto));
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new ToReturnError<VentaDto>(ex.Message, 400));
                }
            });
        }
    }

    public static class CotizacionEndpoints
    {
        public static void MapCotizacionEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/cotizaciones").WithTags("Cotizaciones");

            grupo.MapGet("/", async (ICotizacionRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<CotizacionListDto>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, ICotizacionRepositorio repo) =>
            {
                var cotizacion = await repo.ObtenerDetallePorIdAsync(id);
                if (cotizacion == null) return Results.NotFound(new ToReturnError<CotizacionDetalleDto>("Cotización no encontrada", 404));
                return Results.Ok(new ToReturn<CotizacionDetalleDto>(cotizacion));
            });
        }
    }
}
