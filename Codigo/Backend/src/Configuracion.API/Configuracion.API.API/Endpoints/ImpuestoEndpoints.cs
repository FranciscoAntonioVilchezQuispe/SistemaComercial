using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class ImpuestoEndpoints
    {
        public static void MapImpuestoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/impuestos").WithTags("Impuestos");

            grupo.MapGet("/", async (IImpuestoRepositorio repo) =>
            {
                var impuestos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Impuesto>(impuestos));
            });

            grupo.MapGet("/{id}", async (long id, IImpuestoRepositorio repo) =>
            {
                var impuesto = await repo.ObtenerPorIdAsync(id);
                if (impuesto == null) return Results.NotFound(new ToReturnError<object>("Impuesto no encontrado", 404));
                return Results.Ok(new ToReturn<Impuesto>(impuesto));
            });

            grupo.MapPost("/", async (ImpuestoDto dto, IImpuestoRepositorio repo) =>
            {
                var impuesto = new Impuesto
                {
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    Porcentaje = dto.Porcentaje,
                    EsIgv = dto.EsIgv,
                    UsuarioCreacion = "SISTEMA",
                    Activado = true
                };
                var creado = await repo.AgregarAsync(impuesto);
                return Results.Created($"/api/impuestos/{creado.Id}", new ToReturn<Impuesto>(creado));
            });

            grupo.MapPut("/{id}", async (long id, ImpuestoDto dto, IImpuestoRepositorio repo) =>
            {
                var impuesto = await repo.ObtenerPorIdAsync(id);
                if (impuesto == null) return Results.NotFound(new ToReturnError<object>("Impuesto no encontrado", 404));

                impuesto.Codigo = dto.Codigo;
                impuesto.Nombre = dto.Nombre;
                impuesto.Porcentaje = dto.Porcentaje;
                impuesto.EsIgv = dto.EsIgv;
                impuesto.UsuarioActualizacion = "SISTEMA";
                impuesto.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(impuesto);
                return Results.Ok(new ToReturn<Impuesto>(impuesto));
            });

            grupo.MapDelete("/{id}", async (long id, IImpuestoRepositorio repo) =>
            {
                var impuesto = await repo.ObtenerPorIdAsync(id);
                if (impuesto == null) return Results.NotFound(new ToReturnError<object>("Impuesto no encontrado", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}
