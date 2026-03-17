using Inventario.API.Application.Interfaces;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Domain.Entidades;
using Inventario.API.Application.DTOs;
using Inventario.API.Application.Comandos;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using MediatR;

namespace Inventario.API.Endpoints
{
    public static class StockEndpoints
    {
        public static void MapStockEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/stock").WithTags("Stock");
            
            grupo.MapPost("/ajuste", async (AjusteStockDto dto, IMediator mediator) =>
            {
                var comando = new AjustarStockComando(dto.IdProducto, dto.IdAlmacen, dto.NuevaCantidad, dto.Motivo);
                await mediator.Send(comando);
                return Results.Ok(new { mensaje = "Ajuste de stock realizado correctamente" });
            });

            grupo.MapGet("/", async (long? idAlmacen, IStockRepositorio repo) =>
            {
                IEnumerable<Stock> stockList;
                if (idAlmacen.HasValue)
                {
                    stockList = await repo.ObtenerPorAlmacenAsync(idAlmacen.Value);
                }
                else
                {
                    stockList = await repo.ObtenerTodoAsync();
                }

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

            grupo.MapGet("/producto/{idProducto}", async (long idProducto, IStockRepositorio repo) =>
            {
                var stockList = await repo.ObtenerPorProductoAsync(idProducto);
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
