using Inventario.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Inventario.API.Application.Interfaces;
using Inventario.API.Application.DTOs;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;

namespace Inventario.API.Endpoints
{
    public static class MovimientosEndpoints
    {
        public static void MapMovimientosEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/movimientos").WithTags("Movimientos");
            
            grupo.MapGet("/", async (long? idProducto, long? idAlmacen, IInventarioDbContext context, int pagina = 1, int limite = 10) =>
            {
                var query = context.MovimientosInventario.AsQueryable();

                if (idProducto.HasValue)
                {
                    query = query.Where(m => m.Stock.IdProducto == idProducto.Value);
                }

                if (idAlmacen.HasValue)
                {
                    query = query.Where(m => m.Stock.IdAlmacen == idAlmacen.Value);
                }

                var total = await query.CountAsync();
                var movimientos = await query
                    .OrderByDescending(m => m.Id)
                    .Skip((pagina - 1) * limite)
                    .Take(limite)
                    .Select(m => new MovimientoInventarioDto
                    {
                        Id = m.Id,
                        IdTipoMovimiento = m.IdTipoMovimiento,
                        IdStock = m.IdStock,
                        Cantidad = m.Cantidad,
                        CantidadAnterior = m.CantidadAnterior,
                        CantidadNueva = m.CantidadNueva,
                        CostoUnitarioMovimiento = m.CostoUnitarioMovimiento,
                        ReferenciaModulo = m.ReferenciaModulo,
                        IdReferencia = m.IdReferencia,
                        Observaciones = m.Observaciones,
                        FechaCreacion = m.FechaCreacion,
                        UsuarioCreacion = m.UsuarioCreacion
                    })
                    .ToListAsync();

                return Results.Ok(new ToReturnList<MovimientoInventarioDto>(movimientos, total));
            });

            grupo.MapPost("/", async (CrearMovimientoInventarioComando comando, IMediator mediator) =>
            {
                var id = await mediator.Send(comando);
                return Results.Created($"/api/movimientos/{id}", id);
            });

            grupo.MapGet("/{id}", async (long id, IMediator mediator) =>
            {
                var consulta = new Inventario.API.Application.Consultas.ObtenerMovimientoInventarioPorIdConsulta(id);
                var resultado = await mediator.Send(consulta);

                if (resultado == null)
                {
                    return Results.NotFound(new { Message = $"Movimiento con ID {id} no encontrado" });
                }

                return Results.Ok(resultado);
            });

            grupo.MapDelete("/referencia/{modulo}/{idReferencia}", async (string modulo, long idReferencia, IMediator mediator) =>
            {
                var exito = await mediator.Send(new EliminarMovimientosPorReferenciaComando(modulo, idReferencia));
                return exito ? Results.Ok(true) : Results.NotFound(false);
            });

            // Endpoint Especial de Sincronización Histórica
            grupo.MapPost("/sincronizar-compras", async ([FromQuery] bool reiniciar, IMediator mediator) =>
            {
                var result = await mediator.Send(new SincronizarComprasHistComando(reiniciar));
                return Results.Ok(new { Mensaje = result });
            });
        }
    }
}
