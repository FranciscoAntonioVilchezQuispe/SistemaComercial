using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSunatNotasVentas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_notas_credito_debito;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_caja_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_stock_actual;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_kardex_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_compras;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_detalle_venta;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_ventas;");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "ventas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "ventas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "moneda",
                schema: "ventas",
                table: "ventas",
                type: "character varying(255)",
                maxLength: 255,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(3)",
                oldMaxLength: 3);

            migrationBuilder.AddColumn<string>(
                name: "estado_sunat",
                schema: "ventas",
                table: "ventas",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_anulacion",
                schema: "ventas",
                table: "ventas",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "motivo_anulacion",
                schema: "ventas",
                table: "ventas",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "numero_resumen_baja",
                schema: "ventas",
                table: "ventas",
                type: "text",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "configuracion",
                table: "series_comprobantes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "configuracion",
                table: "series_comprobantes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "pagos",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "pagos",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "movimientos_caja",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_responsable",
                schema: "ventas",
                table: "movimientos_caja",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "metodos_pago",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "metodos_pago",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_venta",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "detalle_venta",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_notas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_cotizacion",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "cotizaciones",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "cotizaciones",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "clientes",
                table: "contactos_cliente",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "clientes",
                table: "contactos_cliente",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "clientes",
                table: "clientes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "clientes",
                table: "clientes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "cajas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "cajas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.CreateTable(
                name: "nota_credito",
                schema: "ventas",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    serie = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero = table.Column<long>(type: "bigint", nullable: false),
                    tipo_comprobante = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_venta_referencia = table.Column<long>(type: "bigint", nullable: false),
                    serie_referencia = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero_referencia = table.Column<long>(type: "bigint", nullable: false),
                    tipo_doc_referencia = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_tipo_nota = table.Column<long>(type: "bigint", nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    cliente_tipo_doc = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    cliente_nro_doc = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    cliente_razon_social = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    porcentaje_igv = table.Column<decimal>(type: "numeric(5,2)", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: true),
                    afecta_stock = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "date", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_envio_sunat = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    respuesta_sunat_codigo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    respuesta_sunat_desc = table.Column<string>(type: "text", nullable: true),
                    hash_cdr = table.Column<string>(type: "text", nullable: true),
                    xml_generado = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_credito", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_nota_credito_ventas_id_venta_referencia",
                        column: x => x.id_venta_referencia,
                        principalSchema: "ventas",
                        principalTable: "ventas",
                        principalColumn: "id_venta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_debito",
                schema: "ventas",
                columns: table => new
                {
                    id_nota = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    serie = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero = table.Column<long>(type: "bigint", nullable: false),
                    tipo_comprobante = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_venta_referencia = table.Column<long>(type: "bigint", nullable: false),
                    serie_referencia = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero_referencia = table.Column<long>(type: "bigint", nullable: false),
                    tipo_doc_referencia = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    id_tipo_nota = table.Column<long>(type: "bigint", nullable: false),
                    motivo_sustento = table.Column<string>(type: "text", nullable: false),
                    cliente_tipo_doc = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    cliente_nro_doc = table.Column<string>(type: "character varying(15)", maxLength: 15, nullable: false),
                    cliente_razon_social = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    porcentaje_igv = table.Column<decimal>(type: "numeric(5,2)", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: true),
                    afecta_stock = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "date", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_envio_sunat = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    respuesta_sunat_codigo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    respuesta_sunat_desc = table.Column<string>(type: "text", nullable: true),
                    hash_cdr = table.Column<string>(type: "text", nullable: true),
                    xml_generado = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_debito", x => x.id_nota);
                    table.ForeignKey(
                        name: "fk_nota_debito_ventas_id_venta_referencia",
                        column: x => x.id_venta_referencia,
                        principalSchema: "ventas",
                        principalTable: "ventas",
                        principalColumn: "id_venta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_credito_detalle",
                schema: "ventas",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota_credito = table.Column<long>(type: "bigint", nullable: false),
                    id_venta_detalle = table.Column<long>(type: "bigint", nullable: true),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    unidad_medida = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_credito_detalle", x => x.id_detalle);
                    table.ForeignKey(
                        name: "fk_nota_credito_detalle_detalle_venta_id_venta_detalle",
                        column: x => x.id_venta_detalle,
                        principalSchema: "ventas",
                        principalTable: "detalle_venta",
                        principalColumn: "id_detalle_venta");
                    table.ForeignKey(
                        name: "fk_nota_credito_detalle_nota_credito_id_nota_credito",
                        column: x => x.id_nota_credito,
                        principalSchema: "ventas",
                        principalTable: "nota_credito",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "nota_debito_detalle",
                schema: "ventas",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_nota_debito = table.Column<long>(type: "bigint", nullable: false),
                    id_venta_detalle = table.Column<long>(type: "bigint", nullable: true),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    descripcion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    unidad_medida = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    cantidad = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    igv = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_nota_debito_detalle", x => x.id_detalle);
                    table.ForeignKey(
                        name: "fk_nota_debito_detalle_detalle_venta_id_venta_detalle",
                        column: x => x.id_venta_detalle,
                        principalSchema: "ventas",
                        principalTable: "detalle_venta",
                        principalColumn: "id_detalle_venta");
                    table.ForeignKey(
                        name: "fk_nota_debito_detalle_nota_debito_id_nota_debito",
                        column: x => x.id_nota_debito,
                        principalSchema: "ventas",
                        principalTable: "nota_debito",
                        principalColumn: "id_nota",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_id_venta_referencia",
                schema: "ventas",
                table: "nota_credito",
                column: "id_venta_referencia");

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_detalle_id_nota_credito",
                schema: "ventas",
                table: "nota_credito_detalle",
                column: "id_nota_credito");

            migrationBuilder.CreateIndex(
                name: "ix_nota_credito_detalle_id_venta_detalle",
                schema: "ventas",
                table: "nota_credito_detalle",
                column: "id_venta_detalle");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_id_venta_referencia",
                schema: "ventas",
                table: "nota_debito",
                column: "id_venta_referencia");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_detalle_id_nota_debito",
                schema: "ventas",
                table: "nota_debito_detalle",
                column: "id_nota_debito");

            migrationBuilder.CreateIndex(
                name: "ix_nota_debito_detalle_id_venta_detalle",
                schema: "ventas",
                table: "nota_debito_detalle",
                column: "id_venta_detalle");

            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_notas_credito_debito;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_caja_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_stock_actual;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_kardex_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_compras;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_detalle_venta;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_ventas;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_lista_ventas AS
SELECT 
    v.id_venta, v.serie, v.numero, v.fecha_emision,
    tc.codigo AS codigo_tipo_comprobante, tc.nombre AS nombre_tipo_comprobante,
    c.numero_documento AS numero_documento_cliente, c.razon_social AS razon_social_cliente,
    v.subtotal_gravado + v.subtotal_exonerado + v.subtotal_inafecto AS subtotal,
    v.total_impuesto AS igv, v.total_venta AS total, v.moneda,
    eg.nombre AS estado_venta,
    v.usuario_creacion AS nombre_usuario_creacion,
    EXISTS(SELECT 1 FROM ventas.nota_credito n JOIN configuracion.tipo_comprobante tcn ON n.tipo_comprobante = tcn.codigo WHERE n.id_venta_referencia = v.id_venta AND tcn.codigo = '07') AS tiene_nota_credito,
    EXISTS(SELECT 1 FROM ventas.nota_debito n JOIN configuracion.tipo_comprobante tcn ON n.tipo_comprobante = tcn.codigo WHERE n.id_venta_referencia = v.id_venta AND tcn.codigo = '08') AS tiene_nota_debito
FROM ventas.ventas v
JOIN clientes.clientes c ON v.id_cliente = c.id_cliente
JOIN configuracion.tipo_comprobante tc ON v.id_tipo_comprobante = tc.id_tipo_comprobante
LEFT JOIN configuracion.tablas_generales_detalle eg ON v.id_estado = eg.id_detalle;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_detalle_venta AS
SELECT 
    d.id_detalle_venta, d.id_venta, p.id_producto, p.codigo_producto, d.descripcion_producto,
    um.codigo_sunat AS codigo_unidad_medida, um.simbolo AS simbolo_unidad,
    d.cantidad, d.precio_unitario_base, d.precio_unitario AS precio_unitario_con_igv,
    d.descuento_item, d.valor_item,
    ta.codigo AS codigo_afectacion_igv, ta.nombre AS nombre_afectacion_igv,
    d.codigo_tributo, d.porcentaje_impuesto AS porcentaje_igv, d.impuesto_item, d.total_item
FROM ventas.detalle_venta d
JOIN catalogo.productos p ON d.id_producto = p.id_producto
JOIN catalogo.unidades_medida um ON p.id_unidad = um.id_unidad
LEFT JOIN configuracion.tipo_afectacion_igv ta ON d.codigo_afectacion_igv = ta.codigo;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_lista_compras AS
SELECT 
    c.id_compra, c.serie_comprobante, c.numero_comprobante, c.fecha_emision,
    tc.nombre AS nombre_tipo_comprobante,
    p.numero_documento AS numero_documento_proveedor, p.razon_social AS razon_social_proveedor,
    c.subtotal, c.impuesto AS igv, c.total, c.moneda,
    a.nombre_almacen AS nombre_almacen_destino,
    (c.id_orden_compra_ref IS NOT NULL) AS tiene_orden_compra_vinculada
FROM compras.compras c
JOIN compras.proveedores p ON c.id_proveedor = p.id_proveedor
JOIN configuracion.tipo_comprobante tc ON c.id_tipo_comprobante = tc.id_tipo_comprobante
JOIN inventario.almacenes a ON c.id_almacen = a.id_almacen;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_kardex_movimientos AS
SELECT 
    m.id_movimiento, m.fecha_creacion AS fecha_movimiento,
    p.codigo_producto, p.nombre_producto AS descripcion_producto,
    a.nombre_almacen, tm.nombre AS tipo_operacion,
    m.referencia_modulo AS tipo_documento_origen, m.id_referencia::text AS numero_documento,
    m.cantidad, m.costo_unitario_movimiento AS costo_unitario, m.cantidad * m.costo_unitario_movimiento AS costo_total,
    m.cantidad_nueva AS saldo_cantidad, m.observaciones
FROM inventario.movimientos_inventario m
JOIN inventario.stock s ON m.id_stock = s.id_stock
JOIN catalogo.productos p ON s.id_producto = p.id_producto
JOIN inventario.almacenes a ON s.id_almacen = a.id_almacen
LEFT JOIN configuracion.tablas_generales_detalle tm ON m.id_tipo_movimiento = tm.id_detalle;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_stock_actual AS
SELECT 
    p.id_producto, p.codigo_producto, p.nombre_producto AS descripcion_producto,
    cat.nombre_categoria, mar.nombre_marca,
    um.codigo_sunat AS codigo_unidad_medida, um.simbolo AS simbolo_unidad,
    a.nombre_almacen, st.cantidad_actual AS stock_actual, st.ubicacion_fisica,
    (st.cantidad_actual < p.stock_minimo) AS alerta_stock_minimo
FROM inventario.stock st
JOIN catalogo.productos p ON st.id_producto = p.id_producto
JOIN catalogo.categorias cat ON p.id_categoria = cat.id_categoria
JOIN catalogo.marcas mar ON p.id_marca = mar.id_marca
JOIN catalogo.unidades_medida um ON p.id_unidad = um.id_unidad
JOIN inventario.almacenes a ON st.id_almacen = a.id_almacen;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_caja_movimientos AS
SELECT 
    m.id_movimiento_caja, m.fecha_movimiento,
    c.nombre_caja, tm.nombre AS tipo_movimiento,
    m.concepto, m.monto, 'PEN' AS moneda,
    NULL AS referencia_comprobante,
    m.usuario_responsable AS nombre_usuario
FROM ventas.movimientos_caja m
JOIN ventas.cajas c ON m.id_caja = c.id_caja
LEFT JOIN configuracion.tablas_generales_detalle tm ON m.id_tipo_movimiento = tm.id_detalle;");

            migrationBuilder.Sql(@"CREATE OR REPLACE VIEW vistas.vw_notas_credito_debito AS
SELECT 
    n.id_nota, CASE WHEN tc.codigo = '07' THEN 'CREDITO' ELSE 'DEBITO' END AS tipo_nota, 'VENTA' AS origen,
    n.serie, n.numero, n.fecha_emision, tc.nombre AS nombre_tipo_comprobante,
    n.serie_referencia || '-' || n.numero_referencia AS comprobante_referencia,
    n.cliente_razon_social AS razon_social_cliente_o_proveedor,
    CAST(n.id_tipo_nota AS character varying) AS codigo_motivo, n.motivo_sustento AS descripcion_motivo,
    n.afecta_stock AS devuelve_stock, n.total AS monto_total, n.estado AS estado
FROM ventas.nota_credito n
JOIN configuracion.tipo_comprobante tc ON n.tipo_comprobante = tc.codigo
UNION ALL
SELECT 
    n.id_nota, CASE WHEN tc.codigo = '07' THEN 'CREDITO' ELSE 'DEBITO' END AS tipo_nota, 'VENTA' AS origen,
    n.serie, n.numero, n.fecha_emision, tc.nombre AS nombre_tipo_comprobante,
    n.serie_referencia || '-' || n.numero_referencia AS comprobante_referencia,
    n.cliente_razon_social AS razon_social_cliente_o_proveedor,
    CAST(n.id_tipo_nota AS character varying) AS codigo_motivo, n.motivo_sustento AS descripcion_motivo,
    n.afecta_stock AS devuelve_stock, n.total AS monto_total, n.estado AS estado
FROM ventas.nota_debito n
JOIN configuracion.tipo_comprobante tc ON n.tipo_comprobante = tc.codigo;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_notas_credito_debito;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_caja_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_stock_actual;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_kardex_movimientos;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_compras;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_detalle_venta;");
            migrationBuilder.Sql("DROP VIEW IF EXISTS vistas.vw_lista_ventas;");

            migrationBuilder.DropTable(
                name: "nota_credito_detalle",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "nota_debito_detalle",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "nota_credito",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "nota_debito",
                schema: "ventas");

            migrationBuilder.DropColumn(
                name: "estado_sunat",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "fecha_anulacion",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "motivo_anulacion",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.DropColumn(
                name: "numero_resumen_baja",
                schema: "ventas",
                table: "ventas");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "ventas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "ventas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "moneda",
                schema: "ventas",
                table: "ventas",
                type: "character varying(3)",
                maxLength: 3,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(255)",
                oldMaxLength: 255);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "configuracion",
                table: "series_comprobantes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "configuracion",
                table: "series_comprobantes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "pagos",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "pagos",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "movimientos_caja",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_responsable",
                schema: "ventas",
                table: "movimientos_caja",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "metodos_pago",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "metodos_pago",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_notas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_cotizacion",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "detalle_venta",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "detalle_venta",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "cotizaciones",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "cotizaciones",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "clientes",
                table: "contactos_cliente",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "clientes",
                table: "contactos_cliente",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "clientes",
                table: "clientes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "clientes",
                table: "clientes",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "ventas",
                table: "cajas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "ventas",
                table: "cajas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);
        }
    }
}
