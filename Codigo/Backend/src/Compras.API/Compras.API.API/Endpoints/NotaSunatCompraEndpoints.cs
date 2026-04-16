using Compras.API.Infrastructure.Datos;
using Microsoft.EntityFrameworkCore;
using Dapper;
using System.Data;
using Nucleo.Comun.Application.Paginacion;
using System.Linq;
using MediatR;
using Compras.API.Application.DTOs;
using Compras.API.Application.Comandos;

namespace Compras.API.Endpoints
{
    public class NotaResumenCompraDto
    {
        public long IdNota { get; set; }
        public string Serie { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public string TipoComprobante { get; set; } = null!;
        public DateTime FechaEmision { get; set; }
        public string ProveedorRazonSocial { get; set; } = null!;
        public string Estado { get; set; } = null!;
        public decimal Total { get; set; }
        public int TotalFilas { get; set; }
    }

    public class NotaDetalleCompraDto
    {
        public long Id { get; set; }
        public string Serie { get; set; } = null!;
        public string Numero { get; set; } = null!;
        public string TipoComprobante { get; set; } = null!;
        public DateTime FechaEmision { get; set; }
        
        public long IdCompraReferencia { get; set; }
        public string SerieReferencia { get; set; } = null!;
        public string NumeroReferencia { get; set; } = null!;
        public string TipoDocReferencia { get; set; } = null!;

        public long IdTipoNota { get; set; }
        public string MotivoSustento { get; set; } = null!;

        public string ProveedorNroDoc { get; set; } = null!;
        public string ProveedorRazonSocial { get; set; } = null!;

        public decimal Subtotal { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
        public string Moneda { get; set; } = "PEN";
        public decimal? TipoCambio { get; set; }
        public bool AfectaStock { get; set; }
        public string Estado { get; set; } = null!;

        public List<NotaItemDetalleCompraDto> Detalles { get; set; } = new();
    }

    public class NotaItemDetalleCompraDto
    {
        public long Id { get; set; }
        public long IdProducto { get; set; }
        public string? Descripcion { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
        public string? UnidadMedida { get; set; }
    }

    public class MotivoCompraDto
    {
        public long IdMotivo { get; set; }
        public string CodigoSunat { get; set; } = null!;
        public string Descripcion { get; set; } = null!;
    }
    public static class NotaSunatCompraEndpoints
    {
        public static void MapNotaSunatCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/compras/notas").WithTags("Notas SUNAT (Compras)");

            // Listado de Notas de Crédito
            grupo.MapGet("/credito", async (ComprasDbContext db, [AsParameters] PagedRequest request) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                int pageSize = request.PageSize ?? 10;
                int offset = ((request.PageNumber ?? 1) - 1) * pageSize;

                string sql = @"
                    SELECT 
                        id_nota as IdNota, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision, 
                        proveedor_razon_social as ProveedorRazonSocial, 
                        estado as Estado, total as Total,
                        COUNT(*) OVER() as TotalFilas
                    FROM compras.nota_credito
                    WHERE (@Search IS NULL OR serie ILIKE '%' || @Search || '%' OR proveedor_razon_social ILIKE '%' || @Search || '%')
                    ORDER BY fecha_emision DESC, id_nota DESC
                    LIMIT @PageSize OFFSET @Offset;
                ";

                var datos = await connection.QueryAsync<NotaResumenCompraDto>(sql, new { Search = request.Search, PageSize = pageSize, Offset = offset });
                var totalRows = datos.FirstOrDefault()?.TotalFilas ?? 0;

                return Results.Ok(new PagedResponse<NotaResumenCompraDto>(datos, request.PageNumber ?? 1, pageSize, totalRows));
            });

            // Detalle de Nota de Crédito
            grupo.MapGet("/credito/{id:long}", async (ComprasDbContext db, long id) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                string sqlNota = @"
                    SELECT 
                        id_nota as Id, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision,
                        id_compra_referencia as IdCompraReferencia, serie_referencia as SerieReferencia,
                        numero_referencia as NumeroReferencia, tipo_doc_referencia as TipoDocReferencia,
                        id_tipo_nota as IdTipoNota, motivo_sustento as MotivoSustento,
                        proveedor_nro_doc as ProveedorNroDoc, proveedor_razon_social as ProveedorRazonSocial,
                        subtotal, igv, total, moneda, tipo_cambio as TipoCambio,
                        afecta_stock as AfectaStock, estado
                    FROM compras.nota_credito
                    WHERE id_nota = @Id;
                ";

                var nota = await connection.QueryFirstOrDefaultAsync<NotaDetalleCompraDto>(sqlNota, new { Id = id });
                if (nota == null) return Results.NotFound();

                string sqlDetalle = @"
                    SELECT 
                        id_detalle as Id, id_producto as IdProducto, descripcion,
                        cantidad, precio_unitario as PrecioUnitario, subtotal, igv, total,
                        unidad_medida as UnidadMedida
                    FROM compras.nota_credito_detalle
                    WHERE id_nota_credito = @Id;
                ";

                var detalles = await connection.QueryAsync<NotaItemDetalleCompraDto>(sqlDetalle, new { Id = id });
                nota.Detalles = detalles.ToList();

                return Results.Ok(nota);
            });

