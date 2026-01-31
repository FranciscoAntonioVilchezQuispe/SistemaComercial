using Clientes.API.Domain.Entidades;
using Clientes.API.Domain.Interfaces;
using Clientes.API.Application.DTOs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Clientes.API.Endpoints
{
    public static class ContactoClienteEndpoints
    {
        public static void MapContactoClienteEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/contactos-cliente").WithTags("Contactos de Cliente");

            grupo.MapGet("/cliente/{idCliente}", async (long idCliente, IContactoClienteRepositorio repo) =>
            {
                var contactos = await repo.ObtenerPorClienteAsync(idCliente);
                return Results.Ok(new ToReturnList<ContactoCliente>(contactos));
            });

            grupo.MapPost("/", async (CrearContactoClienteDto dto, IContactoClienteRepositorio repo) =>
            {
                var contacto = new ContactoCliente
                {
                    IdCliente = dto.IdCliente,
                    Nombres = dto.Nombres,
                    Cargo = dto.Cargo,
                    Telefono = dto.Telefono,
                    Email = dto.Email,
                    EsPrincipal = dto.EsPrincipal,
                    UsuarioCreacion = "SISTEMA"
                };
                var creado = await repo.AgregarAsync(contacto);
                return Results.Created($"/api/contactos-cliente/{creado.Id}", new ToReturn<ContactoCliente>(creado));
            });

            grupo.MapDelete("/{id}", async (long id, IContactoClienteRepositorio repo) =>
            {
                await repo.EliminarAsync(id);
                return Results.Ok(new ToReturn<bool>(true));
            });
        }
    }
}
