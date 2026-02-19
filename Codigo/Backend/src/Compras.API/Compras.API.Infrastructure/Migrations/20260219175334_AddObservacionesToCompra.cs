using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddObservacionesToCompra : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "observaciones",
                schema: "compras",
                table: "compras",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "observaciones",
                schema: "compras",
                table: "compras");

            migrationBuilder.EnsureSchema(
                name: "configuracion");
        }
    }
}
