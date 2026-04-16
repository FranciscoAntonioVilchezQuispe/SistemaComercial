using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Add_TurnoVendedor_CierreTurno : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_turno_vendedor",
                schema: "ventas",
                table: "ventas",
                type: "bigint",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "turno_vendedor",
                schema: "ventas",
                columns: table => new
                {
                    id_turno_vendedor = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario_vendedor = table.Column<long>(type: "bigint", nullable: false),
                    id_caja = table.Column<long>(type: "bigint", nullable: false),
                    fecha_inicio = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_fin = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    monto_apertura = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    monto_cierre = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_turno_vendedor", x => x.id_turno_vendedor);
                    table.ForeignKey(
                        name: "fk_turno_vendedor_cajas_id_caja",
                        column: x => x.id_caja,
                        principalSchema: "ventas",
                        principalTable: "cajas",
                        principalColumn: "id_caja",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "cierre_turno",
                schema: "ventas",
                columns: table => new
                {
                    id_cierre_turno = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_turno_vendedor = table.Column<long>(type: "bigint", nullable: false),
                    fecha_generacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    total_ventas = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_efectivo = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_tarjeta = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_transferencia = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_otros = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    cantidad_transacciones = table.Column<int>(type: "integer", nullable: false),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cierre_turno", x => x.id_cierre_turno);
                    table.ForeignKey(
                        name: "fk_cierre_turno_turno_vendedor_id_turno_vendedor",
                        column: x => x.id_turno_vendedor,
                        principalSchema: "ventas",
                        principalTable: "turno_vendedor",
                        principalColumn: "id_turno_vendedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_ventas_id_turno_vendedor",
                schema: "ventas",
                table: "ventas",
                column: "id_turno_vendedor");

            migrationBuilder.CreateIndex(
                name: "ix_cierre_turno_id_turno_vendedor",
                schema: "ventas",
                table: "cierre_turno",
                column: "id_turno_vendedor",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_turno_vendedor_id_caja",
                schema: "ventas",
                table: "turno_vendedor",
                column: "id_caja");

            migrationBuilder.AddForeignKey(
                name: "fk_ventas_turno_vendedor_id_turno_vendedor",
                schema: "ventas",
                table: "ventas",
                column: "id_turno_vendedor",
                principalSchema: "ventas",
                principalTable: "turno_vendedor",
                principalColumn: "id_turno_vendedor");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_ventas_turno_vendedor_id_turno_vendedor",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropTable(
                name: "cierre_turno",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "turno_vendedor",
                schema: "ventas");

            migrationBuilder.DropIndex(
                name: "ix_ventas_id_turno_vendedor",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "id_turno_vendedor",
                schema: "ventas",
                table: "ventas");
        }
    }
}
