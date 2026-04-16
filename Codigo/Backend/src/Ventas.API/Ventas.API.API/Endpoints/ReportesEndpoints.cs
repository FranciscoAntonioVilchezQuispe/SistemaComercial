using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Ventas.API.Domain.Interfaces;
using Ventas.API.Domain.DTOs.Reportes;
using System.Collections.Generic;
using System;
using System.Threading.Tasks;

namespace Ventas.API.Endpoints
{
    public static class ReportesEndpoints
    {
        public static void MapReportesVentasEndpoints(this IEndpointRouteBuilder builder)
        {
            var grupo = builder.MapGroup("/api/ventas/reportes");

            grupo.MapGet("/ranking-productos", async (DateTime? fechaInicio, DateTime? fechaFin, int? top, IVentaRepositorio repo) =>
            {
                var inicio = fechaInicio ?? DateTime.SpecifyKind(DateTime.Today.AddDays(-30), DateTimeKind.Utc);
                var fin = fechaFin ?? DateTime.SpecifyKind(DateTime.Today.AddDays(1).AddTicks(-1), DateTimeKind.Utc);
                var limite = top ?? 10;

                var datos = await repo.ObtenerRankingProductosAsync(inicio, fin, limite);
                return Results.Ok(datos);
            });

            grupo.MapGet("/top-clientes", async (DateTime? fechaInicio, DateTime? fechaFin, int? top, IVentaRepositorio repo) =>
            {
                var inicio = fechaInicio ?? DateTime.SpecifyKind(DateTime.Today.AddDays(-30), DateTimeKind.Utc);
                var fin = fechaFin ?? DateTime.SpecifyKind(DateTime.Today.AddDays(1).AddTicks(-1), DateTimeKind.Utc);
                var limite = top ?? 10;

                var datos = await repo.ObtenerTopClientesAsync(inicio, fin, limite);
                return Results.Ok(datos);
            });
        }
    }
}
