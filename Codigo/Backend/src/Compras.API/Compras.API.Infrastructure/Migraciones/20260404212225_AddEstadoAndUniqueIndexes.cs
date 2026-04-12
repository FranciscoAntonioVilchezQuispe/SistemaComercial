using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migraciones
{
    /// <inheritdoc />
    public partial class AddEstadoAndUniqueIndexes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_estado",
                schema: "compras",
                table: "compras",
                type: "bigint",
                nullable: false,
                defaultValue: 60L);

            
            migrationBuilder.CreateIndex(
                name: "idx_compra_unico_serie_numero",
                schema: "compras",
                table: "compras",
                columns: new[] { "serie_comprobante", "numero_comprobante", "id_proveedor" },
                unique: true,
                filter: "activado = true AND id_estado != 61");

            migrationBuilder.CreateIndex(
                name: "idx_nota_credito_compra_unico_serie_numero",
                schema: "compras",
                table: "nota_credito",
                columns: new[] { "serie", "numero", "id_proveedor" },
                unique: true,
                filter: "activado = true AND id_estado != 61");

            migrationBuilder.CreateIndex(
                name: "idx_nota_debito_compra_unico_serie_numero",
                schema: "compras",
                table: "nota_debito",
                columns: new[] { "serie", "numero", "id_proveedor" },
                unique: true,
                filter: "activado = true AND id_estado != 61");
            
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "idx_compra_unico_serie_numero",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropIndex(
                name: "idx_nota_credito_compra_unico_serie_numero",
                schema: "compras",
                table: "nota_credito");

            migrationBuilder.DropIndex(
                name: "idx_nota_debito_compra_unico_serie_numero",
                schema: "compras",
                table: "nota_debito");

            migrationBuilder.DropColumn(
                name: "id_estado",
                schema: "compras",
                table: "nota_debito");

            migrationBuilder.DropColumn(
                name: "id_estado",
                schema: "compras",
                table: "nota_credito");

            migrationBuilder.DropColumn(
                name: "id_estado",
                schema: "compras",
                table: "compras");
        }
    }
}
