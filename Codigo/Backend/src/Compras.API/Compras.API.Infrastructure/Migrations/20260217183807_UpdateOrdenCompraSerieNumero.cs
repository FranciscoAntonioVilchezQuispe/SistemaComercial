using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateOrdenCompraSerieNumero : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "notas",
                schema: "compras",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_compra_referencia = table.Column<long>(type: "bigint", nullable: false),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    serie_comprobante = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero_comprobante = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    impuesto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_notas", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_notas_compras_id_compra_referencia",
                        column: x => x.id_compra_referencia,
                        principalSchema: "compras",
                        principalTable: "compras",
                        principalColumn: "id_compra",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_notas",
                schema: "compras",
                columns: table => new
                {
                    id_detalle_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_notas", x => x.id_detalle_nota);
                    table.ForeignKey(
                        name: "fk_detalle_notas_notas_id_nota",
                        column: x => x.id_nota,
                        principalSchema: "compras",
                        principalTable: "notas",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_detalle_notas_id_nota",
                schema: "compras",
                table: "detalle_notas",
                column: "id_nota");

            migrationBuilder.CreateIndex(
                name: "ix_notas_id_compra_referencia",
                schema: "compras",
                table: "notas",
                column: "id_compra_referencia");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "detalle_notas",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "notas",
                schema: "compras");
        }
    }
}
