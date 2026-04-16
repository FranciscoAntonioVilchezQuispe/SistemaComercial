using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Nucleo.Comun.Application.Wrappers;
using Nucleo.Comun.Domain;
using System.Net;
using System.Text.Json;
using FluentValidation;
using Nucleo.Comun.Domain.Helpers;

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
            
            // Logging estructurado con Serilog — escribe automáticamente a consola y archivo
            var endpoint = $"{context.Request.Method} {context.Request.Path}";
            
            if (exception is AppException ae)
            {
                _logger.LogError(exception,
                    "[GlobalMiddleware] [{Endpoint}] {Mensaje} | Contexto={Contexto} | Datos={Detalle}",
                    endpoint, exception.Message, ae.Contexto, ae.Detalle);
            }
            else if (exception is ValidationException vex)
            {
                // Validaciones no son errores del sistema, se loguean como Warning
                var errores = string.Join("; ", vex.Errors.Select(e => $"{e.PropertyName}: {e.ErrorMessage}"));
                _logger.LogWarning(
                    "[GlobalMiddleware] [{Endpoint}] Validación fallida: {Errores}",
                    endpoint, errores);
            }
            else
            {
                _logger.LogError(exception,
                    "[GlobalMiddleware] [{Endpoint}] {Mensaje}",
                    endpoint, exception.Message);
            }

            var response = new 
            {
                statusCode = status,
                message = mensaje,
                errors = exception is ValidationException ve 
                    ? ve.Errors.Select(e => new { property = e.PropertyName, error = e.ErrorMessage }) 
                    : null,
                timestamp = DateTimeHelper.ObtenerAhoraLima()
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
