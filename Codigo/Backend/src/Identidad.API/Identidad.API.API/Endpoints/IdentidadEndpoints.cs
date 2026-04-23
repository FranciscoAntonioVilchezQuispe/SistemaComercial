using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using MediatR;
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

            grupo.MapPost("/", async (Identidad.API.Application.Features.Usuarios.CrearUsuario.CrearUsuarioCommand command, IMediator mediator) =>
            {
                var result = await mediator.Send(command);
                return result.Status == 200 ? Results.Ok(result) : Results.BadRequest(result);
            });
 
            grupo.MapPut("/{id}", async (long id, Identidad.API.Application.Features.Usuarios.ActualizarUsuario.ActualizarUsuarioCommand command, IMediator mediator) =>
            {
                if (id != command.Id) return Results.BadRequest("ID de usuario no coincide.");
                var result = await mediator.Send(command);
                return result.Status == 200 ? Results.Ok(result) : Results.BadRequest(result);
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
 
            grupo.MapPost("/{idRol}/permisos", async (long idRol, Identidad.API.Application.Features.Roles.ActualizarPermisosRol.ActualizarPermisosRolCommand command, IMediator mediator) =>
            {
                if (idRol != command.IdRol) return Results.BadRequest("ID de rol no coincide.");
                var result = await mediator.Send(command);
                return result.Status == 200 ? Results.Ok(result) : Results.BadRequest(result);
            });

            grupo.MapPost("/{idRol}/acceso-granular", async (long idRol, Identidad.API.Application.Features.Roles.ActualizarAccesoRol.ActualizarAccesoRolCommand command, IMediator mediator) =>
            {
                if (idRol != command.IdRol) return Results.BadRequest("ID de rol no coincide.");
                var result = await mediator.Send(command);
                return result.Status == 200 ? Results.Ok(result) : Results.BadRequest(result);
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
