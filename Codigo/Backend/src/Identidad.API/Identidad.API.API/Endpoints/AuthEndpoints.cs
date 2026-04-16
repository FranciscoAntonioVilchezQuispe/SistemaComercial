using Identidad.API.Application.Features.Auth.Login;
using Identidad.API.Application.Features.Auth.Refresh;
using MediatR;
using Nucleo.Comun.Application.Wrappers;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Identidad.API.API.Endpoints
{
    public static class AuthEndpoints
    {
        public static void MapAuthEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/api/auth").WithTags("Autenticación");

            group.MapPost("/login", async ([FromBody] LoginComando comando, [FromServices] IMediator mediator) =>
            {
                var result = await mediator.Send(comando);
                return Results.Json(result, statusCode: result.Status);
            })
            .WithName("Login")
            .Produces<IToReturn<LoginRespuesta>>(StatusCodes.Status200OK, "application/json");

            group.MapPost("/refresh", async ([FromBody] RefreshTokenComando comando, [FromServices] IMediator mediator) =>
            {
                var result = await mediator.Send(comando);
                return Results.Json(result, statusCode: result.Status);
            })
            .WithName("RefreshToken")
            .Produces<IToReturn<LoginRespuesta>>(StatusCodes.Status200OK, "application/json");

            // Simple "Me" endpoint (delegado que lee de los claims en un entorno seguro si pusiéramos validación JWT acá)
            // Ya que la validación fuerte va en el Gateway, acá podríamos simplemente confiar en los headers que envía el proxy.
            group.MapGet("/me", (HttpContext context) =>
            {
                if (context.Request.Headers.TryGetValue("X-User-Id", out var userIdValue))
                {
                    return Results.Ok(new
                    {
                        UserId = userIdValue.ToString(),
                        Roles = context.Request.Headers["X-User-Roles"].ToString(),
                        Permisos = context.Request.Headers["X-User-Permisos"].ToString()
                    });
                }
                return Results.Unauthorized();
            })
            .WithName("ObtenerUsuarioActual");
        }
    }
}
