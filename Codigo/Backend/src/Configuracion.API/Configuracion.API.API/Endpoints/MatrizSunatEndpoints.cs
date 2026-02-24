using Configuracion.API.Domain.Entidades;
using Configuracion.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System;
using System.Threading.Tasks;

// DTO para Matriz Regla SUNAT
public class MatrizReglaSunatDto
{
    public long IdTipoOperacion { get; set; }
    public long IdTipoComprobante { get; set; }
    public int NivelObligatoriedad { get; set; }
    public bool Activo { get; set; } = true;
}

namespace Configuracion.API.Endpoints
{
    public static class MatrizSunatEndpoints
    {
        public static void MapMatrizSunatEndpoints(this IEndpointRouteBuilder routes)
        {
            var group = routes.MapGroup("/api/configuracion/matriz-sunat").WithTags("Matriz SUNAT");

            // 1. Obtener toda la matriz
            group.MapGet("/", async (IMatrizReglaSunatRepositorio repo) =>
            {
                var matriz = await repo.ObtenerTodasAsync();
                return Results.Ok(new ToReturnList<MatrizReglaSunat>(matriz));
            });

            // 2. Obtener reglas por código de operación SUNAT
            group.MapGet("/operacion/{codigo}", async (string codigo, IMatrizReglaSunatRepositorio repo) =>
            {
                var reglas = await repo.ObtenerPorOperacionAsync(codigo);
                return Results.Ok(new ToReturnList<MatrizReglaSunat>(reglas));
            });

            // 3. Obtener una regla por ID
            group.MapGet("/{id:long}", async (long id, IMatrizReglaSunatRepositorio repo) =>
            {
                var regla = await repo.ObtenerPorIdAsync(id);
                if (regla == null) return Results.NotFound(new ToReturnError<object>("Regla no encontrada", 404));
                return Results.Ok(new ToReturn<MatrizReglaSunat>(regla));
            });

            // 4. Crear o actualizar regla (Upsert)
            group.MapPost("/", async (MatrizReglaSunatDto dto, IMatrizReglaSunatRepositorio repo) =>
            {
                var regla = new MatrizReglaSunat
                {
                    IdTipoOperacion = dto.IdTipoOperacion,
                    IdTipoComprobante = dto.IdTipoComprobante,
                    NivelObligatoriedad = dto.NivelObligatoriedad,
                    Activo = dto.Activo,
                    UsuarioCreacion = "SISTEMA",
                    FechaCreacion = DateTime.UtcNow
                };
                var creada = await repo.AgregarAsync(regla);
                return Results.Created($"/api/configuracion/matriz-sunat/{creada.Id}", new ToReturn<MatrizReglaSunat>(creada));
            });

            // 5. Actualizar regla
            group.MapPut("/{id:long}", async (long id, MatrizReglaSunatDto dto, IMatrizReglaSunatRepositorio repo) =>
            {
                var regla = await repo.ObtenerPorIdAsync(id);
                if (regla == null) return Results.NotFound(new ToReturnError<object>("Regla no encontrada", 404));

                regla.IdTipoOperacion = dto.IdTipoOperacion;
                regla.IdTipoComprobante = dto.IdTipoComprobante;
                regla.NivelObligatoriedad = dto.NivelObligatoriedad;
                regla.Activo = dto.Activo;
                regla.UsuarioActualizacion = "SISTEMA";
                regla.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(regla);
                return Results.Ok(new ToReturn<MatrizReglaSunat>(regla));
            });

            // 6. Eliminar regla
            group.MapDelete("/{id:long}", async (long id, IMatrizReglaSunatRepositorio repo) =>
            {
                var regla = await repo.ObtenerPorIdAsync(id);
                if (regla == null) return Results.NotFound(new ToReturnError<object>("Regla no encontrada", 404));
                await repo.EliminarAsync(id);
                return Results.NoContent();
            });

            // 7. Inicializar (mantenido por compatibilidad)
            group.MapPost("/inicializar", () =>
                Results.Ok(new { message = "Use el script 10_Poblar_Matriz_SUNAT.sql para inicializar" }));
        }
    }
}
