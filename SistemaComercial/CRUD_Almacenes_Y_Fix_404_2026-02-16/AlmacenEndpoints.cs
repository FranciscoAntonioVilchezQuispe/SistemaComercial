using Inventario.API.Domain.Entidades;
using Inventario.API.Domain.Interfaces;
using Inventario.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Inventario.API.Endpoints
{
    public static class AlmacenEndpoints
    {
        public static void MapAlmacenEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/inventario/almacenes").WithTags("Almacenes");

            grupo.MapGet("/", async (IAlmacenRepositorio repo) =>
            {
                try
                {
                    var almacenes = await repo.ObtenerTodosAsync();
                    return Results.Ok(new ToReturnList<Almacen>(almacenes));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });

            grupo.MapGet("/{id}", async (long id, IAlmacenRepositorio repo) =>
            {
                try
                {
                    var almacen = await repo.ObtenerPorIdAsync(id);
                    if (almacen == null) return Results.NotFound(new ToReturnNoEncontrado<Almacen>());
                    return Results.Ok(new ToReturn<Almacen>(almacen));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });

            grupo.MapPost("/", async (AlmacenDto dto, IAlmacenRepositorio repo) =>
            {
                try
                {
                    var almacen = new Almacen
                    {
                        NombreAlmacen = dto.NombreAlmacen,
                        Direccion = dto.Direccion,
                        IdSucursal = dto.IdSucursal,
                        EsPrincipal = dto.EsPrincipal,
                        Activado = true,
                        UsuarioCreacion = "SISTEMA"
                    };
                    var creado = await repo.AgregarAsync(almacen);
                    return Results.Created($"/api/inventario/almacenes/{creado.Id}", new ToReturn<Almacen>(creado));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });

            grupo.MapPut("/{id}", async (long id, AlmacenDto dto, IAlmacenRepositorio repo) =>
            {
                try
                {
                    var existencial = await repo.ObtenerPorIdAsync(id);
                    if (existencial == null) return Results.NotFound(new ToReturnNoEncontrado<Almacen>());

                    existencial.NombreAlmacen = dto.NombreAlmacen;
                    existencial.Direccion = dto.Direccion;
                    existencial.IdSucursal = dto.IdSucursal;
                    existencial.EsPrincipal = dto.EsPrincipal;
                    existencial.Activado = dto.Activado;
                    existencial.FechaActualizacion = DateTime.UtcNow;
                    existencial.UsuarioActualizacion = "SISTEMA";

                    await repo.ActualizarAsync(existencial);
                    return Results.Ok(new ToReturn<Almacen>(existencial));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });

            grupo.MapPatch("/{id}/estado", async (long id, IAlmacenRepositorio repo) =>
            {
                try
                {
                    var existencial = await repo.ObtenerPorIdAsync(id);
                    if (existencial == null) return Results.NotFound(new ToReturnNoEncontrado<Almacen>());

                    existencial.Activado = !existencial.Activado;
                    existencial.FechaActualizacion = DateTime.UtcNow;
                    existencial.UsuarioActualizacion = "SISTEMA";

                    await repo.ActualizarAsync(existencial);
                    return Results.Ok(new ToReturn<Almacen>(existencial));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });

            grupo.MapDelete("/{id}", async (long id, IAlmacenRepositorio repo) =>
            {
                try
                {
                    var existencial = await repo.ObtenerPorIdAsync(id);
                    if (existencial == null) return Results.NotFound(new ToReturnNoEncontrado<Almacen>());

                    // Por consistencia con el sistema, podríamos hacer soft delete o hard delete. 
                    // El repositorio actual no tiene un método de eliminación física, así que desactivaremos.
                    existencial.Activado = false;
                    existencial.FechaActualizacion = DateTime.UtcNow;
                    existencial.UsuarioActualizacion = "SISTEMA";

                    await repo.ActualizarAsync(existencial);
                    return Results.Ok(new ToReturn<Almacen>(existencial));
                }
                catch (Exception ex)
                {
                    return Results.Problem(ex.Message);
                }
            });
        }

    }
}
