using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Inventario.API.Endpoints
{
    public static class StockEndpoints
    {
        public static void MapStockEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/stock").WithTags("Stock");

            grupo.MapGet("/producto/{idProducto}/almacen/{idAlmacen}", async (long idProducto, long idAlmacen, IStockRepositorio repo) =>
            {
                var stock = await repo.ObtenerPorProductoAlmacenAsync(idProducto, idAlmacen);
                if (stock == null) return Results.NotFound(new ToReturnError<StockDto>("Stock no encontrado", 404));

                var dto = new StockDto
                {
                    Id = stock.Id,
                    IdProducto = stock.IdProducto,
                    IdVariante = stock.IdVariante,
                    IdAlmacen = stock.IdAlmacen,
                    CantidadActual = stock.CantidadActual,
                    CantidadReservada = stock.CantidadReservada,
                    UbicacionFisica = stock.UbicacionFisica,
                    FechaActualizacion = stock.FechaActualizacion ?? stock.FechaCreacion
                };

                return Results.Ok(new ToReturn<StockDto>(dto));
            });

            grupo.MapGet("/almacen/{idAlmacen}", async (long idAlmacen, IStockRepositorio repo) =>
            {
                var stockList = await repo.ObtenerPorAlmacenAsync(idAlmacen);
                var dtos = stockList.Select(s => new StockDto
                {
                    Id = s.Id,
                    IdProducto = s.IdProducto,
                    IdVariante = s.IdVariante,
                    IdAlmacen = s.IdAlmacen,
                    CantidadActual = s.CantidadActual,
                    CantidadReservada = s.CantidadReservada,
                    UbicacionFisica = s.UbicacionFisica,
                    FechaActualizacion = s.FechaActualizacion ?? s.FechaCreacion
                }).ToList();

                return Results.Ok(new ToReturnList<StockDto>(dtos));
            });
        }
    }
}
