using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Catalogo.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AsociacionSunatProducto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_afectacion_igv",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<long>(
                name: "id_tipo_tributo",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "id_afectacion_igv",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropColumn(
                name: "id_tipo_tributo",
                schema: "catalogo",
                table: "productos");
        }
    }
}
