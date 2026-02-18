using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddModuleFlagsToTipoComprobante : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "es_compra",
                schema: "configuracion",
                table: "tipo_comprobante",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_orden_compra",
                schema: "configuracion",
                table: "tipo_comprobante",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_venta",
                schema: "configuracion",
                table: "tipo_comprobante",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "es_compra",
                schema: "configuracion",
                table: "tipo_comprobante");

            migrationBuilder.DropColumn(
                name: "es_orden_compra",
                schema: "configuracion",
                table: "tipo_comprobante");

            migrationBuilder.DropColumn(
                name: "es_venta",
                schema: "configuracion",
                table: "tipo_comprobante");
        }
    }
}
