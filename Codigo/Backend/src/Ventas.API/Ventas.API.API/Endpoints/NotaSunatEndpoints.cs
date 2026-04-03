using Ventas.API.Application.Comandos;
using Ventas.API.Application.DTOs;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Dapper;
using System.Data;
using Ventas.API.Infrastructure.Datos;
using Nucleo.Comun.Application.Paginacion;

namespace Ventas.API.Endpoints
{
    public class NotaResumenDto
    {
        public long IdNota { get; set; }
        public string Serie { get; set; } = null!;
        public long Numero { get; set; }
        public string TipoComprobante { get; set; } = null!;
        public DateTime FechaEmision { get; set; }
        public string ClienteRazonSocial { get; set; } = null!;
        public string EstadoCpe { get; set; } = null!;
        public decimal Total { get; set; }
        public int TotalFilas { get; set; } // COUNT(*) OVER()
    }

    public class MotivoDto
    {
        public long IdMotivo { get; set; }
        public string CodigoSunat { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
    }

    public class EstadoCpeDto
    {
        public string IdEstado { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
    }

    public static class NotaSunatEndpoints
    {
        public static void MapNotaSunatEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/notas").WithTags("Notas SUNAT (Ventas)");

            // Listado de Notas de Crédito
            grupo.MapGet("/credito", async (VentasDbContext db, [AsParameters] PagedRequest request) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                int pageSize = request.PageSize ?? 10;
                int offset = ((request.PageNumber ?? 1) - 1) * pageSize;

                string sql = @"
                    SELECT 
                        id_nota as IdNota, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision, 
                        cliente_razon_social as ClienteRazonSocial, 
                        COALESCE(id_estado_cpe, 'PENDIENTE') as EstadoCpe, 
                        total as Total,
                        COUNT(*) OVER() as TotalFilas
                    FROM ventas.nota_credito
                    WHERE (@Search IS NULL OR serie ILIKE '%' || @Search || '%' OR cliente_razon_social ILIKE '%' || @Search || '%')
                    ORDER BY fecha_emision DESC, id_nota DESC
                    LIMIT @PageSize OFFSET @Offset;
                ";

                var datos = await connection.QueryAsync<NotaResumenDto>(sql, new { Search = request.Search, PageSize = pageSize, Offset = offset });
                var total = datos.FirstOrDefault()?.TotalFilas ?? 0;

                var response = new PagedResponse<NotaResumenDto>(datos, request.PageNumber ?? 1, pageSize, total);
                return Results.Ok(response);
            });

            // Recrear POST original
            grupo.MapPost("/credito", async (CrearNotaCreditoComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/notas/credito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Listado de Notas de Débito
            grupo.MapGet("/debito", async (VentasDbContext db, [AsParameters] PagedRequest request) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                int pageSize = request.PageSize ?? 10;
                int offset = ((request.PageNumber ?? 1) - 1) * pageSize;

                string sql = @"
                    SELECT 
                        id_nota as IdNota, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision, 
                        cliente_razon_social as ClienteRazonSocial, 
                        COALESCE(id_estado_cpe, 'PENDIENTE') as EstadoCpe, 
                        total as Total,
                        COUNT(*) OVER() as TotalFilas
                    FROM ventas.nota_debito
                    WHERE (@Search IS NULL OR serie ILIKE '%' || @Search || '%' OR cliente_razon_social ILIKE '%' || @Search || '%')
                    ORDER BY fecha_emision DESC, id_nota DESC
                    LIMIT @PageSize OFFSET @Offset;
                ";

                var datos = await connection.QueryAsync<NotaResumenDto>(sql, new { Search = request.Search, PageSize = pageSize, Offset = offset });
                var total = datos.FirstOrDefault()?.TotalFilas ?? 0;

                var response = new PagedResponse<NotaResumenDto>(datos, request.PageNumber ?? 1, pageSize, total);
                return Results.Ok(response);
            });

            // Recrear POST original
            grupo.MapPost("/debito", async (CrearNotaDebitoComando comando, IMediator mediator) =>
            {
                try
                {
                    var id = await mediator.Send(comando);
                    return Results.Created($"/api/notas/debito/{id}", new { id });
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Catálogos SUNAT
            grupo.MapGet("/catalogos/motivos-credito", async (VentasDbContext db) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                var datos = await connection.QueryAsync<MotivoDto>(
                    "SELECT id_motivo AS IdMotivo, codigo AS CodigoSunat, nombre AS Descripcion FROM configuracion.motivo_nota_credito ORDER BY codigo");
                return Results.Ok(new Nucleo.Comun.Application.Wrappers.ToReturnList<MotivoDto>(datos));
            });

            grupo.MapGet("/catalogos/motivos-debito", async (VentasDbContext db) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                var datos = await connection.QueryAsync<MotivoDto>(
                    "SELECT id_motivo AS IdMotivo, codigo AS CodigoSunat, nombre AS Descripcion FROM configuracion.motivo_nota_debito ORDER BY codigo");
                return Results.Ok(new Nucleo.Comun.Application.Wrappers.ToReturnList<MotivoDto>(datos));
            });

            grupo.MapGet("/catalogos/estado-cpe", async (VentasDbContext db) =>
            {
                var estados = await db.EstadosCpe.Select(e => new EstadoCpeDto { 
                    IdEstado = e.IdEstado, Descripcion = e.Descripcion 
                }).ToListAsync();
                return Results.Ok(new Nucleo.Comun.Application.Wrappers.ToReturnList<EstadoCpeDto>(estados));
            });
        }
    }
}
