using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Application.Wrappers;
using Nucleo.Comun.Domain;
using System.Net;
using System.Text.Json;
using FluentValidation;

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
                await ManejarExcepcionAsync(context, ex);
            }
        }

        private async Task ManejarExcepcionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            
            var status = exception switch
            {
                AppException => (int)HttpStatusCode.InternalServerError,
                ValidationException => (int)HttpStatusCode.BadRequest,
                KeyNotFoundException => (int)HttpStatusCode.NotFound,
                UnauthorizedAccessException => (int)HttpStatusCode.Unauthorized,
                ArgumentException => (int)HttpStatusCode.BadRequest,
                InvalidOperationException => (int)HttpStatusCode.Conflict,
                _ => (int)HttpStatusCode.InternalServerError
            };

            context.Response.StatusCode = status;

            var mensaje = exception switch
            {
                AppException appEx => appEx.Message,
                ValidationException => "Error de validación en los datos enviados",
                _ => "Error interno del servidor"
            };
            
            // Logging estandar según GEMINI.md
            Console.Error.WriteLine($"[ERROR] [GlobalMiddleware] [{context.Request.Method} {context.Request.Path}] → {exception.Message}");
            if (exception is AppException ae)
            {
                Console.Error.WriteLine($"Detalle: Contexto={ae.Contexto} | Datos={ae.Detalle}");
            }
            Console.Error.WriteLine($"Stack: {exception.StackTrace}");

            var response = new 
            {
                statusCode = status,
                message = mensaje,
                errors = exception is ValidationException vex ? vex.Errors.Select(e => new { property = e.PropertyName, error = e.ErrorMessage }) : null,
                timestamp = DateTime.UtcNow
            };
            
            var options = new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            };

            var result = JsonSerializer.Serialize(response, options);
            await context.Response.WriteAsync(result);
        }
    }
}
