using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migraciones
{
    /// <inheritdoc />
    public partial class AddTraceabilityAndStatesV1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "estado_sunat",
                schema: "compras",
                table: "compras",
                newName: "id_estado_sunat");

            migrationBuilder.AddColumn<long>(
                name: "id_nota_credito",
                schema: "compras",
                table: "compras",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "id_nota_debito",
                schema: "compras",
                table: "compras",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "tipo_anulacion",
                schema: "compras",
                table: "compras",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "id_nota_credito",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "id_nota_debito",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "tipo_anulacion",
                schema: "compras",
                table: "compras");

            migrationBuilder.RenameColumn(
                name: "id_estado_sunat",
                schema: "compras",
                table: "compras",
                newName: "estado_sunat");
        }
    }
}
