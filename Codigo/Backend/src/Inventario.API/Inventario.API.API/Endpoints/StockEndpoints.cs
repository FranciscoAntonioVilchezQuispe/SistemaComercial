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
using Nucleo.Comun.Domain;
using System.Linq;
using System.Threading.Tasks;
using System;

namespace Inventario.API.Endpoints
{
    public static class StockEndpoints
    {
        public static void MapStockEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/stock").WithTags("Stock");
            
            grupo.MapPost("/ajuste", async (AjusteStockDto dto, IMediator mediator) =>
            {
                try 
                {
                    var comando = new AjustarStockComando(dto.IdProducto, dto.IdAlmacen, dto.NuevaCantidad, dto.Motivo);
                    await mediator.Send(comando);
                    return Results.Ok(new { mensaje = "Ajuste de stock realizado correctamente" });
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"[ERROR] [StockEndpoints] [PostAjuste] → Falló el ajuste de stock");
                    throw new AppException("StockEndpoints", "Error al procesar el ajuste de stock", dto, ex);
                }
            });

            grupo.MapGet("/", async ([AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request, long? idAlmacen, long? idProducto, IStockRepositorio repo) =>
            {
                try 
                {
                    var (stockList, total) = await repo.ObtenerPaginadoAsync(idAlmacen, idProducto, request.PageNumber ?? 1, request.PageSize ?? 10);

                    var dtos = stockList.Select(s => new StockDto
                    {
                        Id = s.Id,
                        IdProducto = s.IdProducto,
                        IdVariante = s.IdVariante,
                        IdAlmacen = s.IdAlmacen,
                        CantidadActual = s.CantidadActual,
                        CantidadReservada = s.CantidadReservada,
                        UbicacionFisica = s.UbicacionFisica,
                        UltimaActualizacion = s.FechaActualizacion
                    }).ToList();

                    var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<StockDto>(dtos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                    return Results.Ok(response);
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"[ERROR] [StockEndpoints] [GetStockPaginado] → Error al obtener stock paginado");
                    throw new AppException("StockEndpoints", "Error al obtener la lista de stock paginada", request, ex);
                }
            });

            grupo.MapGet("/producto/{idProducto}", async (long idProducto, IStockRepositorio repo) =>
            {
                try
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
                        UltimaActualizacion = s.FechaActualizacion
                    }).ToList();

                    return Results.Ok(new ToReturnList<StockDto>(dtos));
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"[ERROR] [StockEndpoints] [GetStockPorProducto] → Error para Producto={idProducto}");
                    throw new AppException("StockEndpoints", "Error al obtener stock del producto", new { idProducto }, ex);
                }
            });

            grupo.MapGet("/producto/{idProducto}/almacen/{idAlmacen}", async (long idProducto, long idAlmacen, IStockRepositorio repo) =>
            {
                try
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
                        UltimaActualizacion = stock.FechaActualizacion
                    };

                    return Results.Ok(new ToReturn<StockDto>(dto));
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"[ERROR] [StockEndpoints] [GetStockPorProductoAlmacen] → Error para Producto={idProducto}, Almacen={idAlmacen}");
                    throw new AppException("StockEndpoints", "Error al obtener stock del producto en almacén", new { idProducto, idAlmacen }, ex);
                }
            });

            grupo.MapGet("/almacen/{idAlmacen}", async (long idAlmacen, IStockRepositorio repo) =>
            {
                try
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
                        UltimaActualizacion = s.FechaActualizacion
                    }).ToList();

                    return Results.Ok(new ToReturnList<StockDto>(dtos));
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine($"[ERROR] [StockEndpoints] [GetStockPorAlmacen] → Error para Almacen={idAlmacen}");
                    throw new AppException("StockEndpoints", "Error al obtener stock del almacén", new { idAlmacen }, ex);
                }
            });
        }
    }
}
