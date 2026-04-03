using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;

namespace Nucleo.Comun.Application.Extensions
{
    public static class LoggingExtensions
    {
        /// <summary>
        /// Configura Serilog como proveedor de logging centralizado para todos los microservicios.
        /// - Consola: logs de nivel Information en adelante (para desarrollo).
        /// - Archivo: solo errores, en la carpeta LogErrores con rotación diaria por microservicio.
        /// </summary>
        public static void AddCentralizedLogging(this WebApplicationBuilder builder)
        {
            // Derivar el nombre del microservicio desde el ApplicationName para separar logs
            var nombreApp = builder.Environment.ApplicationName
                .Replace(".API", "")
                .Replace(".", "_")
                .ToLowerInvariant();

            var rutaLogs = @"d:\Personal\Proyectos\SistemaComercial\Codigo\LogErrores";

            // Limpiar proveedores por defecto para evitar duplicados
            builder.Logging.ClearProviders();

            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Information()
                .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
                .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Information)
                .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
                .Enrich.FromLogContext()
                .Enrich.WithProperty("Microservicio", nombreApp)
                // Consola: logs informativos para desarrollo
                .WriteTo.Console(
                    outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] [{Microservicio}] {Message:lj}{NewLine}{Exception}")
                // Archivo: solo errores, rotación diaria, organizado por microservicio
                .WriteTo.File(
                    path: Path.Combine(rutaLogs, $"{nombreApp}-.log"),
                    rollingInterval: RollingInterval.Day,
                    restrictedToMinimumLevel: LogEventLevel.Error,
                    outputTemplate: "[{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz}] [{Level:u3}] [{SourceContext}]{NewLine}  Mensaje: {Message:lj}{NewLine}  {Exception}{NewLine}---{NewLine}",
                    retainedFileCountLimit: 30,
                    fileSizeLimitBytes: 10_000_000,
                    rollOnFileSizeLimit: true)
                .CreateLogger();

            builder.Host.UseSerilog();
        }
    }
}
