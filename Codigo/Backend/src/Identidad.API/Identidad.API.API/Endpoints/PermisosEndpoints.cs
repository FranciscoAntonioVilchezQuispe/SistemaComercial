using Identidad.API.Domain.Entidades;
using Identidad.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;

namespace Identidad.API.Endpoints
{
    public static class MenuEndpoints
    {
        public static void MapMenuEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/menus").WithTags("Menús");

            grupo.MapGet("/", async (IMenuRepositorio repo) =>
            {
                var menus = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Menu>(menus));
            });

            grupo.MapGet("/jerarquicos", async (IMenuRepositorio repo) =>
            {
                var menus = await repo.ObtenerMenusJerarquicosAsync();
                return Results.Ok(new ToReturnList<Menu>(menus));
            });

            grupo.MapGet("/{id}", async (long id, IMenuRepositorio repo) =>
            {
                var menu = await repo.ObtenerPorIdAsync(id);
                if (menu == null) return Results.NotFound(new ToReturnError<Menu>("Menú no encontrado", 404));
                return Results.Ok(new ToReturn<Menu>(menu));
            });

            grupo.MapPost("/", async (Menu menu, IMenuRepositorio repo) =>
            {
                var nuevoMenu = await repo.AgregarAsync(menu);
                return Results.Created($"/api/menus/{nuevoMenu.Id}", new ToReturn<Menu>(nuevoMenu));
            });

            grupo.MapPut("/{id}", async (long id, Menu menu, IMenuRepositorio repo) =>
            {
                if (id != menu.Id) return Results.BadRequest(new ToReturnError<Menu>("ID no coincide", 400));
                await repo.ActualizarAsync(menu);
                return Results.Ok(new ToReturn<Menu>(menu));
            });

