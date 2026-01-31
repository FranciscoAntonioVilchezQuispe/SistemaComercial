using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Identidad.API.Endpoints
{
    public static class UsuarioEndpoints
    {
        public static void MapUsuarioEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/usuarios").WithTags("Usuarios");

            grupo.MapGet("/", async (IUsuarioRepositorio repo) =>
            {
                var usuarios = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Usuario>(usuarios));
            });

            grupo.MapGet("/{id}", async (long id, IUsuarioRepositorio repo) =>
            {
                var usuario = await repo.ObtenerPorIdAsync(id);
                if (usuario == null) return Results.NotFound(new ToReturnError<Usuario>("Usuario no encontrado", 404));
                return Results.Ok(new ToReturn<Usuario>(usuario));
            });

            grupo.MapGet("/username/{username}", async (string username, IUsuarioRepositorio repo) =>
            {
                var usuario = await repo.ObtenerPorUsernameAsync(username);
                if (usuario == null) return Results.NotFound(new ToReturnError<Usuario>("Usuario no encontrado", 404));
                return Results.Ok(new ToReturn<Usuario>(usuario));
            });
        }
    }

    public static class RolEndpoints
    {
        public static void MapRolEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/roles").WithTags("Roles");

            grupo.MapGet("/", async (IRolRepositorio repo) =>
            {
                var roles = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Rol>(roles));
            });

            grupo.MapGet("/{id}", async (long id, IRolRepositorio repo) =>
            {
                var rol = await repo.ObtenerPorIdAsync(id);
                if (rol == null) return Results.NotFound(new ToReturnError<Rol>("Rol no encontrado", 404));
                return Results.Ok(new ToReturn<Rol>(rol));
            });
        }
    }

    public static class PermisoEndpoints
    {
        public static void MapPermisoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/permisos").WithTags("Permisos");

            grupo.MapGet("/", async (IPermisoRepositorio repo) =>
            {
                var permisos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Permiso>(permisos));
            });
        }
    }
}
