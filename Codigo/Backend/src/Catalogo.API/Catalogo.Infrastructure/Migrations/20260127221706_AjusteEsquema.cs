using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Catalogo.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AjusteEsquema : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "catalogo");

            migrationBuilder.RenameTable(
                name: "unidades_medida",
                newName: "unidades_medida",
                newSchema: "catalogo");

            migrationBuilder.RenameTable(
                name: "productos",
                newName: "productos",
                newSchema: "catalogo");

            migrationBuilder.RenameTable(
                name: "marcas",
                newName: "marcas",
                newSchema: "catalogo");

            migrationBuilder.RenameTable(
                name: "categorias",
                newName: "categorias",
                newSchema: "catalogo");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameTable(
                name: "unidades_medida",
                schema: "catalogo",
                newName: "unidades_medida");

            migrationBuilder.RenameTable(
                name: "productos",
                schema: "catalogo",
                newName: "productos");

            migrationBuilder.RenameTable(
                name: "marcas",
                schema: "catalogo",
                newName: "marcas");

            migrationBuilder.RenameTable(
                name: "categorias",
                schema: "catalogo",
                newName: "categorias");
        }
    }
}
