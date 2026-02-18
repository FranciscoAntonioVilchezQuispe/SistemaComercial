using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Collections.Generic;
using System;
using System.Threading.Tasks;

// DTO para Tipo Comprobante (Simplificado)
public class TipoComprobanteDto
{
    public string Codigo { get; set; } = null!;
    public string Nombre { get; set; } = null!;
    public bool MueveStock { get; set; }
    public string TipoMovimientoStock { get; set; } = "DEPENDIENTE";
    public bool EsCompra { get; set; }
    public bool EsVenta { get; set; }
    public bool EsOrdenCompra { get; set; }
}

namespace Configuracion.API.Endpoints
{
    public static class TipoComprobanteEndpoints
    {
        public static void MapTipoComprobanteEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/tipos-comprobante").WithTags("Tipos de Comprobante");

            grupo.MapGet("/", async (string? modulo, ITipoComprobanteRepositorio repo) =>
            {
                var tipos = await repo.ObtenerTodosAsync();

                if (!string.IsNullOrEmpty(modulo))
                {
                    modulo = modulo.ToUpper();
                    if (modulo == "COMPRA") tipos = tipos.Where(t => t.EsCompra);
                    else if (modulo == "VENTA") tipos = tipos.Where(t => t.EsVenta);
                    else if (modulo == "ORDEN_COMPRA") tipos = tipos.Where(t => t.EsOrdenCompra);
                }

                return Results.Ok(new ToReturnList<TipoComprobante>(tipos));
            });

            grupo.MapGet("/{id}", async (long id, ITipoComprobanteRepositorio repo) =>
            {
                var tipo = await repo.ObtenerPorIdAsync(id);
                if (tipo == null) return Results.NotFound(new ToReturnError<object>("Tipo no encontrado", 404));
                return Results.Ok(new ToReturn<TipoComprobante>(tipo));
            });

            grupo.MapPost("/", async (TipoComprobanteDto dto, ITipoComprobanteRepositorio repo) =>
            {
                var tipo = new TipoComprobante
                {
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    MueveStock = dto.MueveStock,
                    TipoMovimientoStock = dto.TipoMovimientoStock,
                    EsCompra = dto.EsCompra,
                    EsVenta = dto.EsVenta,
                    EsOrdenCompra = dto.EsOrdenCompra,
                    UsuarioCreacion = "SISTEMA",
                    Activado = true
                };
                var creado = await repo.AgregarAsync(tipo);
                return Results.Created($"/api/tipos-comprobante/{creado.Id}", new ToReturn<TipoComprobante>(creado));
            });

            grupo.MapPut("/{id}", async (long id, TipoComprobanteDto dto, ITipoComprobanteRepositorio repo) =>
            {
                var tipo = await repo.ObtenerPorIdAsync(id);
                if (tipo == null) return Results.NotFound(new ToReturnError<object>("Tipo no encontrado", 404));

                tipo.Codigo = dto.Codigo;
                tipo.Nombre = dto.Nombre;
                tipo.MueveStock = dto.MueveStock;
                tipo.TipoMovimientoStock = dto.TipoMovimientoStock;
                tipo.EsCompra = dto.EsCompra;
                tipo.EsVenta = dto.EsVenta;
                tipo.EsOrdenCompra = dto.EsOrdenCompra;
                tipo.UsuarioActualizacion = "SISTEMA";
                tipo.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(tipo);
                return Results.Ok(new ToReturn<TipoComprobante>(tipo));
            });

            grupo.MapDelete("/{id}", async (long id, ITipoComprobanteRepositorio repo) =>
            {
                var tipo = await repo.ObtenerPorIdAsync(id);
                if (tipo == null) return Results.NotFound(new ToReturnError<object>("Tipo no encontrado", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}
