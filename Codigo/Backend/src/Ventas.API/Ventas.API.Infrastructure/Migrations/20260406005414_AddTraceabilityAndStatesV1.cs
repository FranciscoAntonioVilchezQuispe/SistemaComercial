using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddTraceabilityAndStatesV1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_nota_credito",
                schema: "ventas",
                table: "ventas",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "id_nota_debito",
                schema: "ventas",
                table: "ventas",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "tipo_anulacion",
                schema: "ventas",
                table: "ventas",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "id_nota_credito",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "id_nota_debito",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "tipo_anulacion",
                schema: "ventas",
                table: "ventas");
        }
    }
}
