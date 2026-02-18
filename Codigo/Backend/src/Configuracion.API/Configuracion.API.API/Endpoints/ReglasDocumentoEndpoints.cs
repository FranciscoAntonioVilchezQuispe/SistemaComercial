using Configuracion.API.Application.Interfaces;
using Configuracion.API.Domain.Entidades;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using Configuracion.API.Infrastructure.Servicios;
using Configuracion.API.Application.DTOs;
using System.Collections.Generic;


using System.Threading.Tasks;

namespace Configuracion.API.Endpoints
{
    public static class ReglasDocumentoEndpoints
    {
        public static void MapReglasDocumentoEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/reglasdocumentos").WithTags("ReglasDocumentos");

            group.MapGet("/", async (IReglasDocumentoServicio servicio) =>
            {
                var resultado = await servicio.ObtenerReglasYRelacionesAsync();
                return Results.Ok(new ToReturn<ReglasYRelacionesResponse>(resultado));
            })

            .WithName("ObtenerReglasYRelaciones");

            group.MapGet("/reglas", async (IReglasDocumentoServicio servicio) =>
            {
                var reglas = await servicio.ListarReglasAsync();
                return Results.Ok(new ToReturnList<DocumentoIdentidadRegla>(reglas));
            })
            .WithName("ListarReglas");

            group.MapPost("/reglas", async (DocumentoIdentidadRegla regla, IReglasDocumentoServicio servicio) =>
            {
                var nuevaRegla = await servicio.GuardarReglaAsync(regla);
                return Results.Created($"/api/reglasdocumentos/reglas/{nuevaRegla.Id}", new ToReturn<DocumentoIdentidadRegla>(nuevaRegla));
            })
            .WithName("CrearRegla");

            group.MapPut("/reglas/{id}", async (long id, DocumentoIdentidadRegla regla, IReglasDocumentoServicio servicio) =>
            {
                if (id != regla.Id) return Results.BadRequest(new ToReturnError<string>("El ID no coincide"));
                var actualizado = await servicio.GuardarReglaAsync(regla);
                return Results.Ok(new ToReturn<DocumentoIdentidadRegla>(actualizado));
            })
            .WithName("ActualizarRegla");

            group.MapDelete("/reglas/{id}", async (long id, IReglasDocumentoServicio servicio) =>
            {
                var eliminado = await servicio.EliminarReglaAsync(id);
                return eliminado ? Results.NoContent() : Results.NotFound(new ToReturnNoEncontrado<string>("Regla no encontrada"));
            })
            .WithName("EliminarRegla");

            group.MapPost("/relaciones/{codigoDocumento}", async (string codigoDocumento, List<long> idsTiposComprobante, IReglasDocumentoServicio servicio) =>
            {
                await servicio.ActualizarRelacionesAsync(codigoDocumento, idsTiposComprobante);
                return Results.Ok(new ToReturn<string>("Relaciones actualizadas con éxito"));
            })
            .WithName("ActualizarRelaciones");

            group.MapGet("/relaciones/{codigoDocumento}", async (string codigoDocumento, IReglasDocumentoServicio servicio) =>
            {
                var relaciones = await servicio.ListarRelacionesPorDocumentoAsync(codigoDocumento);
                return Results.Ok(new ToReturnList<DocumentoComprobanteRelacion>(relaciones));
            })
            .WithName("ListarRelacionesPorDocumento");

            group.MapGet("/comprobantes/{codigoDocumento}", async (string codigoDocumento, IReglasDocumentoServicio servicio) =>
            {
                var comprobantes = await servicio.ListarComprobantesPorDocumentoAsync(codigoDocumento);
                return Results.Ok(new ToReturnList<TipoComprobante>(comprobantes));
            })
            .WithName("ListarComprobantesPorDocumento");
        }
    }
}
