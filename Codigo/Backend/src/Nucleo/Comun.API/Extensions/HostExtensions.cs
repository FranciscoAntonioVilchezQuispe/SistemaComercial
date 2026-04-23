using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.DependencyInjection;

namespace Nucleo.Comun.API.Extensions
{
    public static class HostExtensions
    {
        public static IWebHostBuilder ConfigureKestrelLimits(this IWebHostBuilder webBuilder)
        {
            return webBuilder.ConfigureKestrel(serverOptions =>
            {
                // Aumentar el límite total de encabezados a 64KB (default es 32KB)
                // Esto es necesario debido al tamaño de los tokens JWT con permisos granulares.
                serverOptions.Limits.MaxRequestHeadersTotalSize = 65536;
                
                // Opcional: Aumentar el número máximo de encabezados si es necesario
                serverOptions.Limits.MaxRequestHeaderCount = 100;
            });
        }
    }
}
