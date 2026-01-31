using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System;

namespace Configuracion.API.Endpoints
{
    // DTO para Serie
    public class SerieComprobanteDto
    {
        public long IdTipoComprobante { get; set; }
        public string Serie { get; set; } = null!;
        public long CorrelativoActual { get; set; }
        public long? IdAlmacen { get; set; }
    }

    public static class SerieComprobanteEndpoints
    {
        public static void MapSerieComprobanteEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/series").WithTags("Series de Comprobante");

            grupo.MapGet("/", async (ISerieComprobanteRepositorio repo) =>
            {
                var series = await repo.ObtenerTodasAsync();
                return Results.Ok(new ToReturnList<SerieComprobante>(series));
            });

            grupo.MapGet("/{id}", async (long id, ISerieComprobanteRepositorio repo) =>
            {
                var serie = await repo.ObtenerPorIdAsync(id);
                if (serie == null) return Results.NotFound(new ToReturnError<object>("Serie no encontrada", 404));
                return Results.Ok(new ToReturn<SerieComprobante>(serie));
            });

            grupo.MapGet("/tipo/{idTipo}", async (long idTipo, ISerieComprobanteRepositorio repo) =>
            {
                var series = await repo.ObtenerPorTipoAsync(idTipo);
                return Results.Ok(new ToReturnList<SerieComprobante>(series));
            });

            grupo.MapPost("/", async (SerieComprobanteDto dto, ISerieComprobanteRepositorio repo) =>
            {
                var serie = new SerieComprobante
                {
                    IdTipoComprobante = dto.IdTipoComprobante,
                    Serie = dto.Serie,
                    CorrelativoActual = dto.CorrelativoActual,
                    IdAlmacen = dto.IdAlmacen,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(serie);
                return Results.Created($"/api/series/{creado.Id}", new ToReturn<SerieComprobante>(creado));
            });

            grupo.MapPut("/{id}", async (long id, SerieComprobanteDto dto, ISerieComprobanteRepositorio repo) =>
            {
                var serie = await repo.ObtenerPorIdAsync(id);
                if (serie == null) return Results.NotFound(new ToReturnError<object>("Serie no encontrada", 404));

                serie.IdTipoComprobante = dto.IdTipoComprobante;
                serie.Serie = dto.Serie;
                serie.CorrelativoActual = dto.CorrelativoActual;
                serie.IdAlmacen = dto.IdAlmacen;
                serie.UsuarioActualizacion = "SISTEMA";
                serie.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(serie);
                return Results.Ok(new ToReturn<SerieComprobante>(serie));
            });

            grupo.MapDelete("/{id}", async (long id, ISerieComprobanteRepositorio repo) =>
            {
                var serie = await repo.ObtenerPorIdAsync(id);
                if (serie == null) return Results.NotFound(new ToReturnError<object>("Serie no encontrada", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}

