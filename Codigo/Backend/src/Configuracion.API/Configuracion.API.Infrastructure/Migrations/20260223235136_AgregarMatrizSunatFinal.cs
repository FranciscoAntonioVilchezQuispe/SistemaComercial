using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AgregarMatrizSunatFinal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "codigo_documento",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropColumn(
                name: "codigo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.AddColumn<long>(
                name: "id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.AddColumn<long>(
                name: "id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.CreateTable(
                name: "tipo_operacion_sunat",
                schema: "configuracion",
                columns: table => new
                {
                    id_tipo_operacion = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    nombre = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    activo = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tipo_operacion_sunat", x => x.id_tipo_operacion);
                });

            migrationBuilder.CreateIndex(
                name: "ix_matriz_regla_sunat_id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                column: "id_tipo_comprobante");

            migrationBuilder.CreateIndex(
                name: "ix_matriz_regla_sunat_id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                column: "id_tipo_operacion");

            migrationBuilder.AddForeignKey(
                name: "fk_matriz_regla_sunat_tipo_comprobante_id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                column: "id_tipo_comprobante",
                principalSchema: "configuracion",
                principalTable: "tipo_comprobante",
                principalColumn: "id_tipo_comprobante",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "fk_matriz_regla_sunat_tipo_operacion_sunat_id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                column: "id_tipo_operacion",
                principalSchema: "configuracion",
                principalTable: "tipo_operacion_sunat",
                principalColumn: "id_tipo_operacion",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_matriz_regla_sunat_tipo_comprobante_id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropForeignKey(
                name: "fk_matriz_regla_sunat_tipo_operacion_sunat_id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropTable(
                name: "tipo_operacion_sunat",
                schema: "configuracion");

            migrationBuilder.DropIndex(
                name: "ix_matriz_regla_sunat_id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropIndex(
                name: "ix_matriz_regla_sunat_id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropColumn(
                name: "id_tipo_comprobante",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.DropColumn(
                name: "id_tipo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat");

            migrationBuilder.AddColumn<string>(
                name: "codigo_documento",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                type: "character varying(2)",
                maxLength: 2,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "codigo_operacion",
                schema: "configuracion",
                table: "matriz_regla_sunat",
                type: "character varying(2)",
                maxLength: 2,
                nullable: false,
                defaultValue: "");
        }
    }
}