            // Listado de Notas de Débito
            grupo.MapGet("/debito", async (ComprasDbContext db, [AsParameters] PagedRequest request) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                int pageSize = request.PageSize ?? 10;
                int offset = ((request.PageNumber ?? 1) - 1) * pageSize;

                string sql = @"
                    SELECT 
                        id_nota as IdNota, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision, 
                        proveedor_razon_social as ProveedorRazonSocial, 
                        estado as Estado, total as Total,
                        COUNT(*) OVER() as TotalFilas
                    FROM compras.nota_debito
                    WHERE (@Search IS NULL OR serie ILIKE '%' || @Search || '%' OR proveedor_razon_social ILIKE '%' || @Search || '%')
                    ORDER BY fecha_emision DESC, id_nota DESC
                    LIMIT @PageSize OFFSET @Offset;
                ";

                var datos = await connection.QueryAsync<NotaResumenCompraDto>(sql, new { Search = request.Search, PageSize = pageSize, Offset = offset });
                var totalRows = datos.FirstOrDefault()?.TotalFilas ?? 0;

                return Results.Ok(new PagedResponse<NotaResumenCompraDto>(datos, request.PageNumber ?? 1, pageSize, totalRows));
            });

            // Detalle de Nota de Débito
            grupo.MapGet("/debito/{id:long}", async (ComprasDbContext db, long id) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                string sqlNota = @"
                    SELECT 
                        id_nota as Id, serie as Serie, numero as Numero, 
                        tipo_comprobante as TipoComprobante, fecha_emision as FechaEmision,
                        id_compra_referencia as IdCompraReferencia, serie_referencia as SerieReferencia,
                        numero_referencia as NumeroReferencia, tipo_doc_referencia as TipoDocReferencia,
                        id_tipo_nota as IdTipoNota, motivo_sustento as MotivoSustento,
                        proveedor_nro_doc as ProveedorNroDoc, proveedor_razon_social as ProveedorRazonSocial,
                        subtotal, igv, total, moneda, tipo_cambio as TipoCambio,
                        afecta_stock as AfectaStock, estado
                    FROM compras.nota_debito
                    WHERE id_nota = @Id;
                ";

                var nota = await connection.QueryFirstOrDefaultAsync<NotaDetalleCompraDto>(sqlNota, new { Id = id });
                if (nota == null) return Results.NotFound();

                string sqlDetalle = @"
                    SELECT 
                        id_detalle as Id, id_producto as IdProducto, descripcion,
                        cantidad, precio_unitario as PrecioUnitario, subtotal, igv, total,
                        unidad_medida as UnidadMedida
                    FROM compras.nota_debito_detalle
                    WHERE id_nota_debito = @Id;
                ";

                var detalles = await connection.QueryAsync<NotaItemDetalleCompraDto>(sqlDetalle, new { Id = id });
                nota.Detalles = detalles.ToList();

                return Results.Ok(nota);
            });

            // Catálogos SUNAT (Motivos)
            grupo.MapGet("/catalogos/motivos-credito", async (ComprasDbContext db) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                var datos = await connection.QueryAsync<MotivoCompraDto>(
                    "SELECT id_motivo AS IdMotivo, codigo AS CodigoSunat, nombre AS Descripcion FROM configuracion.motivo_nota_credito ORDER BY codigo");
                return Results.Ok(new Nucleo.Comun.Application.Wrappers.ToReturnList<MotivoCompraDto>(datos));
            });

            grupo.MapGet("/catalogos/motivos-debito", async (ComprasDbContext db) =>
            {
                var connection = db.Database.GetDbConnection();
                if (connection.State != ConnectionState.Open) await connection.OpenAsync();

                var datos = await connection.QueryAsync<MotivoCompraDto>(
                    "SELECT id_motivo AS IdMotivo, codigo AS CodigoSunat, nombre AS Descripcion FROM configuracion.motivo_nota_debito ORDER BY codigo");
                return Results.Ok(new Nucleo.Comun.Application.Wrappers.ToReturnList<MotivoCompraDto>(datos));
            });

            // Registro POST original (mantenido)
            grupo.MapPost("/credito", async (NotaCreditoCompraDto dto, IMediator mediator) =>
            {
                try
                {
                    var resultado = await mediator.Send(new CrearNotaCreditoCompraComando(dto));
                    return Results.Created($"/api/compras/notas/credito/{resultado.Id}", resultado);
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });

            // Notas de Débito Compra
            grupo.MapPost("/debito", async (NotaDebitoCompraDto dto, IMediator mediator) =>
            {
                try
                {
                    var resultado = await mediator.Send(new CrearNotaDebitoCompraComando(dto));
                    return Results.Created($"/api/compras/notas/debito/{resultado.Id}", resultado);
                }
                catch (Exception ex)
                {
                    return Results.BadRequest(new { message = ex.Message });
                }
            });
        }
    }
}