            grupo.MapDelete("/{id}", async (long id, IMenuRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.NoContent();
            });
        }
    }

    public static class TipoPermisoEndpoints
    {
        public static void MapTipoPermisoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/tipos-permiso").WithTags("Tipos de Permiso");

            grupo.MapGet("/", async (ITipoPermisoRepositorio repo) =>
            {
                var tipos = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<TipoPermiso>(tipos));
            });

            grupo.MapGet("/{id}", async (long id, ITipoPermisoRepositorio repo) =>
            {
                var tipo = await repo.ObtenerPorIdAsync(id);
                if (tipo == null) return Results.NotFound(new ToReturnError<TipoPermiso>("Tipo de permiso no encontrado", 404));
                return Results.Ok(new ToReturn<TipoPermiso>(tipo));
            });

            grupo.MapPost("/", async (TipoPermiso tipoPermiso, ITipoPermisoRepositorio repo) =>
            {
                var nuevoTipo = await repo.AgregarAsync(tipoPermiso);
                return Results.Created($"/api/tipos-permiso/{nuevoTipo.Id}", new ToReturn<TipoPermiso>(nuevoTipo));
            });
        }
    }

    public static class RolMenuEndpoints
    {
        public static void MapRolMenuEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/roles/{idRol}/menus").WithTags("Roles - Menús");

            // Obtener menús asignados a un rol
            grupo.MapGet("/", async (long idRol, IRolMenuRepositorio repo) =>
            {
                var rolesMenus = await repo.ObtenerPorRolAsync(idRol);
                return Results.Ok(new ToReturnList<RolMenu>(rolesMenus));
            });

            // Asignar menú a rol
            grupo.MapPost("/", async (long idRol, RolMenu rolMenu, IRolMenuRepositorio repo) =>
            {
                if (idRol != rolMenu.IdRol) return Results.BadRequest(new ToReturnError<RolMenu>("ID de rol no coincide", 400));
                var nuevoRolMenu = await repo.AgregarAsync(rolMenu);
                return Results.Created($"/api/roles/{idRol}/menus/{nuevoRolMenu.Id}", new ToReturn<RolMenu>(nuevoRolMenu));
            });

            // Quitar menú de rol
            grupo.MapDelete("/{idRolMenu}", async (long idRol, long idRolMenu, IRolMenuRepositorio repo) =>
            {
                await repo.EliminarAsync(idRolMenu);
                return Results.NoContent();
            });

            // Obtener permisos de un rol-menú
            grupo.MapGet("/{idMenu}/permisos", async (long idRol, long idMenu, IRolMenuPermisoRepositorio repo) =>
            {
                var permisos = await repo.ObtenerPermisosPorRolYMenuAsync(idRol, idMenu);
                return Results.Ok(new ToReturnList<RolMenuPermiso>(permisos));
            });

            // Asignar permiso a rol-menú
            grupo.MapPost("/{idMenu}/permisos", async (long idRol, long idMenu, RolMenuPermiso permiso, 
                IRolMenuRepositorio rolMenuRepo, IRolMenuPermisoRepositorio permisoRepo) =>
            {
                // Buscar o crear RolMenu
                var rolMenu = await rolMenuRepo.ObtenerPorRolYMenuAsync(idRol, idMenu);
                if (rolMenu == null)
                {
                    rolMenu = await rolMenuRepo.AgregarAsync(new RolMenu { IdRol = idRol, IdMenu = idMenu });
                }

                permiso.IdRolMenu = rolMenu.Id;
                var nuevoPermiso = await permisoRepo.AgregarAsync(permiso);
                return Results.Created($"/api/roles/{idRol}/menus/{idMenu}/permisos/{nuevoPermiso.Id}", 
                    new ToReturn<RolMenuPermiso>(nuevoPermiso));
            });
        }
    }

    public static class UsuarioPermisoEndpoints
    {
        public static void MapUsuarioPermisoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupoUsuarios = app.MapGroup("/api/usuarios/{idUsuario}").WithTags("Usuarios - Permisos");

            // Obtener menús disponibles para el usuario
            grupoUsuarios.MapGet("/menus", async (long idUsuario, IUsuarioRolRepositorio usuarioRolRepo, 
                IMenuRepositorio menuRepo) =>
            {
                var usuarioRoles = await usuarioRolRepo.ObtenerPorUsuarioAsync(idUsuario);
                var idsRoles = usuarioRoles.Select(ur => ur.IdRol).ToList();
                
                var menusDisponibles = new List<Menu>();
                foreach (var idRol in idsRoles)
                {
                    var menus = await menuRepo.ObtenerMenusPorRolAsync(idRol);
                    menusDisponibles.AddRange(menus);
                }
                
                var menusUnicos = menusDisponibles.DistinctBy(m => m.Id).ToList();
                return Results.Ok(new ToReturnList<Menu>(menusUnicos));
            });

            // Verificar si usuario tiene permiso específico
            grupoUsuarios.MapGet("/permisos/{codigoMenu}/{codigoPermiso}", async (long idUsuario, 
                string codigoMenu, string codigoPermiso, IRolMenuPermisoRepositorio repo) =>
            {
                var tienePermiso = await repo.UsuarioTienePermisoAsync(idUsuario, codigoMenu, codigoPermiso);
                return Results.Ok(new { TienePermiso = tienePermiso });
            });

            // Asignar rol a usuario
            grupoUsuarios.MapPost("/roles", async (long idUsuario, UsuarioRol usuarioRol, 
                IUsuarioRolRepositorio repo) =>
            {
                if (idUsuario != usuarioRol.IdUsuario) 
                    return Results.BadRequest(new ToReturnError<UsuarioRol>("ID de usuario no coincide", 400));
                
                var nuevoUsuarioRol = await repo.AgregarAsync(usuarioRol);
                return Results.Created($"/api/usuarios/{idUsuario}/roles/{nuevoUsuarioRol.Id}", 
                    new ToReturn<UsuarioRol>(nuevoUsuarioRol));
            });

            // Quitar rol de usuario
            grupoUsuarios.MapDelete("/roles/{idUsuarioRol}", async (long idUsuario, long idUsuarioRol, 
                IUsuarioRolRepositorio repo) =>
            {
                await repo.EliminarAsync(idUsuarioRol);
                return Results.NoContent();
            });

            // Obtener roles del usuario
            grupoUsuarios.MapGet("/roles", async (long idUsuario, IUsuarioRolRepositorio repo) =>
            {
                var usuarioRoles = await repo.ObtenerPorUsuarioAsync(idUsuario);
                return Results.Ok(new ToReturnList<UsuarioRol>(usuarioRoles));
            });
        }
    }
}
