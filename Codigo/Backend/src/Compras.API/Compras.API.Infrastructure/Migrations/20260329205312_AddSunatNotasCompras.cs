using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSunatNotasCompras : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "proveedores",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "proveedores",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "compras",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "compras",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AddColumn<string>(
                name: "estado_sunat",
                schema: "compras",
                table: "compras",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_anulacion",
                schema: "compras",
                table: "compras",
                type: "timestamp without time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "motivo_anulacion",
                schema: "compras",
                table: "compras",
                type: "text",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "nota_credito",
                schema: "compras",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    serie = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    tipo_comprobante = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_compra_referencia = table.Column<long>(type: "bigint", nullable: false),
                    serie_referencia = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero_referencia = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    tipo_doc_referencia = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_tipo_nota = table.Column<long>(type: "bigint", nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    id_proveedor = table.Column<long>(type: "bigint", nullable: false),
                    proveedor_tipo_doc = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    proveedor_nro_doc = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    proveedor_razon_social = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: true),
                    afecta_stock = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "date", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_credito", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_nota_credito_compras_id_compra_referencia",
                        column: x => x.id_compra_referencia,
                        principalSchema: "compras",
                        principalTable: "compras",
                        principalColumn: "id_compra",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_nota_credito_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalSchema: "compras",
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_debito",
                schema: "compras",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    serie = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    tipo_comprobante = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_compra_referencia = table.Column<long>(type: "bigint", nullable: false),
                    serie_referencia = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero_referencia = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    tipo_doc_referencia = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_tipo_nota = table.Column<long>(type: "bigint", nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    id_proveedor = table.Column<long>(type: "bigint", nullable: false),
                    proveedor_tipo_doc = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    proveedor_nro_doc = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    proveedor_razon_social = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: true),
                    afecta_stock = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "date", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_debito", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_nota_debito_compras_id_compra_referencia",
                        column: x => x.id_compra_referencia,
                        principalSchema: "compras",
                        principalTable: "compras",
                        principalColumn: "id_compra",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_nota_debito_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalSchema: "compras",
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_credito_detalle",
                schema: "compras",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota_credito = table.Column<long>(type: "bigint", nullable: false),
                    id_compra_detalle = table.Column<long>(type: "bigint", nullable: true),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    unidad_medida = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_credito_detalle", x => x.id_detalle);
                    table.ForeignKey(
                        name: "fk_nota_credito_detalle_detalle_compra_id_compra_detalle",
                        column: x => x.id_compra_detalle,
                        principalSchema: "compras",
                        principalTable: "detalle_compra",
                        principalColumn: "id_detalle_compra");
                    table.ForeignKey(
                        name: "fk_nota_credito_detalle_nota_credito_id_nota_credito",
                        column: x => x.id_nota_credito,
                        principalSchema: "compras",
                        principalTable: "nota_credito",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_debito_detalle",
                schema: "compras",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota_debito = table.Column<long>(type: "bigint", nullable: false),
                    id_compra_detalle = table.Column<long>(type: "bigint", nullable: true),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    unidad_medida = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_debito_detalle", x => x.id_detalle);
                    table.ForeignKey(
                        name: "fk_nota_debito_detalle_detalle_compra_id_compra_detalle",
                        column: x => x.id_compra_detalle,
                        principalSchema: "compras",
                        principalTable: "detalle_compra",
                        principalColumn: "id_detalle_compra");
                    table.ForeignKey(
                        name: "fk_nota_debito_detalle_nota_debito_id_nota_debito",
                        column: x => x.id_nota_debito,
                        principalSchema: "compras",
                        principalTable: "nota_debito",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_id_compra_referencia",
                schema: "compras",
                table: "nota_credito",
                column: "id_compra_referencia");

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_id_proveedor",
                schema: "compras",
                table: "nota_credito",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_detalle_id_compra_detalle",
                schema: "compras",
                table: "nota_credito_detalle",
                column: "id_compra_detalle");

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_detalle_id_nota_credito",
                schema: "compras",
                table: "nota_credito_detalle",
                column: "id_nota_credito");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_id_compra_referencia",
                schema: "compras",
                table: "nota_debito",
                column: "id_compra_referencia");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_id_proveedor",
                schema: "compras",
                table: "nota_debito",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_detalle_id_compra_detalle",
                schema: "compras",
                table: "nota_debito_detalle",
                column: "id_compra_detalle");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_detalle_id_nota_debito",
                schema: "compras",
                table: "nota_debito_detalle",
                column: "id_nota_debito");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "nota_credito_detalle",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "nota_debito_detalle",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "nota_credito",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "nota_debito",
                schema: "compras");

            migrationBuilder.DropColumn(
                name: "estado_sunat",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "fecha_anulacion",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "motivo_anulacion",
                schema: "compras",
                table: "compras");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "proveedores",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "proveedores",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "ordenes_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_orden_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "compras",
                table: "compras",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "compras",
                table: "compras",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);
        }
    }
}
