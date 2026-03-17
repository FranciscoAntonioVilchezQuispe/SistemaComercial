using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateSunatFieldsCompras : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_detalle_compra_compras_id_compra",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropIndex(
                name: "ix_detalle_compra_id_compra",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.AddColumn<string>(
                name: "codigo_motivo",
                schema: "compras",
                table: "notas",
                type: "character varying(2)",
                maxLength: 2,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "codigo_tipo_comprobante_ref",
                schema: "compras",
                table: "notas",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "descripcion_motivo",
                schema: "compras",
                table: "notas",
                type: "character varying(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "numero_ref",
                schema: "compras",
                table: "notas",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "serie_ref",
                schema: "compras",
                table: "notas",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "afectacion_igv",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(2)",
                maxLength: 2,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(1)",
                oldMaxLength: 1);

            migrationBuilder.AddColumn<string>(
                name: "codigo_tributo",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(4)",
                maxLength: 4,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "descuento_item",
                schema: "compras",
                table: "detalle_compra",
                type: "numeric(12,4)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<long>(
                name: "id_comprao",
                schema: "compras",
                table: "detalle_compra",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.AddColumn<decimal>(
                name: "precio_unitario_base",
                schema: "compras",
                table: "detalle_compra",
                type: "numeric(12,4)",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "valor_item",
                schema: "compras",
                table: "detalle_compra",
                type: "numeric(12,4)",
                nullable: true);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_detalle_compra_compras_id_comprao",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropIndex(
                name: "ix_detalle_compra_id_comprao",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "codigo_motivo",
                schema: "compras",
                table: "notas");

            migrationBuilder.DropColumn(
                name: "codigo_tipo_comprobante_ref",
                schema: "compras",
                table: "notas");

            migrationBuilder.DropColumn(
                name: "descripcion_motivo",
                schema: "compras",
                table: "notas");

            migrationBuilder.DropColumn(
                name: "numero_ref",
                schema: "compras",
                table: "notas");

            migrationBuilder.DropColumn(
                name: "serie_ref",
                schema: "compras",
                table: "notas");

            migrationBuilder.DropColumn(
                name: "codigo_tributo",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "descuento_item",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "id_comprao",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "precio_unitario_base",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "valor_item",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.AlterColumn<string>(
                name: "afectacion_igv",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(1)",
                maxLength: 1,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(2)",
                oldMaxLength: 2);

            migrationBuilder.CreateIndex(
                name: "ix_detalle_compra_id_compra",
                schema: "compras",
                table: "detalle_compra",
                column: "id_compra");

            migrationBuilder.AddForeignKey(
                name: "fk_detalle_compra_compras_id_compra",
                schema: "compras",
                table: "detalle_compra",
                column: "id_compra",
                principalSchema: "compras",
                principalTable: "compras",
                principalColumn: "id_compra",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
