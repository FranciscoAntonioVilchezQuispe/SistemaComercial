using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Application.Wrappers;
using System.Net;
using System.Text.Json;

namespace Nucleo.Comun.API.Middleware
{
    public class ManejoExcepcionesMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ManejoExcepcionesMiddleware> _logger;

        public ManejoExcepcionesMiddleware(RequestDelegate next, ILogger<ManejoExcepcionesMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Ocurrió una excepción no controlada: {Message}", ex.Message);
                await ManejarExcepcionAsync(context, ex);
            }
        }

        private static Task ManejarExcepcionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            
            // Especialización por tipo de error
            context.Response.StatusCode = exception switch
            {
                KeyNotFoundException => (int)HttpStatusCode.NotFound,        // 404
                UnauthorizedAccessException => (int)HttpStatusCode.Unauthorized, // 401
                ArgumentException => (int)HttpStatusCode.BadRequest,         // 400
                InvalidOperationException => (int)HttpStatusCode.Conflict,    // 409
                _ => (int)HttpStatusCode.InternalServerError                // 500 (por defecto)
            };

            var response = new ToReturnError<object>(exception.Message, context.Response.StatusCode);
            
            var options = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };

            var result = JsonSerializer.Serialize(response, options);
            return context.Response.WriteAsync(result);
        }
    }
}
