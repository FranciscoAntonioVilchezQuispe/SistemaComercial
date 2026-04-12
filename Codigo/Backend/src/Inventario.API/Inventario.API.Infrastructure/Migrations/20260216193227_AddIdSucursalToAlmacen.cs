using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddIdSucursalToAlmacen : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // costo_promedio en stock
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='stock' AND column_name='costo_promedio') THEN
                    ALTER TABLE inventario.stock ADD COLUMN costo_promedio numeric(12,4) NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // valor_total en stock
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='stock' AND column_name='valor_total') THEN
                    ALTER TABLE inventario.stock ADD COLUMN valor_total numeric(12,2) NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // costo_promedio_actual en movimientos_inventario
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='costo_promedio_actual') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN costo_promedio_actual numeric(12,4) NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // saldo_cantidad en movimientos_inventario
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='saldo_cantidad') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN saldo_cantidad numeric(10,3) NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // saldo_valorizado en movimientos_inventario
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='movimientos_inventario' AND column_name='saldo_valorizado') THEN
                    ALTER TABLE inventario.movimientos_inventario ADD COLUMN saldo_valorizado numeric(12,2) NOT NULL DEFAULT 0;
                END IF;
            END $$;");

            // id_sucursal en almacenes
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='almacenes' AND column_name='id_sucursal') THEN
                    ALTER TABLE inventario.almacenes ADD COLUMN id_sucursal bigint NOT NULL DEFAULT 0;
                END IF;
            END $$;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "costo_promedio",
                schema: "inventario",
                table: "stock");

            migrationBuilder.DropColumn(
                name: "valor_total",
                schema: "inventario",
                table: "stock");

            migrationBuilder.DropColumn(
                name: "costo_promedio_actual",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "saldo_cantidad",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "saldo_valorizado",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "id_sucursal",
                schema: "inventario",
                table: "almacenes");
        }
    }
}
