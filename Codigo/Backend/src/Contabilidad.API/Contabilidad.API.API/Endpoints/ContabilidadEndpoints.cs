using Contabilidad.API.Domain.Entidades;
using Contabilidad.API.Domain.Interfaces;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using Nucleo.Comun.Application.Paginacion;

namespace Contabilidad.API.Endpoints
{
    public static class PlanCuentaEndpoints
    {
        public static void MapPlanCuentaEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/plan-cuentas").WithTags("Plan de Cuentas");

            grupo.MapGet("/", async ([AsParameters] PagedRequest request, int? nivel, IPlanCuentaRepositorio repo) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, nivel, request.PageNumber ?? 1, request.PageSize ?? 100);
                var response = new PagedResponse<PlanCuenta>(datos, total, request.PageNumber ?? 1, request.PageSize ?? 100);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, IPlanCuentaRepositorio repo) =>
            {
                var cuenta = await repo.ObtenerPorIdAsync(id);
                if (cuenta == null) return Results.NotFound(new ToReturnError<PlanCuenta>("Cuenta no encontrada", 404));
                return Results.Ok(new ToReturn<PlanCuenta>(cuenta));
            });

            grupo.MapGet("/nivel/{nivel}", async (int nivel, IPlanCuentaRepositorio repo) =>
            {
                var cuentas = await repo.ObtenerPorNivelAsync(nivel);
                return Results.Ok(new ToReturnList<PlanCuenta>(cuentas));
            });
        }
    }

    public static class CentroCostoEndpoints
    {
        public static void MapCentroCostoEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/centros-costo").WithTags("Centros de Costo");

            grupo.MapGet("/", async ([AsParameters] PagedRequest request, ICentroCostoRepositorio repo) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 100);
                var response = new PagedResponse<CentroCosto>(datos, total, request.PageNumber ?? 1, request.PageSize ?? 100);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, ICentroCostoRepositorio repo) =>
            {
                var centro = await repo.ObtenerPorIdAsync(id);
                if (centro == null) return Results.NotFound(new ToReturnError<CentroCosto>("Centro de costo no encontrado", 404));
                return Results.Ok(new ToReturn<CentroCosto>(centro));
            });
        }
    }
}
