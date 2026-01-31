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

            grupo.MapGet("/", async (IProveedorRepositorio repo) =>
            {
                var proveedores = await repo.ObtenerTodosAsync();
                return Results.Ok(new ToReturnList<Proveedor>(proveedores));
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
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

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
