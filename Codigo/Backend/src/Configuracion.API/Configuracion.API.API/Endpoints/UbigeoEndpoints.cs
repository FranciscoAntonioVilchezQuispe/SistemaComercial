using Configuracion.API.Domain.DTOs;
using Configuracion.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;

namespace Configuracion.API.Endpoints
{
    public static class UbigeoEndpoints
    {
        public static void MapUbigeoEndpoints(this IEndpointRouteBuilder endpoints)
        {
            var group = endpoints.MapGroup("/api/ubigeo").WithTags("Ubigeo");

            group.MapGet("/departamentos", async (IUbigeoRepository repo) =>
            {
                var resultados = await repo.GetDepartamentosAsync();
                return Results.Ok(new ToReturnList<UbigeoItemDto>(resultados));
            }).WithName("GetDepartamentos");

            group.MapGet("/provincias", async (IUbigeoRepository repo, [FromQuery] string dept) =>
            {
                if (string.IsNullOrEmpty(dept)) return Results.BadRequest("El código de departamento es requerido");
                var resultados = await repo.GetProvinciasByDepartamentoAsync(dept);
                return Results.Ok(new ToReturnList<UbigeoItemDto>(resultados));
            }).WithName("GetProvincias");

            group.MapGet("/distritos", async (IUbigeoRepository repo, [FromQuery] string prov) =>
            {
                if (string.IsNullOrEmpty(prov)) return Results.BadRequest("El código de provincia es requerido");
                var resultados = await repo.GetDistritosByProvinciaAsync(prov);
                return Results.Ok(new ToReturnList<UbigeoItemDto>(resultados));
            }).WithName("GetDistritos");

            group.MapGet("/detalle/{codigo6}", async (IUbigeoRepository repo, string codigo6) =>
            {
                if (string.IsNullOrEmpty(codigo6)) return Results.BadRequest("El código de ubigeo es requerido");
                var detalle = await repo.GetDetalleByCodigoAsync(codigo6);
                return detalle != null ? Results.Ok(new ToReturn<UbigeoDetalleDto>(detalle)) : Results.NotFound();
            }).WithName("GetUbigeoDetalle");

            group.MapGet("/search", async (IUbigeoRepository repo, [FromQuery] string q, [FromQuery] int? limit) =>
            {
                if (string.IsNullOrEmpty(q)) return Results.BadRequest("El término de búsqueda es requerido");
                var resultados = await repo.SearchAsync(q, limit ?? 15);
                return Results.Ok(new ToReturnList<UbigeoSearchResultDto>(resultados));
            }).WithName("SearchUbigeos");
        }
    }
}
