using Configuracion.API.Application.Consultas;
using Configuracion.API.Application.DTOs;
using Configuracion.API.Application.Manejadores;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class TablaGeneralEndpoints
    {
        public static void MapTablaGeneralEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/catalogos").WithTags("Catalogos");

            // GET /api/catalogos
            grupo.MapGet("/", async (ObtenerTodosCatalogosManejador manejador) =>
            {
                var consulta = new ObtenerTodosCatalogosConsulta();
                var respuesta = await manejador.Handle(consulta);
                return Results.Ok(new ToReturnList<TablaGeneralDto>(respuesta.Catalogos));
            });

            // GET /api/catalogos/{codigo}
            grupo.MapGet("/{codigo}", async (string codigo, ObtenerCatalogoPorCodigoManejador manejador, [FromQuery] bool incluirInactivos = false) =>
            {
                var consulta = new ObtenerCatalogoPorCodigoConsulta(codigo.ToUpper(), incluirInactivos);
                var respuesta = await manejador.Handle(consulta);

                if (respuesta.Catalogo == null)
                {
                    return Results.NotFound(new ToReturnNoEncontrado<object>($"No se encontró el catálogo con código '{codigo}'"));
                }

                return Results.Ok(new ToReturn<CatalogoCompletoDto>(respuesta.Catalogo));
            });

            // GET /api/catalogos/{codigo}/valores
            grupo.MapGet("/{codigo}/valores", async (string codigo, ObtenerValoresCatalogoManejador manejador, [FromQuery] bool incluirInactivos = false) =>
            {
                var consulta = new ObtenerValoresCatalogoConsulta(codigo.ToUpper(), incluirInactivos);
                var respuesta = await manejador.Handle(consulta);

                return Results.Ok(new ToReturnList<TablaGeneralDetalleDto>(respuesta.Valores));
            });

            // ==========================================
            // MANTENIMIENTO (CRUD)
            // ==========================================
            var adminGrupo = app.MapGroup("/api/tablas-generales").WithTags("TablaGeneral");

            // GET All (Paged or List) - Reusing existing repository method for simplicity
            adminGrupo.MapGet("/", async (Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var lista = await repo.ObtenerTodosAsync();
                var dtos = lista.Select(tg => new TablaGeneralDto
                {
                    IdTabla = tg.Id,
                    Codigo = tg.Codigo,
                    Nombre = tg.Nombre,
                    Descripcion = tg.Descripcion,
                    EsSistema = tg.EsSistema,
                    CantidadValores = tg.Detalles.Count
                }).ToList();
                return Results.Ok(new ToReturnList<TablaGeneralDto>(dtos));
            });

            // GET By Id
            adminGrupo.MapGet("/{id}", async (long id, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var tg = await repo.ObtenerPorIdAsync(id);
                if (tg == null) return Results.NotFound(new ToReturnError<object>("Tabla no encontrada", 404));

                var dto = new TablaGeneralDto
                {
                    IdTabla = tg.Id,
                    Codigo = tg.Codigo,
                    Nombre = tg.Nombre,
                    Descripcion = tg.Descripcion,
                    EsSistema = tg.EsSistema
                };
                return Results.Ok(new ToReturn<TablaGeneralDto>(dto));
            });

            // CREATE Tabla
            adminGrupo.MapPost("/", async (TablaGeneralDto dto, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var entidad = new Configuracion.API.Domain.Entidades.TablaGeneral
                {
                    Codigo = dto.Codigo.ToUpper(),
                    Nombre = dto.Nombre.ToUpper(),
                    Descripcion = dto.Descripcion,
                    EsSistema = dto.EsSistema,
                    Activado = true,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(entidad);
                dto.IdTabla = creado.Id;
                return Results.Created($"/api/tablas-generales/{creado.Id}", new ToReturn<TablaGeneralDto>(dto));
            });

            // UPDATE Tabla
            adminGrupo.MapPut("/{id}", async (long id, TablaGeneralDto dto, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var entidad = await repo.ObtenerPorIdAsync(id);
                if (entidad == null) return Results.NotFound(new ToReturnError<object>("Tabla no encontrada", 404));

                entidad.Codigo = dto.Codigo.ToUpper();
                entidad.Nombre = dto.Nombre.ToUpper();
                entidad.Descripcion = dto.Descripcion;
                entidad.UsuarioActualizacion = "SISTEMA";
                entidad.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(entidad);
                return Results.Ok(new ToReturn<TablaGeneralDto>(dto));
            });

            // DELETE Tabla
            adminGrupo.MapDelete("/{id}", async (long id, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.NoContent();
            });

            // GET Detalles by Tabla Id
            adminGrupo.MapGet("/{id}/detalles", async (long id, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var entidad = await repo.ObtenerPorIdAsync(id);
                if (entidad == null) return Results.NotFound(new ToReturnError<object>("Tabla no encontrada", 404));

                var dtos = entidad.Detalles.Where(d => d.Activado).Select(d => new TablaGeneralDetalleDto
                {
                    IdDetalle = d.Id,
                    IdTabla = d.IdTablaGeneral,
                    Codigo = d.Codigo,
                    Nombre = d.Nombre,
                    Orden = d.Orden,
                    Estado = d.Estado
                }).OrderBy(d => d.Orden).ToList();

                return Results.Ok(new ToReturnList<TablaGeneralDetalleDto>(dtos));
            });

            // CREATE Detalle
            adminGrupo.MapPost("/{id}/detalles", async (long id, TablaGeneralDetalleDto dto, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                /* var tabla = await repo.ObtenerPorIdAsync(id);
                 if (tabla == null) return Results.NotFound("Tabla no encontrada"); // Check optional */

                var entidad = new Configuracion.API.Domain.Entidades.TablaGeneralDetalle
                {
                    IdTablaGeneral = id,
                    Codigo = dto.Codigo,
                    Nombre = dto.Nombre,
                    Orden = dto.Orden,
                    Estado = dto.Estado,
                    Activado = true,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarDetalleAsync(entidad);
                dto.IdDetalle = creado.Id;
                dto.IdTabla = id;
                return Results.Created($"/api/tablas-generales/detalles/{creado.Id}", new ToReturn<TablaGeneralDetalleDto>(dto));
            });

            // UPDATE Detalle
            adminGrupo.MapPut("/detalles/{id}", async (long id, TablaGeneralDetalleDto dto, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                var entidad = await repo.ObtenerValorPorIdAsync(id);
                if (entidad == null) return Results.NotFound(new ToReturnError<object>("Detalle no encontrada", 404));

                entidad.Codigo = dto.Codigo;
                entidad.Nombre = dto.Nombre;
                entidad.Orden = dto.Orden;
                entidad.Estado = dto.Estado;
                entidad.UsuarioActualizacion = "SISTEMA";
                entidad.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarDetalleAsync(entidad);
                return Results.Ok(new ToReturn<TablaGeneralDetalleDto>(dto));
            });

            // DELETE Detalle
            adminGrupo.MapDelete("/detalles/{id}", async (long id, Configuracion.API.Application.Interfaces.ITablaGeneralRepositorio repo) =>
            {
                await repo.EliminarDetalleAsync(id);
                return Results.NoContent();
            });
        }
    }
}
