using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using Clientes.API.Domain.DTOs;

namespace Clientes.API.Endpoints
{
    public static class ClienteEndpoints
    {
        public static void MapClienteEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/clientes").WithTags("Clientes");

            grupo.MapGet("/", async (IClienteRepositorio repo, [AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<ClienteListDto>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, IClienteRepositorio repo) =>
            {
                var cliente = await repo.ObtenerDetallePorIdAsync(id);
                if (cliente == null) return Results.NotFound(new ToReturnError<ClienteDetalleDto>("Cliente no encontrado", 404));
                return Results.Ok(new ToReturn<ClienteDetalleDto>(cliente));
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
                existente.Ubigeo = dto.Ubigeo;
                existente.CondicionSunat = dto.CondicionSunat;
                existente.EstadoSunat = dto.EstadoSunat;
                existente.EsAgenteRetencion = dto.EsAgenteRetencion;
                existente.EsBuenContribuyente = dto.EsBuenContribuyente;
                existente.EsAgentePercepcion = dto.EsAgentePercepcion;
                existente.FechaUltimaConsultaSunat = dto.FechaUltimaConsultaSunat;

                if (dto.Activado.HasValue) existente.Activado = dto.Activado.Value;
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
