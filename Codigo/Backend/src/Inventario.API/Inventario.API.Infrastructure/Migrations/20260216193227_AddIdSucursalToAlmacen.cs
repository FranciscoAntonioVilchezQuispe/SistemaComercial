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
            migrationBuilder.AddColumn<decimal>(
                name: "costo_promedio",
                schema: "inventario",
                table: "stock",
                type: "numeric(12,4)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "valor_total",
                schema: "inventario",
                table: "stock",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "costo_promedio_actual",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "numeric(12,4)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "saldo_cantidad",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "numeric(10,3)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "saldo_valorizado",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<long>(
                name: "id_sucursal",
                schema: "inventario",
                table: "almacenes",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);
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
