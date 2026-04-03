using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RemoveRedundantNotas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "detalle_notas",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "notas",
                schema: "ventas");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "notas",
                schema: "ventas",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_venta_referencia = table.Column<long>(type: "bigint", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    codigo_motivo = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: true),
                    codigo_tipo_comprobante_ref = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    descripcion_motivo = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    id_estado = table.Column<long>(type: "bigint", nullable: false),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    id_tipo_nota = table.Column<long>(type: "bigint", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    numero = table.Column<long>(type: "bigint", nullable: false),
                    numero_ref = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    serie = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    serie_ref = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    subtotal_gravado = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: false),
                    total_impuesto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_nota = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_notas", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_notas_ventas_id_venta_referencia",
                        column: x => x.id_venta_referencia,
                        principalSchema: "ventas",
                        principalTable: "ventas",
                        principalColumn: "id_venta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_notas",
                schema: "ventas",
                columns: table => new
                {
                    id_detalle_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota = table.Column<long>(type: "bigint", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    impuesto_item = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_item = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_notas", x => x.id_detalle_nota);
                    table.ForeignKey(
                        name: "fk_detalle_notas_notas_id_nota",
                        column: x => x.id_nota,
                        principalSchema: "ventas",
                        principalTable: "notas",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_detalle_notas_id_nota",
                schema: "ventas",
                table: "detalle_notas",
                column: "id_nota");

            migrationBuilder.CreateIndex(
                name: "ix_notas_id_venta_referencia",
                schema: "ventas",
                table: "notas",
                column: "id_venta_referencia");
        }
    }
}
