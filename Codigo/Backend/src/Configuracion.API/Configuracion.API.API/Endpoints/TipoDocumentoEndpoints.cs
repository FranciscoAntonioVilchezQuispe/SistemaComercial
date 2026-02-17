using Configuracion.API.Application.Interfaces;
using Configuracion.API.Domain.Entidades;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Threading.Tasks;

namespace Configuracion.API.Endpoints
{
    public static class TipoDocumentoEndpoints
    {
        public static void MapTipoDocumentoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/tipos-documento").WithTags("Tipos de Documento");

            grupo.MapGet("/", async (IReglasDocumentoServicio servicio) =>
            {
                var reglas = await servicio.ListarReglasAsync();
                return Results.Ok(new ToReturnList<DocumentoIdentidadRegla>(reglas));
            })
            .WithName("ObtenerTiposDocumento")
            .WithDescription("Obtiene la lista de tipos de documento de identidad (DNI, RUC, etc.)");
        }
    }
}
