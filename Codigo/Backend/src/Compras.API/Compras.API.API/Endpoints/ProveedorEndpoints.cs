using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Compras.API.Endpoints
{
    public static class ProveedorEndpoints
    {
        public static void MapProveedorEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/proveedores").WithTags("Proveedores");

            grupo.MapGet("/", async ([AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request, IProveedorRepositorio repo) =>
            {
                var (proveedores, total) = await repo.ObtenerPaginadoAsync(request.Search, request.Activo, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<Proveedor>(proveedores, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, IProveedorRepositorio repo) =>
            {
                var proveedor = await repo.ObtenerPorIdAsync(id);
                if (proveedor == null) return Results.NotFound(new ToReturnError<Proveedor>("Proveedor no encontrado", 404));
                return Results.Ok(new ToReturn<Proveedor>(proveedor));
            });

            grupo.MapPost("/", async (ProveedorDto dto, IProveedorRepositorio repo) =>
            {
                var proveedor = new Proveedor
                {
                    IdTipoDocumento = dto.IdTipoDocumento,
                    NumeroDocumento = dto.NumeroDocumento,
                    RazonSocial = dto.RazonSocial,
                    NombreComercial = dto.NombreComercial,
                    Direccion = dto.Direccion,
                    Telefono = dto.Telefono,
                    Email = dto.Email,
                    PaginaWeb = dto.PaginaWeb,
                    Activado = dto.Activado ?? true,
                    Ubigeo = dto.Ubigeo,
                    CondicionSunat = dto.CondicionSunat,
                    EstadoSunat = dto.EstadoSunat,
                    EsAgenteRetencion = dto.EsAgenteRetencion,
                    EsBuenContribuyente = dto.EsBuenContribuyente,
                    EsAgentePercepcion = dto.EsAgentePercepcion,
                    FechaUltimaConsultaSunat = dto.FechaUltimaConsultaSunat,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(proveedor);
                return Results.Created($"/api/proveedores/{creado.Id}", new ToReturn<Proveedor>(creado));
            });

            grupo.MapPut("/{id}", async (long id, ProveedorDto dto, IProveedorRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<Proveedor>("Proveedor no encontrado", 404));

                existente.IdTipoDocumento = dto.IdTipoDocumento;
                existente.NumeroDocumento = dto.NumeroDocumento;
                existente.RazonSocial = dto.RazonSocial;
                existente.NombreComercial = dto.NombreComercial;
                existente.Direccion = dto.Direccion;
                existente.Telefono = dto.Telefono;
                existente.Email = dto.Email;
                existente.PaginaWeb = dto.PaginaWeb;
                existente.Ubigeo = dto.Ubigeo;
                existente.CondicionSunat = dto.CondicionSunat;
                existente.EstadoSunat = dto.EstadoSunat;
                existente.EsAgenteRetencion = dto.EsAgenteRetencion;
                existente.EsBuenContribuyente = dto.EsBuenContribuyente;
                existente.EsAgentePercepcion = dto.EsAgentePercepcion;
                existente.FechaUltimaConsultaSunat = dto.FechaUltimaConsultaSunat;
                
                if (dto.Activado.HasValue) existente.Activado = dto.Activado.Value;
                existente.UsuarioActualizacion = "SISTEMA";

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<Proveedor>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IProveedorRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
