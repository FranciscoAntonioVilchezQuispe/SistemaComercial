using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Clientes.API.Endpoints
{
    public static class ClienteEndpoints
    {
        public static void MapClienteEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/clientes").WithTags("Clientes");

            grupo.MapGet("/", async (string? busqueda, IClienteRepositorio repo) =>
            {
                var clientes = await repo.ObtenerTodosAsync(busqueda);
                return Results.Ok(new ToReturnList<Cliente>(clientes));
            });

            grupo.MapGet("/{id}", async (long id, IClienteRepositorio repo) =>
            {
                var cliente = await repo.ObtenerPorIdAsync(id);
                if (cliente == null) return Results.NotFound(new ToReturnError<Cliente>("Cliente no encontrado", 404));
                return Results.Ok(new ToReturn<Cliente>(cliente));
            });

            grupo.MapPost("/", async (CrearClienteDto dto, IClienteRepositorio repo) =>
            {
                var cliente = new Cliente
                {
                    IdTipoDocumento = dto.IdTipoDocumento,
                    NumeroDocumento = dto.NumeroDocumento,
                    RazonSocial = dto.RazonSocial,
                    NombreComercial = dto.NombreComercial,
                    Direccion = dto.Direccion,
                    Telefono = dto.Telefono,
                    Email = dto.Email,
                    IdTipoCliente = dto.IdTipoCliente,
                    LimiteCredito = dto.LimiteCredito,
                    DiasCredito = dto.DiasCredito,
                    IdListaPrecioAsignada = dto.IdListaPrecioAsignada,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(cliente);
                return Results.Created($"/api/clientes/{creado.Id}", new ToReturn<Cliente>(creado));
            });

            grupo.MapPut("/{id}", async (long id, CrearClienteDto dto, IClienteRepositorio repo) =>
            {
                var existente = await repo.ObtenerPorIdAsync(id);
                if (existente == null) return Results.NotFound(new ToReturnError<Cliente>("Cliente no encontrado", 404));

                existente.IdTipoDocumento = dto.IdTipoDocumento;
                existente.NumeroDocumento = dto.NumeroDocumento;
                existente.RazonSocial = dto.RazonSocial;
                existente.NombreComercial = dto.NombreComercial;
                existente.Direccion = dto.Direccion;
                existente.Telefono = dto.Telefono;
                existente.Email = dto.Email;
                existente.IdTipoCliente = dto.IdTipoCliente;
                existente.LimiteCredito = dto.LimiteCredito;
                existente.DiasCredito = dto.DiasCredito;
                existente.IdListaPrecioAsignada = dto.IdListaPrecioAsignada;
                existente.UsuarioActualizacion = "SISTEMA";
                existente.FechaActualizacion = DateTime.UtcNow;

                await repo.ActualizarAsync(existente);
                return Results.Ok(new ToReturn<Cliente>(existente));
            });

            grupo.MapDelete("/{id}", async (long id, IClienteRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
