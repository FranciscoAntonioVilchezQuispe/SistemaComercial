using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System;
using System.Threading.Tasks;

// DTO para Tipo Operación SUNAT
public class TipoOperacionSunatDto
{
    public string Codigo { get; set; } = null!;
    public string Nombre { get; set; } = null!;
    public bool Activo { get; set; } = true;
}

namespace Configuracion.API.Endpoints
{
    public static class TipoOperacionSunatEndpoints
    {
        public static void MapTipoOperacionSunatEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/operaciones-sunat").WithTags("Operaciones SUNAT");

            grupo.MapGet("/", async (ITipoOperacionSunatRepositorio repo) =>
            {
                var operaciones = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<TipoOperacionSunat>(operaciones));
            });

            grupo.MapGet("/{id:long}", async (long id, ITipoOperacionSunatRepositorio repo) =>
            {
                var operacion = await repo.ObtenerPorIdAsync(id);
                if (operacion == null) return Results.NotFound(new ToReturnError<object>("Operación no encontrada", 404));
                return Results.Ok(new ToReturn<TipoOperacionSunat>(operacion));
            });

            grupo.MapPost("/", async (TipoOperacionSunatDto dto, ITipoOperacionSunatRepositorio repo) =>
            {
                var operacion = new TipoOperacionSunat
                {
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    Activo = dto.Activo,
                    UsuarioCreacion = "SISTEMA",
                    FechaCreacion = DateTime.UtcNow
                };
                var creada = await repo.AgregarAsync(operacion);
                return Results.Created($"/api/operaciones-sunat/{creada.Id}", new ToReturn<TipoOperacionSunat>(creada));
            });

            grupo.MapPut("/{id:long}", async (long id, TipoOperacionSunatDto dto, ITipoOperacionSunatRepositorio repo) =>
            {
                var operacion = await repo.ObtenerPorIdAsync(id);
                if (operacion == null) return Results.NotFound(new ToReturnError<object>("Operación no encontrada", 404));

                operacion.Codigo = dto.Codigo;
                operacion.Nombre = dto.Nombre;
                operacion.Activo = dto.Activo;
                operacion.UsuarioActualizacion = "SISTEMA";
                operacion.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(operacion);
                return Results.Ok(new ToReturn<TipoOperacionSunat>(operacion));
            });

            grupo.MapDelete("/{id:long}", async (long id, ITipoOperacionSunatRepositorio repo) =>
            {
                var operacion = await repo.ObtenerPorIdAsync(id);
                if (operacion == null) return Results.NotFound(new ToReturnError<object>("Operación no encontrada", 404));
                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}
