using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddEstadoAndUniqueIndexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_estado",
                schema: "ventas",
                table: "nota_debito",
                type: "bigint",
                nullable: false,
                defaultValue: 60L);

            migrationBuilder.AddColumn<long>(
                name: "id_estado",
                schema: "ventas",
                table: "nota_credito",
                type: "bigint",
                nullable: false,
                defaultValue: 60L);

            migrationBuilder.CreateIndex(
                name: "idx_venta_unico_serie_numero",
                schema: "ventas",
                table: "ventas",
                columns: new[] { "serie", "numero" },
                unique: true,
                filter: "activado = true AND id_estado != 30");

            migrationBuilder.CreateIndex(
                name: "idx_nota_credito_unico_serie_numero",
                schema: "ventas",
                table: "nota_credito",
                columns: new[] { "serie", "numero" },
                unique: true,
                filter: "activado = true AND id_estado != 61");

            migrationBuilder.CreateIndex(
                name: "idx_nota_debito_unico_serie_numero",
                schema: "ventas",
                table: "nota_debito",
                columns: new[] { "serie", "numero" },
                unique: true,
                filter: "activado = true AND id_estado != 61");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "idx_venta_unico_serie_numero",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropIndex(
                name: "idx_nota_credito_unico_serie_numero",
                schema: "ventas",
                table: "nota_credito");

            migrationBuilder.DropIndex(
                name: "idx_nota_debito_unico_serie_numero",
                schema: "ventas",
                table: "nota_debito");

            migrationBuilder.DropColumn(
                name: "id_estado",
                schema: "ventas",
                table: "nota_debito");

            migrationBuilder.DropColumn(
                name: "id_estado",
                schema: "ventas",
                table: "nota_credito");
        }
    }
}
