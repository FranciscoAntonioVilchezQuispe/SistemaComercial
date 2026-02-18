using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSerieNumeroCorrelativoToOrdenCompra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_tipo_comprobante",
                schema: "compras",
                table: "ordenes_compra",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "numero",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "serie",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "id_tipo_comprobante",
                schema: "compras",
                table: "ordenes_compra");

            migrationBuilder.DropColumn(
                name: "numero",
                schema: "compras",
                table: "ordenes_compra");

            migrationBuilder.DropColumn(
                name: "serie",
                schema: "compras",
                table: "ordenes_compra");
        }
    }
}
