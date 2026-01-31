using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Inicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            /*
            migrationBuilder.EnsureSchema(
                name: "inventario");

            migrationBuilder.EnsureSchema(
                name: "configuracion");

            migrationBuilder.CreateTable(
                name: "almacenes",
                schema: "inventario",
                columns: table => new
                {
                    id_almacen = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_almacen = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    direccion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    es_principal = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_almacenes", x => x.id_almacen);
                });

            migrationBuilder.CreateTable(
                name: "tablas_generales_detalle",
                schema: "configuracion",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo = table.Column<string>(type: "text", nullable: false),
                    nombre = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tablas_generales_detalle", x => x.id_detalle);
                });

            migrationBuilder.CreateTable(
                name: "stock",
                schema: "inventario",
                columns: table => new
                {
                    id_stock = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    id_almacen = table.Column<long>(type: "bigint", nullable: false),
                    cantidad_actual = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    cantidad_reservada = table.Column<decimal>(type: "numeric(10,3)", nullable: true),
                    ubicacion_fisica = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_stock", x => x.id_stock);
                    table.ForeignKey(
                        name: "fk_stock_almacenes_id_almacen",
                        column: x => x.id_almacen,
                        principalSchema: "inventario",
                        principalTable: "almacenes",
                        principalColumn: "id_almacen",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "movimientos_inventario",
                schema: "inventario",
                columns: table => new
                {
                    id_movimiento = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tipo_movimiento = table.Column<long>(type: "bigint", nullable: false),
                    id_stock = table.Column<long>(type: "bigint", nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    cantidad_anterior = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    cantidad_nueva = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    costo_unitario_movimiento = table.Column<decimal>(type: "numeric(12,4)", nullable: true),
                    referencia_modulo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    id_referencia = table.Column<long>(type: "bigint", nullable: true),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_movimientos_inventario", x => x.id_movimiento);
                    table.ForeignKey(
                        name: "fk_movimientos_inventario_stock_id_stock",
                        column: x => x.id_stock,
                        principalSchema: "inventario",
                        principalTable: "stock",
                        principalColumn: "id_stock",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_movimientos_inventario_id_stock",
                schema: "inventario",
                table: "movimientos_inventario",
                column: "id_stock");

            migrationBuilder.CreateIndex(
                name: "ix_stock_id_almacen",
                schema: "inventario",
                table: "stock",
                column: "id_almacen");
            */
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "movimientos_inventario",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "stock",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "almacenes",
                schema: "inventario");
        }
    }
}
