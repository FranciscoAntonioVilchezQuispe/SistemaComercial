using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SincronizacionTotalMovimientos : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='codigo_operacion_sunat') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN codigo_operacion_sunat varchar(10) NOT NULL DEFAULT '';
                END IF;
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='numero_documento') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN numero_documento varchar(20) NOT NULL DEFAULT '';
                END IF;
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='serie_documento') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN serie_documento varchar(10) NOT NULL DEFAULT '';
                END IF;
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='tipo_documento') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN tipo_documento varchar(2) NOT NULL DEFAULT '';
                END IF;
            END $$;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "codigo_operacion_sunat",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "numero_documento",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "serie_documento",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "tipo_documento",
                schema: "inventario",
                table: "movimientos_inventario");
        }
    }
}
