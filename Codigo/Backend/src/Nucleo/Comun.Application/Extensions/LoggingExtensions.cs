using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;

namespace Nucleo.Comun.Application.Extensions
{
    public static class LoggingExtensions
    {
        public static void AddCentralizedLogging(this WebApplicationBuilder builder)
        {
            // Clear default providers to avoid duplication
            builder.Logging.ClearProviders();

            // Setup Serilog
            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Information()
                .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
                .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Information)
                .Enrich.FromLogContext()
                .WriteTo.Console() 
                .WriteTo.File(@"d:\Proyectos\SistemaComercial\Codigo\LogErrores\log-.txt", 
                    rollingInterval: RollingInterval.Day,
                    restrictedToMinimumLevel: LogEventLevel.Error) // Log only errors to file as requested? 
                    // User said: "todos lo log de errores ... deben estar en esa carpeta"
                    // Usually this implies errors, but sometimes users mean "all logs". 
                    // Given the folder name "LogErrores", I will stick to Error level for the file to assume that's the intent, 
                    // OR I can log everything but maybe that's too much noise.
                    // Let's log Information and above to console, but Errors to the file as requested.
                .CreateLogger();

            builder.Host.UseSerilog();
        }
    }
}
