using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddKardexEntities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "stock",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "stock",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "almacenes",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "almacenes",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.CreateTable(
                name: "inv_kardex_lote",
                schema: "inventario",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    producto_id = table.Column<long>(type: "bigint", nullable: false),
                    almacen_id = table.Column<long>(type: "bigint", nullable: false),
                    fecha_entrada = table.Column<DateTime>(type: "date", nullable: false),
                    hora_entrada = table.Column<TimeSpan>(type: "time", nullable: false),
                    movimiento_origen_id = table.Column<long>(type: "bigint", nullable: false),
                    costo_unitario = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    cantidad_original = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    cantidad_disponible = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    estado = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inv_kardex_lote", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "inv_kardex_movimiento",
                schema: "inventario",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    uuid = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: false),
                    periodo = table.Column<string>(type: "character varying(7)", maxLength: 7, nullable: false),
                    correlativo_kardex = table.Column<long>(type: "bigint", nullable: false),
                    fecha_movimiento = table.Column<DateTime>(type: "date", nullable: false),
                    hora_movimiento = table.Column<TimeSpan>(type: "time", nullable: false),
                    fecha_hora_compuesta = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    modulo_origen = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    tipo_documento = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    serie_documento = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    numero_documento = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    anulado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_anulacion = table.Column<DateTime>(type: "date", nullable: true),
                    motivo_anulacion = table.Column<string>(type: "text", nullable: true),
                    tipo_operacion = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    motivo_traslado_sunat = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    descripcion_movimiento = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    almacen_id = table.Column<long>(type: "bigint", nullable: false),
                    almacen_origen_id = table.Column<long>(type: "bigint", nullable: true),
                    almacen_destino_id = table.Column<long>(type: "bigint", nullable: true),
                    producto_id = table.Column<long>(type: "bigint", nullable: false),
                    unidad_medida_codigo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    factor_conversion = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    entrada_cantidad = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    entrada_costo_unitario = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    entrada_costo_total = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    salida_cantidad = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    salida_costo_unitario = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    salida_costo_total = table.Column<decimal>(type: "numeric(18,6)", nullable: true),
                    saldo_cantidad = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    saldo_costo_unitario = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    saldo_costo_total = table.Column<decimal>(type: "numeric(18,6)", nullable: false),
                    referencia_id = table.Column<long>(type: "bigint", nullable: true),
                    referencia_tipo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    lote_id = table.Column<long>(type: "bigint", nullable: true),
                    proveedor_cliente_id = table.Column<long>(type: "bigint", nullable: true),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    usuario_registro_id = table.Column<long>(type: "bigint", nullable: false),
                    usuario_anulacion_id = table.Column<long>(type: "bigint", nullable: true),
                    recalculado_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inv_kardex_movimiento", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "inv_kardex_periodo_control",
                schema: "inventario",
                columns: table => new
                {
                    periodo = table.Column<string>(type: "character varying(7)", maxLength: 7, nullable: false),
                    estado = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    fecha_cierre = table.Column<DateTime>(type: "date", nullable: true),
                    usuario_cierre_id = table.Column<long>(type: "bigint", nullable: true),
                    created_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    updated_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inv_kardex_periodo_control", x => x.periodo);
                });

            migrationBuilder.CreateTable(
                name: "inv_kardex_recalculo_log",
                schema: "inventario",
                columns: table => new
                {
                    id = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    almacen_id = table.Column<int>(type: "integer", nullable: false),
                    producto_id = table.Column<int>(type: "integer", nullable: false),
                    desde_fecha = table.Column<DateOnly>(type: "date", nullable: false),
                    motivo = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: false),
                    registros_afect = table.Column<int>(type: "integer", nullable: false),
                    usuario_id = table.Column<int>(type: "integer", nullable: false),
                    duracion_ms = table.Column<int>(type: "integer", nullable: true),
                    created_at = table.Column<DateTime>(type: "timestamp without time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inv_kardex_recalculo_log", x => x.id);
                });

            migrationBuilder.CreateIndex(
                name: "ix_inv_kardex_movimiento_fecha_movimiento_hora_movimiento",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                columns: new[] { "fecha_movimiento", "hora_movimiento" });

            migrationBuilder.CreateIndex(
                name: "ix_inv_kardex_movimiento_periodo_almacen_id_producto_id",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                columns: new[] { "periodo", "almacen_id", "producto_id" });

            migrationBuilder.CreateIndex(
                name: "ix_inv_kardex_movimiento_referencia_id_referencia_tipo",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                columns: new[] { "referencia_id", "referencia_tipo" });

            migrationBuilder.CreateIndex(
                name: "ix_inv_kardex_movimiento_tipo_documento_serie_documento_numero",
                schema: "inventario",
                table: "inv_kardex_movimiento",
                columns: new[] { "tipo_documento", "serie_documento", "numero_documento" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "inv_kardex_lote",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "inv_kardex_movimiento",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "inv_kardex_periodo_control",
                schema: "inventario");

            migrationBuilder.DropTable(
                name: "inv_kardex_recalculo_log",
                schema: "inventario");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "stock",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "stock",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "movimientos_inventario",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "inventario",
                table: "almacenes",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "inventario",
                table: "almacenes",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");
        }
    }
}
