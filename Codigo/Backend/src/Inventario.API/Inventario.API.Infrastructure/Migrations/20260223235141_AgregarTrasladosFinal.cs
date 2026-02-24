using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AgregarTrasladosFinal : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "activado",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.DropColumn(
                name: "usuario_modificacion",
                schema: "inventario",
                table: "movimientos_inventario");

            migrationBuilder.CreateTable(
                name: "traslados",
                schema: "inventario",
                columns: table => new
                {
                    id_traslado = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    numero_traslado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    almacen_origen_id = table.Column<long>(type: "bigint", nullable: false),
                    almacen_destino_id = table.Column<long>(type: "bigint", nullable: false),
                    fecha_pedido = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    fecha_despacho = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    fecha_recepcion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    gr_serie = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    gr_numero = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    id_usuario_despacho = table.Column<long>(type: "bigint", nullable: true),
                    id_usuario_recepcion = table.Column<long>(type: "bigint", nullable: true),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_traslados", x => x.id_traslado);
                });

            migrationBuilder.CreateTable(
                name: "traslados_detalle",
                schema: "inventario",
                columns: table => new
                {
                    id_detalle_traslado = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_traslado = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    cantidad_solicitada = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    cantidad_despachada = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    cantidad_recibida = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    costo_unitario_despacho = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    observaciones = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_traslados_detalle", x => x.id_detalle_traslado);
                    table.ForeignKey(
                        name: "fk_traslados_detalle_traslados_id_traslado",
                        column: x => x.id_traslado,
                        principalSchema: "inventario",
                        principalTable: "traslados",
                        principalColumn: "id_traslado",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_traslados_numero_traslado",
                schema: "inventario",
                table: "traslados",
                column: "numero_traslado",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_traslados_detalle_id_traslado",
                schema: "inventario",
                table: "traslados_detalle",
                column: "id_traslado");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "traslados_detalle",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "traslados",
                schema: "inventario");

            migrationBuilder.AddColumn<bool>(
                name: "activado",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "timestamp without time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "usuario_modificacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true);
        }
    }
}
