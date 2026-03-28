using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class NormalizarSucursal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Limpieza agresiva de PKs existentes (buscando el nombre real en el catálogo de Postgres)
            migrationBuilder.Sql(@"
                DO $$
                DECLARE
                    r RECORD;
                BEGIN
                    -- Para sucursales (o sucursal si aún no se renombró)
                    FOR r IN SELECT conname, n.nspname, t.relname 
                             FROM pg_constraint c 
                             JOIN pg_class t ON c.conrelid = t.oid 
                             JOIN pg_namespace n ON t.relnamespace = n.oid 
                             WHERE c.contype = 'p' AND n.nspname = 'configuracion' AND t.relname IN ('sucursal', 'sucursales')
                    LOOP
                        EXECUTE 'ALTER TABLE ' || quote_ident(r.nspname) || '.' || quote_ident(r.relname) || ' DROP CONSTRAINT ' || quote_ident(r.conname);
                    END LOOP;

                    -- Para impuestos (o impuesto)
                    FOR r IN SELECT conname, n.nspname, t.relname 
                             FROM pg_constraint c 
                             JOIN pg_class t ON c.conrelid = t.oid 
                             JOIN pg_namespace n ON t.relnamespace = n.oid 
                             WHERE c.contype = 'p' AND n.nspname = 'configuracion' AND t.relname IN ('impuesto', 'impuestos')
                    LOOP
                        EXECUTE 'ALTER TABLE ' || quote_ident(r.nspname) || '.' || quote_ident(r.relname) || ' DROP CONSTRAINT ' || quote_ident(r.conname);
                    END LOOP;
                END $$;
            ");

            migrationBuilder.DropColumn(
                name: "activo",
                schema: "configuracion",
                table: "tipo_operacion_sunat");

            migrationBuilder.DropColumn(
                name: "activo",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            // Renombrado defensivo de tablas (solo si existen con el nombre antiguo)
            migrationBuilder.Sql(@"
                DO $$
                BEGIN
                    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'configuracion' AND table_name = 'sucursal') THEN
                        ALTER TABLE configuracion.sucursal RENAME TO sucursales;
                    END IF;
                    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'configuracion' AND table_name = 'impuesto') THEN
                        ALTER TABLE configuracion.impuesto RENAME TO impuestos;
                    END IF;
                END $$;
            ");

            /* El DDL ya tiene la columna como 'nombre'
            migrationBuilder.RenameColumn(
                name: "nombre_sucursal",
                schema: "configuracion",
                table: "sucursales",
                newName: "nombre");
            */

            /*
            migrationBuilder.RenameIndex(
                name: "ix_sucursal_id_empresa",
                schema: "configuracion",
                table: "sucursales",
                newName: "ix_sucursales_id_empresa");
            */

            /* El DDL de impuestos parece ya tener los nombres correctos
            migrationBuilder.RenameColumn(
                name: "codigo",
                schema: "configuracion",
                table: "impuestos",
                newName: "codigo_sunat");

            migrationBuilder.RenameColumn(
                name: "es_igv",
                schema: "configuracion",
                table: "impuestos",
                newName: "es_porcentaje");
            */

            migrationBuilder.Sql(@"
                DO $$
                BEGIN
                    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_documento' AND column_name = 'es_documento_identidad') THEN
                        ALTER TABLE configuracion.tipo_documento ADD COLUMN es_documento_identidad boolean DEFAULT false NOT NULL;
                    END IF;
                    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_documento' AND column_name = 'es_documento_relacionado') THEN
                        ALTER TABLE configuracion.tipo_documento ADD COLUMN es_documento_relacionado boolean DEFAULT false NOT NULL;
                    END IF;
                END $$;
            ");

            /* El DDL ya tiene la columna 'codigo'
            migrationBuilder.AddColumn<string>(
                name: "codigo",
                schema: "configuracion",
                table: "sucursales",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");
            */

            migrationBuilder.Sql(@"
                DO $$
                BEGIN
                    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = 'configuracion' AND constraint_name = 'pk_sucursales') THEN
                        ALTER TABLE configuracion.sucursales ADD CONSTRAINT pk_sucursales PRIMARY KEY (id_sucursal);
                    END IF;
                    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = 'configuracion' AND constraint_name = 'pk_impuestos') THEN
                        ALTER TABLE configuracion.impuestos ADD CONSTRAINT pk_impuestos PRIMARY KEY (id_impuesto);
                    END IF;
                    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_schema = 'configuracion' AND constraint_name = 'fk_sucursales_empresa_id_empresa') THEN
                        ALTER TABLE configuracion.sucursales ADD CONSTRAINT fk_sucursales_empresa_id_empresa FOREIGN KEY (id_empresa) 
                        REFERENCES configuracion.empresa (id_empresa) ON DELETE RESTRICT;
                    END IF;
                END $$;
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_sucursales_empresa_id_empresa",
                schema: "configuracion",
                table: "sucursales");

            migrationBuilder.DropPrimaryKey(
                name: "pk_sucursales",
                schema: "configuracion",
                table: "sucursales");

            migrationBuilder.DropPrimaryKey(
                name: "pk_impuestos",
                schema: "configuracion",
                table: "impuestos");

            migrationBuilder.DropColumn(
                name: "es_documento_identidad",
                schema: "configuracion",
                table: "tipo_documento");

            migrationBuilder.DropColumn(
                name: "es_documento_relacionado",
                schema: "configuracion",
                table: "tipo_documento");

            migrationBuilder.DropColumn(
                name: "codigo",
                schema: "configuracion",
                table: "sucursales");

            migrationBuilder.RenameTable(
                name: "sucursales",
                schema: "configuracion",
                newName: "sucursal",
                newSchema: "configuracion");

            migrationBuilder.RenameTable(
                name: "impuestos",
                schema: "configuracion",
                newName: "impuesto",
                newSchema: "configuracion");

            migrationBuilder.RenameColumn(
                name: "nombre",
                schema: "configuracion",
                table: "sucursal",
                newName: "nombre_sucursal");

            migrationBuilder.RenameIndex(
                name: "ix_sucursales_id_empresa",
                schema: "configuracion",
                table: "sucursal",
                newName: "ix_sucursal_id_empresa");

            migrationBuilder.RenameColumn(
                name: "codigo_sunat",
                schema: "configuracion",
                table: "impuesto",
                newName: "codigo");

            migrationBuilder.RenameColumn(
                name: "es_porcentaje",
                schema: "configuracion",
                table: "impuesto",
                newName: "es_igv");

            migrationBuilder.AddColumn<bool>(
                name: "activo",
                schema: "configuracion",
                table: "tipo_operacion_sunat",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "activo",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddPrimaryKey(
                name: "pk_sucursal",
                schema: "configuracion",
                table: "sucursal",
                column: "id_sucursal");

            migrationBuilder.AddPrimaryKey(
                name: "pk_impuesto",
                schema: "configuracion",
                table: "impuesto",
                column: "id_impuesto");

            migrationBuilder.AddForeignKey(
                name: "fk_sucursal_empresa_id_empresa",
                schema: "configuracion",
                table: "sucursal",
                column: "id_empresa",
                principalSchema: "configuracion",
                principalTable: "empresa",
                principalColumn: "id_empresa",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
