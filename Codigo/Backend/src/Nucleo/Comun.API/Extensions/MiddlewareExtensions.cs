using Microsoft.AspNetCore.Builder;
using Nucleo.Comun.API.Middleware;

namespace Nucleo.Comun.API.Extensions
{
    public static class MiddlewareExtensions
    {
        public static IApplicationBuilder UseManejoExcepcionesGlobal(this IApplicationBuilder app)
        {
            return app.UseMiddleware<ManejoExcepcionesMiddleware>();
        }
    }
}
