using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class FixTypoIdCompra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Migración baselined: los cambios ya existen en la base de datos.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_detalle_compra_compras_id_compra",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropIndex(
                name: "ix_detalle_compra_id_compra",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.AddColumn<long>(
                name: "id_comprao",
                schema: "compras",
                table: "detalle_compra",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateIndex(
                name: "ix_detalle_compra_id_comprao",
                schema: "compras",
                table: "detalle_compra",
                column: "id_comprao");

            migrationBuilder.AddForeignKey(
                name: "fk_detalle_compra_compras_id_comprao",
                schema: "compras",
                table: "detalle_compra",
                column: "id_comprao",
                principalSchema: "compras",
                principalTable: "compras",
                principalColumn: "id_compra",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
