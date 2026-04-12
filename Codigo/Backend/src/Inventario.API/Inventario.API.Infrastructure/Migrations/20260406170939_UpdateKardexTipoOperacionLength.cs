using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateKardexTipoOperacionLength : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Drop columns from traslados safely
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='traslados' AND column_name='activado') THEN
                    ALTER TABLE inventario.traslados DROP COLUMN activado;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='traslados' AND column_name='fecha_creacion') THEN
                    ALTER TABLE inventario.traslados DROP COLUMN fecha_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='traslados' AND column_name='fecha_modificacion') THEN
                    ALTER TABLE inventario.traslados DROP COLUMN fecha_modificacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='traslados' AND column_name='usuario_creacion') THEN
                    ALTER TABLE inventario.traslados DROP COLUMN usuario_creacion;
                END IF;
                IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='traslados' AND column_name='usuario_modificacion') THEN
                    ALTER TABLE inventario.traslados DROP COLUMN usuario_modificacion;
                END IF;
            END $$;");

            // Add id_tabla to configuracion.tablas_generales_detalle safely
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='configuracion' AND table_name='tablas_generales_detalle' AND column_name='id_tabla') THEN
                    ALTER TABLE configuracion.tablas_generales_detalle ADD COLUMN id_tabla integer NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // Alter Columns safely (Character varying length increases)
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                ALTER TABLE inventario.movimientos_inventario ALTER COLUMN usuario_creacion TYPE varchar(100);
                ALTER TABLE inventario.inv_kardex_movimiento ALTER COLUMN usuario_modificacion TYPE varchar(100);
                ALTER TABLE inventario.inv_kardex_movimiento ALTER COLUMN usuario_creacion TYPE varchar(100);
                ALTER TABLE inventario.inv_kardex_movimiento ALTER COLUMN tipo_operacion TYPE varchar(10);
                ALTER TABLE inventario.inv_kardex_movimiento ALTER COLUMN motivo_traslado_sunat TYPE varchar(4);
                ALTER TABLE inventario.inv_kardex_lote ALTER COLUMN usuario_modificacion TYPE varchar(100);
                ALTER TABLE inventario.inv_kardex_lote ALTER COLUMN usuario_creacion TYPE varchar(100);
            EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Some AlterColumns failed or already applied';
            END $$;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "id_tabla",
                schema: "configuracion",
                table: "tablas_generales_detalle");

            migrationBuilder.AddColumn<bool>(
                name: "activado",
                schema: "inventario",
                table: "traslados",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "traslados",
                type: "timestamp without time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "traslados",
                type: "timestamp without time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "usuario_creacion",
                schema: "inventario",
                table: "traslados",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "usuario_modificacion",
                schema: "inventario",
                table: "traslados",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "tipo_operacion",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                type: "character varying(1)",
                maxLength: 1,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(10)",
                oldMaxLength: 10);

            migrationBuilder.AlterColumn<string>(
                name: "motivo_traslado_sunat",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                type: "character varying(2)",
                maxLength: 2,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(4)",
                oldMaxLength: 4);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "inventario",
                table: "inv_kardex_lote",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "inventario",
                table: "inv_kardex_lote",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);
        }
    }
}
