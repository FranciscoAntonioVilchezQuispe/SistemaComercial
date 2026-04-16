using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Compras.API.Domain.Interfaces;
using Compras.API.Domain.DTOs.Reportes;
using System.Collections.Generic;
using System;
using System.Threading.Tasks;

namespace Compras.API.Endpoints
{
    public static class ReportesComprasEndpoints
    {
        public static void MapReportesComprasEndpoints(this IEndpointRouteBuilder builder)
        {
            var grupo = builder.MapGroup("/api/compras/reportes").WithTags("Reportes Compras");

            grupo.MapGet("/compras-proveedor", async (DateTime? fechaInicio, DateTime? fechaFin, int? top, ICompraRepositorio repo) =>
            {
                var inicio = fechaInicio ?? DateTime.SpecifyKind(DateTime.Today.AddDays(-30), DateTimeKind.Utc);
                var fin = fechaFin ?? DateTime.SpecifyKind(DateTime.Today.AddDays(1).AddTicks(-1), DateTimeKind.Utc);
                var limite = top ?? 10;

                var datos = await repo.ObtenerComprasPorProveedorAsync(inicio, fin, limite);
                return Results.Ok(datos);
            });
        }
    }
}
