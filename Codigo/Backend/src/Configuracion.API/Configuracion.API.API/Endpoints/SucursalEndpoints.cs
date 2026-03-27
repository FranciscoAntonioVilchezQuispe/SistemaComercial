using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Configuracion.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class SucursalEndpoints
    {
        public static void MapSucursalEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/sucursales").WithTags("Sucursales");

            grupo.MapGet("/", async (ISucursalRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<Sucursal>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, ISucursalRepositorio repo) =>
            {
                var sucursal = await repo.ObtenerPorIdAsync(id);
                if (sucursal == null) return Results.NotFound(new ToReturnError<object>("Sucursal no encontrada", 404));
                return Results.Ok(new ToReturn<Sucursal>(sucursal));
            });

            grupo.MapPost("/", async (SucursalDto dto, ISucursalRepositorio repo) =>
            {
                var sucursal = new Sucursal
                {
                    IdEmpresa = dto.IdEmpresa,
                    NombreSucursal = dto.NombreSucursal,
                    Direccion = dto.Direccion,
                    Telefono = dto.Telefono,
                    EsPrincipal = dto.EsPrincipal,
                    UsuarioCreacion = "SISTEMA",
                    Activado = dto.Activado
                };
                var creado = await repo.AgregarAsync(sucursal);
                return Results.Created($"/api/sucursales/{creado.Id}", new ToReturn<Sucursal>(creado));
            });

            grupo.MapPut("/{id}", async (long id, SucursalDto dto, ISucursalRepositorio repo) =>
            {
                var sucursal = await repo.ObtenerPorIdAsync(id);
                if (sucursal == null) return Results.NotFound(new ToReturnError<object>("Sucursal no encontrada", 404));

                sucursal.IdEmpresa = dto.IdEmpresa;
                sucursal.NombreSucursal = dto.NombreSucursal;
                sucursal.Direccion = dto.Direccion;
                sucursal.Telefono = dto.Telefono;
                sucursal.EsPrincipal = dto.EsPrincipal;
                sucursal.Activado = dto.Activado;
                sucursal.UsuarioActualizacion = "SISTEMA";
                sucursal.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(sucursal);
                return Results.Ok(new ToReturn<Sucursal>(sucursal));
            });

            grupo.MapDelete("/{id}", async (long id, ISucursalRepositorio repo) =>
            {
                var sucursal = await repo.ObtenerPorIdAsync(id);
                if (sucursal == null) return Results.NotFound(new ToReturnError<object>("Sucursal no encontrada", 404));

                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }
}
