using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Inicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "compras");

            migrationBuilder.EnsureSchema(
                name: "configuracion");

            migrationBuilder.CreateTable(
                name: "proveedores",
                schema: "compras",
                columns: table => new
                {
                    id_proveedor = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tipo_documento = table.Column<long>(type: "bigint", nullable: false),
                    numero_documento = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    razon_social = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    nombre_comercial = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    direccion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    telefono = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    pagina_web = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_proveedores", x => x.id_proveedor);
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
                name: "compras",
                schema: "compras",
                columns: table => new
                {
                    id_compra = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_proveedor = table.Column<long>(type: "bigint", nullable: false),
                    id_almacen = table.Column<long>(type: "bigint", nullable: false),
                    id_orden_compra_ref = table.Column<long>(type: "bigint", nullable: true),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    serie_comprobante = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero_comprobante = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_contable = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    impuesto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    saldo_pendiente = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    id_estado_pago = table.Column<long>(type: "bigint", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_compras", x => x.id_compra);
                    table.ForeignKey(
                        name: "fk_compras_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalSchema: "compras",
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ordenes_compra",
                schema: "compras",
                columns: table => new
                {
                    id_orden_compra = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo_orden = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    id_proveedor = table.Column<long>(type: "bigint", nullable: false),
                    id_almacen_destino = table.Column<long>(type: "bigint", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_entrega_estimada = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    id_estado = table.Column<long>(type: "bigint", nullable: false),
                    total_importe = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_ordenes_compra", x => x.id_orden_compra);
                    table.ForeignKey(
                        name: "fk_ordenes_compra_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalSchema: "compras",
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_compra",
                schema: "compras",
                columns: table => new
                {
                    id_detalle_compra = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_compra = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    descripcion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    precio_unitario_compra = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_compra", x => x.id_detalle_compra);
                    table.ForeignKey(
                        name: "fk_detalle_compra_compras_id_compra",
                        column: x => x.id_compra,
                        principalSchema: "compras",
                        principalTable: "compras",
                        principalColumn: "id_compra",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_orden_compra",
                schema: "compras",
                columns: table => new
                {
                    id_detalle_oc = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_orden_compra = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    cantidad_solicitada = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    precio_unitario_pactado = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    cantidad_recibida = table.Column<decimal>(type: "numeric(10,3)", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_orden_compra", x => x.id_detalle_oc);
                    table.ForeignKey(
                        name: "fk_detalle_orden_compra_ordenes_compra_id_orden_compra",
                        column: x => x.id_orden_compra,
                        principalSchema: "compras",
                        principalTable: "ordenes_compra",
                        principalColumn: "id_orden_compra",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_compras_id_proveedor",
                schema: "compras",
                table: "compras",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_detalle_compra_id_compra",
                schema: "compras",
                table: "detalle_compra",
                column: "id_compra");

            migrationBuilder.CreateIndex(
                name: "ix_detalle_orden_compra_id_orden_compra",
                schema: "compras",
                table: "detalle_orden_compra",
                column: "id_orden_compra");

            migrationBuilder.CreateIndex(
                name: "ix_ordenes_compra_id_proveedor",
                schema: "compras",
                table: "ordenes_compra",
                column: "id_proveedor");

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "detalle_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "detalle_orden_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "compras",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "ordenes_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "proveedores",
                schema: "compras");
        }
    }
}
