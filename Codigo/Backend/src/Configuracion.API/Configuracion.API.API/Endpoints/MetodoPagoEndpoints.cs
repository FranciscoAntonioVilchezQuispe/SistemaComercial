using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class MetodoPagoEndpoints
    {
        public static void MapMetodoPagoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/metodos-pago").WithTags("Metodos de Pago");

            grupo.MapGet("/", async (IMetodoPagoRepositorio repo) =>
            {
                var metodos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<MetodoPago>(metodos));
            });

            grupo.MapGet("/{id}", async (long id, IMetodoPagoRepositorio repo) =>
            {
                var metodo = await repo.ObtenerPorIdAsync(id);
                if (metodo == null) return Results.NotFound(new ToReturnError<object>("Método de pago no encontrado", 404));
                return Results.Ok(new ToReturn<MetodoPago>(metodo));
            });

            grupo.MapPost("/", async (MetodoPagoDto dto, IMetodoPagoRepositorio repo) =>
            {
                var metodo = new MetodoPago
                {
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    EsEfectivo = dto.EsEfectivo,
                    IdTipoDocumentoPago = dto.IdTipoDocumentoPago,
                    UsuarioCreacion = "SISTEMA",
                    Activado = true
                };
                var creado = await repo.AgregarAsync(metodo);
                return Results.Created($"/api/metodos-pago/{creado.Id}", new ToReturn<MetodoPago>(creado));
            });

            grupo.MapPut("/{id}", async (long id, MetodoPagoDto dto, IMetodoPagoRepositorio repo) =>
            {
                var metodo = await repo.ObtenerPorIdAsync(id);
                if (metodo == null) return Results.NotFound(new ToReturnError<object>("Método de pago no encontrado", 404));

                metodo.Codigo = dto.Codigo;
                metodo.Nombre = dto.Nombre;
                metodo.EsEfectivo = dto.EsEfectivo;
                metodo.IdTipoDocumentoPago = dto.IdTipoDocumentoPago;
                metodo.UsuarioActualizacion = "SISTEMA";
                metodo.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(metodo);
                return Results.Ok(new ToReturn<MetodoPago>(metodo));
            });

            grupo.MapDelete("/{id}", async (long id, IMetodoPagoRepositorio repo) =>
            {
                var metodo = await repo.ObtenerPorIdAsync(id);
                if (metodo == null) return Results.NotFound(new ToReturnError<object>("Método de pago no encontrado", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}
