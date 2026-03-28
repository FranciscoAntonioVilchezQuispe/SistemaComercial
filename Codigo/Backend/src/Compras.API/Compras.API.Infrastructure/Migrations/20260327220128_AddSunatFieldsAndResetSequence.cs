using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSunatFieldsAndResetSequence : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // --- SQL Manual: Asegurar existencia de columnas de auditoría (necesario por baselining) ---
            migrationBuilder.Sql(@"
                DO $$
                DECLARE
                    t text;
                BEGIN
                    FOR t IN SELECT unnest(ARRAY['proveedores', 'ordenes_compra', 'notas', 'compras', 'detalle_compra', 'detalle_orden_compra', 'detalle_notas'])
                    LOOP
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='fecha_creacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN fecha_creacion timestamp with time zone NOT NULL DEFAULT now()', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='usuario_creacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN usuario_creacion varchar(50) NOT NULL DEFAULT ''SISTEMA''', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='fecha_modificacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN fecha_modificacion timestamp with time zone', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='usuario_modificacion') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN usuario_modificacion varchar(50)', t);
                        END IF;
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name=t AND column_name='activado') THEN
                            EXECUTE format('ALTER TABLE compras.%I ADD COLUMN activado boolean NOT NULL DEFAULT true', t);
                        END IF;
                    END LOOP;
                END $$;
            ");

            migrationBuilder.AddColumn<string>(
                name: "condicion_sunat",
                schema: "compras",
                table: "proveedores",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "es_agente_percepcion",
                schema: "compras",
                table: "proveedores",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_agente_retencion",
                schema: "compras",
                table: "proveedores",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_buen_contribuyente",
                schema: "compras",
                table: "proveedores",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "estado_sunat",
                schema: "compras",
                table: "proveedores",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_ultima_consulta_sunat",
                schema: "compras",
                table: "proveedores",
                type: "timestamp without time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ubigeo",
                schema: "compras",
                table: "proveedores",
                type: "character varying(6)",
                maxLength: 6,
                nullable: true);

            // --- SQL Manual: Reseteo de secuencia e Índices SUNAT ---
            migrationBuilder.Sql(@"
                DO $$
                BEGIN
                    -- Reseteo de secuencia para evitar error 23505 (llave duplicada)
                    PERFORM setval('compras.proveedores_id_proveedor_seq', (SELECT COALESCE(MAX(id_proveedor), 0) FROM compras.proveedores) + 1);
                END $$;
            ");

            migrationBuilder.Sql(@"
                CREATE UNIQUE INDEX IF NOT EXISTS uq_proveedores_numero_documento 
                ON compras.proveedores(numero_documento) WHERE activado = true;
                
                -- Índice GIN para búsqueda rápida por razón social (requiere pg_trgm o to_tsvector)
                CREATE INDEX IF NOT EXISTS idx_proveedores_razon_social 
                ON compras.proveedores USING gin(to_tsvector('spanish', razon_social));
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "condicion_sunat",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "es_agente_percepcion",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "es_agente_retencion",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "es_buen_contribuyente",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "estado_sunat",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "fecha_ultima_consulta_sunat",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "ubigeo",
                schema: "compras",
                table: "proveedores");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "proveedores",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "proveedores",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_entrega_estimada",
                schema: "compras",
                table: "ordenes_compra",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_emision",
                schema: "compras",
                table: "ordenes_compra",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "notas",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_emision",
                schema: "compras",
                table: "notas",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "notas",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "detalle_notas",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "detalle_notas",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "detalle_compra",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "detalle_compra",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_vencimiento",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_emision",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_contable",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");
        }
    }
}
