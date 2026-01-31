using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Inicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            /*
            migrationBuilder.EnsureSchema(
                name: "ventas");

            migrationBuilder.EnsureSchema(
                name: "clientes");

            migrationBuilder.EnsureSchema(
                name: "configuracion");

            migrationBuilder.CreateTable(
                name: "cajas",
                schema: "ventas",
                columns: table => new
                {
                    id_caja = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_caja = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    id_almacen = table.Column<long>(type: "bigint", nullable: false),
                    id_estado = table.Column<long>(type: "bigint", nullable: false),
                    monto_apertura = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    monto_actual = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    fecha_apertura = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    fecha_cierre = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    id_usuario_cajero = table.Column<long>(type: "bigint", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cajas", x => x.id_caja);
                });

            migrationBuilder.CreateTable(
                name: "clientes",
                schema: "clientes",
                columns: table => new
                {
                    id_cliente = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tipo_documento = table.Column<long>(type: "bigint", nullable: false),
                    numero_documento = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    razon_social = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    nombre_comercial = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    direccion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    telefono = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    id_tipo_cliente = table.Column<long>(type: "bigint", nullable: true),
                    limite_credito = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    dias_credito = table.Column<int>(type: "integer", nullable: true),
                    id_lista_precio_asignada = table.Column<long>(type: "bigint", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_clientes", x => x.id_cliente);
                });

            migrationBuilder.CreateTable(
                name: "metodos_pago",
                schema: "ventas",
                columns: table => new
                {
                    id_metodo_pago = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    nombre = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    requiere_referencia = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_metodos_pago", x => x.id_metodo_pago);
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
                name: "contactos_cliente",
                schema: "clientes",
                columns: table => new
                {
                    id_contacto = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_cliente = table.Column<long>(type: "bigint", nullable: false),
                    nombres = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    cargo = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    telefono = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    es_principal = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_contactos_cliente", x => x.id_contacto);
                    table.ForeignKey(
                        name: "fk_contactos_cliente_clientes_id_cliente",
                        column: x => x.id_cliente,
                        principalSchema: "clientes",
                        principalTable: "clientes",
                        principalColumn: "id_cliente",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "cotizaciones",
                schema: "ventas",
                columns: table => new
                {
                    id_cotizacion = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    serie = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero = table.Column<long>(type: "bigint", nullable: false),
                    id_cliente = table.Column<long>(type: "bigint", nullable: false),
                    id_usuario_vendedor = table.Column<long>(type: "bigint", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_vencimiento = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    id_estado = table.Column<long>(type: "bigint", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    impuesto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cotizaciones", x => x.id_cotizacion);
                    table.ForeignKey(
                        name: "fk_cotizaciones_clientes_id_cliente",
                        column: x => x.id_cliente,
                        principalSchema: "clientes",
                        principalTable: "clientes",
                        principalColumn: "id_cliente",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ventas",
                schema: "ventas",
                columns: table => new
                {
                    id_venta = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_empresa = table.Column<long>(type: "bigint", nullable: false),
                    id_almacen = table.Column<long>(type: "bigint", nullable: false),
                    id_caja = table.Column<long>(type: "bigint", nullable: true),
                    id_cliente = table.Column<long>(type: "bigint", nullable: false),
                    id_usuario_vendedor = table.Column<long>(type: "bigint", nullable: false),
                    id_cotizacion_origen = table.Column<long>(type: "bigint", nullable: true),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    serie = table.Column<string>(type: "character varying(4)", maxLength: 4, nullable: false),
                    numero = table.Column<long>(type: "bigint", nullable: false),
                    fecha_emision = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_vencimiento_pago = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    id_estado = table.Column<long>(type: "bigint", nullable: false),
                    moneda = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    tipo_cambio = table.Column<decimal>(type: "numeric(10,4)", nullable: false),
                    subtotal_gravado = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    subtotal_exonerado = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    subtotal_inafecto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_impuesto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_descuento_global = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_venta = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    saldo_pendiente = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    id_estado_pago = table.Column<long>(type: "bigint", nullable: false),
                    observaciones = table.Column<string>(type: "text", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_ventas", x => x.id_venta);
                    table.ForeignKey(
                        name: "fk_ventas_cajas_id_caja",
                        column: x => x.id_caja,
                        principalSchema: "ventas",
                        principalTable: "cajas",
                        principalColumn: "id_caja");
                    table.ForeignKey(
                        name: "fk_ventas_clientes_id_cliente",
                        column: x => x.id_cliente,
                        principalSchema: "clientes",
                        principalTable: "clientes",
                        principalColumn: "id_cliente",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_cotizacion",
                schema: "ventas",
                columns: table => new
                {
                    id_detalle_cot = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_cotizacion = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    porcentaje_descuento = table.Column<decimal>(type: "numeric(5,2)", nullable: true),
                    monto_descuento = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    subtotal = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_cotizacion", x => x.id_detalle_cot);
                    table.ForeignKey(
                        name: "fk_detalle_cotizacion_cotizaciones_id_cotizacion",
                        column: x => x.id_cotizacion,
                        principalSchema: "ventas",
                        principalTable: "cotizaciones",
                        principalColumn: "id_cotizacion",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalle_venta",
                schema: "ventas",
                columns: table => new
                {
                    id_detalle_venta = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_venta = table.Column<long>(type: "bigint", nullable: false),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    id_variante = table.Column<long>(type: "bigint", nullable: true),
                    descripcion_producto = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    cantidad = table.Column<decimal>(type: "numeric(10,3)", nullable: false),
                    precio_unitario = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    precio_lista_original = table.Column<decimal>(type: "numeric(12,2)", nullable: true),
                    porcentaje_impuesto = table.Column<decimal>(type: "numeric(5,2)", nullable: false),
                    impuesto_item = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    total_item = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalle_venta", x => x.id_detalle_venta);
                    table.ForeignKey(
                        name: "fk_detalle_venta_ventas_id_venta",
                        column: x => x.id_venta,
                        principalSchema: "ventas",
                        principalTable: "ventas",
                        principalColumn: "id_venta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "pagos",
                schema: "ventas",
                columns: table => new
                {
                    id_pago = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_venta = table.Column<long>(type: "bigint", nullable: false),
                    id_metodo_pago = table.Column<long>(type: "bigint", nullable: false),
                    monto_pago = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    referencia_pago = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    fecha_pago = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_pagos", x => x.id_pago);
                    table.ForeignKey(
                        name: "fk_pagos_metodos_pago_id_metodo_pago",
                        column: x => x.id_metodo_pago,
                        principalSchema: "ventas",
                        principalTable: "metodos_pago",
                        principalColumn: "id_metodo_pago",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_pagos_ventas_id_venta",
                        column: x => x.id_venta,
                        principalSchema: "ventas",
                        principalTable: "ventas",
                        principalColumn: "id_venta",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "movimientos_caja",
                schema: "ventas",
                columns: table => new
                {
                    id_movimiento_caja = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_caja = table.Column<long>(type: "bigint", nullable: false),
                    id_tipo_movimiento = table.Column<long>(type: "bigint", nullable: false),
                    monto = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    concepto = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    id_pago_relacionado = table.Column<long>(type: "bigint", nullable: true),
                    fecha_movimiento = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_responsable = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_movimientos_caja", x => x.id_movimiento_caja);
                    table.ForeignKey(
                        name: "fk_movimientos_caja_cajas_id_caja",
                        column: x => x.id_caja,
                        principalSchema: "ventas",
                        principalTable: "cajas",
                        principalColumn: "id_caja",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_movimientos_caja_pagos_id_pago_relacionado",
                        column: x => x.id_pago_relacionado,
                        principalSchema: "ventas",
                        principalTable: "pagos",
                        principalColumn: "id_pago");
                });

            migrationBuilder.CreateIndex(
                name: "ix_contactos_cliente_id_cliente",
                schema: "clientes",
                table: "contactos_cliente",
                column: "id_cliente");

            migrationBuilder.CreateIndex(
                name: "ix_cotizaciones_id_cliente",
                schema: "ventas",
                table: "cotizaciones",
                column: "id_cliente");

            migrationBuilder.CreateIndex(
                name: "ix_detalle_cotizacion_id_cotizacion",
                schema: "ventas",
                table: "detalle_cotizacion",
                column: "id_cotizacion");

            migrationBuilder.CreateIndex(
                name: "ix_detalle_venta_id_venta",
                schema: "ventas",
                table: "detalle_venta",
                column: "id_venta");

            migrationBuilder.CreateIndex(
                name: "ix_movimientos_caja_id_caja",
                schema: "ventas",
                table: "movimientos_caja",
                column: "id_caja");

            migrationBuilder.CreateIndex(
                name: "ix_movimientos_caja_id_pago_relacionado",
                schema: "ventas",
                table: "movimientos_caja",
                column: "id_pago_relacionado");

            migrationBuilder.CreateIndex(
                name: "ix_pagos_id_metodo_pago",
                schema: "ventas",
                table: "pagos",
                column: "id_metodo_pago");

            migrationBuilder.CreateIndex(
                name: "ix_pagos_id_venta",
                schema: "ventas",
                table: "pagos",
                column: "id_venta");

            migrationBuilder.CreateIndex(
                name: "ix_ventas_id_caja",
                schema: "ventas",
                table: "ventas",
                column: "id_caja");

            migrationBuilder.CreateIndex(
                name: "ix_ventas_id_cliente",
                schema: "ventas",
                table: "ventas",
                column: "id_cliente");
            */}

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "contactos_cliente",
                schema: "clientes");

            migrationBuilder.DropTable(
                name: "detalle_cotizacion",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "detalle_venta",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "movimientos_caja",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "cotizaciones",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "pagos",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "metodos_pago",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "ventas",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "cajas",
                schema: "ventas");

            migrationBuilder.DropTable(
                name: "clientes",
                schema: "clientes");
        }
    }
}
