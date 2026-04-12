using Compras.API.Domain.Entidades;
using Compras.API.Domain.Interfaces;
using Compras.API.Domain.DTOs;
using Compras.API.Application.DTOs;
using Compras.API.Application.Comandos;
using MediatR;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;
using Nucleo.Comun.Application.Wrappers;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Compras.API.Infrastructure.Datos;
using System.Threading.Tasks;

namespace Compras.API.Endpoints
{
    public static class CompraEndpoints
    {
        public static void MapCompraEndpoints(this IEndpointRouteBuilder app)
        {
            var grupo = app.MapGroup("/api/compras").WithTags("Compras");

            grupo.MapGet("/", async ([AsParameters] Nucleo.Comun.Application.Paginacion.PagedRequest request, ICompraRepositorio repo) =>
            {
                var (datos, total) = await repo.ObtenerPaginadoAsync(request.Search, request.PageNumber ?? 1, request.PageSize ?? 10);
                var response = new Nucleo.Comun.Application.Paginacion.PagedResponse<CompraListDto>(datos, request.PageNumber ?? 1, request.PageSize ?? 10, total);
                return Results.Ok(response);
            });

            grupo.MapGet("/{id}", async (long id, ICompraRepositorio repo) =>
            {
                var compra = await repo.ObtenerDetallePorIdAsync(id);
                if (compra == null) return Results.NotFound(new ToReturnError<CompraDetalleDto>("Compra no encontrada", 404));
                return Results.Ok(new ToReturn<CompraDetalleDto>(compra));
            });

            grupo.MapPost("/", async (CompraDto dto, IMediator mediator) =>
            {
                var id = await mediator.Send(new CrearCompraComando(dto));
                return Results.Created($"/api/compras/{id}", new ToReturn<long>(id));
            });

            grupo.MapDelete("/{id}", async (long id, IMediator mediator) =>
            {
                var exito = await mediator.Send(new EliminarCompraComando(id));
                if (!exito) return Results.NotFound(new ToReturnError<bool>("Compra no encontrada", 404));
                return Results.Ok(new ToReturn<bool>(true));
            });

            grupo.MapPost("/{id}/anular", async (long id, AnularCompraRequest request, IMediator mediator) =>
            {
                var exito = await mediator.Send(new AnularCompraComando(id, request.Motivo, request.UsuarioId));
                if (!exito) return Results.BadRequest(new ToReturnError<bool>("No se pudo anular la compra", 400));
                return Results.Ok(new ToReturn<bool>(true));
            });

            grupo.MapGet("/debug-fix-db", async (ComprasDbContext context) =>
            {
                string sql = @"
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_detalle_compra_compras_id_comprao' AND table_name = 'detalle_compra' AND table_schema = 'compras') THEN
        ALTER TABLE compras.detalle_compra DROP CONSTRAINT fk_detalle_compra_compras_id_comprao;
    END IF;
    IF EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_detalle_compra_id_comprao' AND n.nspname = 'compras') THEN
        DROP INDEX compras.ix_detalle_compra_id_comprao;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'detalle_compra' AND table_schema = 'compras' AND column_name = 'id_comprao') THEN
        ALTER TABLE compras.detalle_compra DROP COLUMN id_comprao;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = 'ix_detalle_compra_id_compra' AND n.nspname = 'compras') THEN
        CREATE INDEX ix_detalle_compra_id_compra ON compras.detalle_compra (id_compra);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_detalle_compra_compras_id_compra' AND table_name = 'detalle_compra' AND table_schema = 'compras') THEN
        ALTER TABLE compras.detalle_compra ADD CONSTRAINT fk_detalle_compra_compras_id_compra FOREIGN KEY (id_compra) REFERENCES compras.compras (id_compra) ON DELETE CASCADE;
    END IF;

    -- Notas SUNAT (Corrección Esquema)
    ALTER TABLE compras.nota_credito ADD COLUMN IF NOT EXISTS id_estado bigint DEFAULT 60;
    ALTER TABLE compras.nota_debito ADD COLUMN IF NOT EXISTS id_estado bigint DEFAULT 60;


    CREATE TABLE IF NOT EXISTS compras.""__EFMigrationsHistory"" (
        ""MigrationId"" character varying(150) NOT NULL,
        ""ProductVersion"" character varying(32) NOT NULL,
        CONSTRAINT pk_ef_migrations_history PRIMARY KEY (""MigrationId"")
    );

    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260129231053_Inicial', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260206190831_FixDetalleAudit', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260213160911_AddCompraIdToOrdenCompra', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260217183807_UpdateOrdenCompraSerieNumero', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260217203920_AddSerieNumeroCorrelativoToOrdenCompra', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260219175334_AddObservacionesToCompra', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260221132104_AddCamposSunatPle81', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.8') ON CONFLICT DO NOTHING;
    INSERT INTO compras.""__EFMigrationsHistory"" (""MigrationId"", ""ProductVersion"") VALUES ('20260322232250_FixTypoIdCompra', '8.0.8') ON CONFLICT DO NOTHING;
END
$$;";
                await context.Database.ExecuteSqlRawAsync(sql);
                return Results.Ok("Esquema de Compras corregido y sincronizado con EF Core.");
            });
        }

        private static CompraDto MapToDto(Compra c) => new CompraDto
        {
            Id = c.Id,
            IdProveedor = c.IdProveedor,
            RazonSocialProveedor = c.Proveedor?.RazonSocial,
            IdAlmacen = c.IdAlmacen,
            // NombreAlmacen se poblaría aquí si tuviéramos la referencia en la entidad, 
            // pero como lo hicimos vía join en el repo, aseguramos que se pase.
            // Para simplicidad en este paso, asumimos que el repo ya enriqueció la entidad si es posible,
            // o lo mapeamos directamente si tenemos acceso a las propiedades de navegación.
            IdOrdenCompraRef = c.IdOrdenCompraRef,
            IdTipoComprobante = c.IdTipoComprobante,
            SerieComprobante = c.SerieComprobante,
            NumeroComprobante = c.NumeroComprobante,
            FechaEmision = c.FechaEmision,
            FechaContable = c.FechaContable,
            FechaVencimiento = c.FechaVencimiento,
            IdMoneda = c.Moneda == "USD" ? 52 : 51,
            Moneda = c.Moneda,
            TipoCambio = c.TipoCambio,
            Subtotal = c.Subtotal,
            BaseGravada = c.BaseGravada,
            BaseExonerada = c.BaseExonerada,
            BaseInafecta = c.BaseInafecta,
            Impuesto = c.Impuesto,
            Total = c.Total,
            SaldoPendiente = c.SaldoPendiente,
            IdEstadoPago = c.IdEstadoPago,
            IdEstado = c.IdEstado,
            FechaCreacion = c.FechaCreacion,
            Observaciones = c.Observaciones,
            NombreAlmacen = c.NombreAlmacen,
            NombreTipoComprobante = c.NombreTipoComprobante,
            NumeroDocumentoProveedor = c.Proveedor?.NumeroDocumento,
            NombreTipoDocumentoProveedor = c.NombreTipoDocumentoProveedor,
            IdTipoDocumentoProveedor = c.IdTipoDocumentoProveedor,
            Detalles = c.Detalles?.Select(d => new DetalleCompraDto
            {
                Id = d.Id,
                IdProducto = d.IdProducto,
                NombreProducto = d.Descripcion, // El repo puso el nombre en Descripcion
                IdVariante = d.IdVariante,
                Descripcion = d.Descripcion,
                Cantidad = d.Cantidad,
                PrecioUnitarioCompra = d.PrecioUnitarioCompra,
                Subtotal = d.Subtotal,
                AfectacionIgv = d.AfectacionIgv
            }).ToList() ?? new()
        };
    }
}
