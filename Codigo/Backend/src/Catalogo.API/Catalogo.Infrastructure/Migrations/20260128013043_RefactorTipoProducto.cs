using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Catalogo.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RefactorTipoProducto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_categorias_categorias_IdCategoriaPadre",
                schema: "catalogo",
                table: "categorias");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_categorias_IdCategoria",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_marcas_IdMarca",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_unidades_medida_IdUnidadMedida",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropColumn(
                name: "ImagenUrl",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropColumn(
                name: "TipoProducto",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.RenameColumn(
                name: "Simbolo",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "simbolo");

            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "fecha_modificacion");

            migrationBuilder.RenameColumn(
                name: "CodigoSunat",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "codigo_sunat");

            migrationBuilder.RenameColumn(
                name: "Id",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "id_unidad");

            migrationBuilder.RenameColumn(
                name: "Nombre",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "nombre_unidad");

            migrationBuilder.RenameColumn(
                name: "Sku",
                schema: "catalogo",
                table: "productos",
                newName: "sku");

            migrationBuilder.RenameColumn(
                name: "Descripcion",
                schema: "catalogo",
                table: "productos",
                newName: "descripcion");

            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "productos",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "productos",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "productos",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "TieneVariantes",
                schema: "catalogo",
                table: "productos",
                newName: "tiene_variantes");

            migrationBuilder.RenameColumn(
                name: "StockMinimo",
                schema: "catalogo",
                table: "productos",
                newName: "stock_minimo");

            migrationBuilder.RenameColumn(
                name: "StockMaximo",
                schema: "catalogo",
                table: "productos",
                newName: "stock_maximo");

            migrationBuilder.RenameColumn(
                name: "PrecioVentaPublico",
                schema: "catalogo",
                table: "productos",
                newName: "precio_venta_publico");

            migrationBuilder.RenameColumn(
                name: "PrecioVentaMayorista",
                schema: "catalogo",
                table: "productos",
                newName: "precio_venta_mayorista");

            migrationBuilder.RenameColumn(
                name: "PrecioVentaDistribuidor",
                schema: "catalogo",
                table: "productos",
                newName: "precio_venta_distribuidor");

            migrationBuilder.RenameColumn(
                name: "PrecioCompra",
                schema: "catalogo",
                table: "productos",
                newName: "precio_compra");

            migrationBuilder.RenameColumn(
                name: "PorcentajeImpuesto",
                schema: "catalogo",
                table: "productos",
                newName: "porcentaje_impuesto");

            migrationBuilder.RenameColumn(
                name: "PermiteInventarioNegativo",
                schema: "catalogo",
                table: "productos",
                newName: "permite_inventario_negativo");

            migrationBuilder.RenameColumn(
                name: "NombreProducto",
                schema: "catalogo",
                table: "productos",
                newName: "nombre_producto");

            migrationBuilder.RenameColumn(
                name: "IdUnidadMedida",
                schema: "catalogo",
                table: "productos",
                newName: "id_unidad");

            migrationBuilder.RenameColumn(
                name: "IdMarca",
                schema: "catalogo",
                table: "productos",
                newName: "id_marca");

            migrationBuilder.RenameColumn(
                name: "IdCategoria",
                schema: "catalogo",
                table: "productos",
                newName: "id_categoria");

            migrationBuilder.RenameColumn(
                name: "GravadoImpuesto",
                schema: "catalogo",
                table: "productos",
                newName: "gravado_impuesto");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "productos",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "productos",
                newName: "fecha_modificacion");

            migrationBuilder.RenameColumn(
                name: "CodigoProducto",
                schema: "catalogo",
                table: "productos",
                newName: "codigo_producto");

            migrationBuilder.RenameColumn(
                name: "CodigoBarras",
                schema: "catalogo",
                table: "productos",
                newName: "codigo_barras");

            migrationBuilder.RenameColumn(
                name: "Id",
                schema: "catalogo",
                table: "productos",
                newName: "id_producto");

            migrationBuilder.RenameIndex(
                name: "IX_productos_IdUnidadMedida",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_id_unidad");

            migrationBuilder.RenameIndex(
                name: "IX_productos_IdMarca",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_id_marca");

            migrationBuilder.RenameIndex(
                name: "IX_productos_IdCategoria",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_id_categoria");

            migrationBuilder.RenameIndex(
                name: "IX_productos_CodigoProducto",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_codigo_producto");

            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "marcas",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "marcas",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "marcas",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "PaisOrigen",
                schema: "catalogo",
                table: "marcas",
                newName: "pais_origen");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "marcas",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "marcas",
                newName: "fecha_modificacion");

            migrationBuilder.RenameColumn(
                name: "Id",
                schema: "catalogo",
                table: "marcas",
                newName: "id_marca");

            migrationBuilder.RenameColumn(
                name: "Nombre",
                schema: "catalogo",
                table: "marcas",
                newName: "nombre_marca");

            migrationBuilder.RenameColumn(
                name: "Descripcion",
                schema: "catalogo",
                table: "categorias",
                newName: "descripcion");

            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "categorias",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "categorias",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "categorias",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "ImagenUrl",
                schema: "catalogo",
                table: "categorias",
                newName: "imagen_url");

            migrationBuilder.RenameColumn(
                name: "IdCategoriaPadre",
                schema: "catalogo",
                table: "categorias",
                newName: "id_categoria_padre");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "categorias",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "categorias",
                newName: "fecha_modificacion");

            migrationBuilder.RenameColumn(
                name: "Id",
                schema: "catalogo",
                table: "categorias",
                newName: "id_categoria");

            migrationBuilder.RenameColumn(
                name: "Nombre",
                schema: "catalogo",
                table: "categorias",
                newName: "nombre_categoria");

            migrationBuilder.RenameIndex(
                name: "IX_categorias_IdCategoriaPadre",
                schema: "catalogo",
                table: "categorias",
                newName: "IX_categorias_id_categoria_padre");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "codigo_sunat",
                schema: "catalogo",
                table: "unidades_medida",
                type: "character varying(10)",
                maxLength: 10,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<long>(
                name: "id_unidad",
                schema: "catalogo",
                table: "unidades_medida",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AlterColumn<decimal>(
                name: "stock_maximo",
                schema: "catalogo",
                table: "productos",
                type: "numeric(10,3)",
                precision: 10,
                scale: 3,
                nullable: true,
                oldClrType: typeof(decimal),
                oldType: "numeric(10,3)",
                oldPrecision: 10,
                oldScale: 3);

            migrationBuilder.AlterColumn<long>(
                name: "id_unidad",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<long>(
                name: "id_marca",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<long>(
                name: "id_categoria",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "productos",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "productos",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "codigo_barras",
                schema: "catalogo",
                table: "productos",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<long>(
                name: "id_producto",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddColumn<long>(
                name: "id_tipo_producto",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                defaultValue: 0L);

            migrationBuilder.AddColumn<string>(
                name: "imagen_principal_url",
                schema: "catalogo",
                table: "productos",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "pais_origen",
                schema: "catalogo",
                table: "marcas",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "marcas",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "marcas",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<long>(
                name: "id_marca",
                schema: "catalogo",
                table: "marcas",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AlterColumn<string>(
                name: "descripcion",
                schema: "catalogo",
                table: "categorias",
                type: "character varying(255)",
                maxLength: 255,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "imagen_url",
                schema: "catalogo",
                table: "categorias",
                type: "character varying(500)",
                maxLength: 500,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<long>(
                name: "id_categoria_padre",
                schema: "catalogo",
                table: "categorias",
                type: "bigint",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "categorias",
                type: "timestamp without time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone");

            migrationBuilder.AlterColumn<DateTime>(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "categorias",
                type: "timestamp without time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp with time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<long>(
                name: "id_categoria",
                schema: "catalogo",
                table: "categorias",
                type: "bigint",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "integer")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.CreateTable(
                name: "imagenes_producto",
                schema: "catalogo",
                columns: table => new
                {
                    id_imagen = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    url_imagen = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    es_principal = table.Column<bool>(type: "boolean", nullable: false),
                    orden = table.Column<int>(type: "integer", nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_imagenes_producto", x => x.id_imagen);
                    table.ForeignKey(
                        name: "FK_imagenes_producto_productos_id_producto",
                        column: x => x.id_producto,
                        principalSchema: "catalogo",
                        principalTable: "productos",
                        principalColumn: "id_producto",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "variantes_producto",
                schema: "catalogo",
                columns: table => new
                {
                    id_variante = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_producto = table.Column<long>(type: "bigint", nullable: false),
                    sku_variante = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    codigo_barras_variante = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    nombre_completo_variante = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    atributos_json = table.Column<string>(type: "jsonb", nullable: true),
                    precio_adicional = table.Column<decimal>(type: "numeric(12,2)", nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_variantes_producto", x => x.id_variante);
                    table.ForeignKey(
                        name: "FK_variantes_producto_productos_id_producto",
                        column: x => x.id_producto,
                        principalSchema: "catalogo",
                        principalTable: "productos",
                        principalColumn: "id_producto",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_imagenes_producto_id_producto",
                schema: "catalogo",
                table: "imagenes_producto",
                column: "id_producto");

            migrationBuilder.CreateIndex(
                name: "IX_variantes_producto_id_producto",
                schema: "catalogo",
                table: "variantes_producto",
                column: "id_producto");

            migrationBuilder.AddForeignKey(
                name: "FK_categorias_categorias_id_categoria_padre",
                schema: "catalogo",
                table: "categorias",
                column: "id_categoria_padre",
                principalSchema: "catalogo",
                principalTable: "categorias",
                principalColumn: "id_categoria");

            migrationBuilder.AddForeignKey(
                name: "FK_productos_categorias_id_categoria",
                schema: "catalogo",
                table: "productos",
                column: "id_categoria",
                principalSchema: "catalogo",
                principalTable: "categorias",
                principalColumn: "id_categoria",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_productos_marcas_id_marca",
                schema: "catalogo",
                table: "productos",
                column: "id_marca",
                principalSchema: "catalogo",
                principalTable: "marcas",
                principalColumn: "id_marca",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_productos_unidades_medida_id_unidad",
                schema: "catalogo",
                table: "productos",
                column: "id_unidad",
                principalSchema: "catalogo",
                principalTable: "unidades_medida",
                principalColumn: "id_unidad",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_categorias_categorias_id_categoria_padre",
                schema: "catalogo",
                table: "categorias");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_categorias_id_categoria",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_marcas_id_marca",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropForeignKey(
                name: "FK_productos_unidades_medida_id_unidad",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropTable(
                name: "imagenes_producto",
                schema: "catalogo");

            migrationBuilder.DropTable(
                name: "variantes_producto",
                schema: "catalogo");

            migrationBuilder.DropColumn(
                name: "id_tipo_producto",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.DropColumn(
                name: "imagen_principal_url",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.RenameColumn(
                name: "simbolo",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "Simbolo");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "FechaCreacion");

            migrationBuilder.RenameColumn(
                name: "codigo_sunat",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "CodigoSunat");

            migrationBuilder.RenameColumn(
                name: "id_unidad",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "Id");

            migrationBuilder.RenameColumn(
                name: "nombre_unidad",
                schema: "catalogo",
                table: "unidades_medida",
                newName: "Nombre");

            migrationBuilder.RenameColumn(
                name: "sku",
                schema: "catalogo",
                table: "productos",
                newName: "Sku");

            migrationBuilder.RenameColumn(
                name: "descripcion",
                schema: "catalogo",
                table: "productos",
                newName: "Descripcion");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "productos",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "productos",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "productos",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "tiene_variantes",
                schema: "catalogo",
                table: "productos",
                newName: "TieneVariantes");

            migrationBuilder.RenameColumn(
                name: "stock_minimo",
                schema: "catalogo",
                table: "productos",
                newName: "StockMinimo");

            migrationBuilder.RenameColumn(
                name: "stock_maximo",
                schema: "catalogo",
                table: "productos",
                newName: "StockMaximo");

            migrationBuilder.RenameColumn(
                name: "precio_venta_publico",
                schema: "catalogo",
                table: "productos",
                newName: "PrecioVentaPublico");

            migrationBuilder.RenameColumn(
                name: "precio_venta_mayorista",
                schema: "catalogo",
                table: "productos",
                newName: "PrecioVentaMayorista");

            migrationBuilder.RenameColumn(
                name: "precio_venta_distribuidor",
                schema: "catalogo",
                table: "productos",
                newName: "PrecioVentaDistribuidor");

            migrationBuilder.RenameColumn(
                name: "precio_compra",
                schema: "catalogo",
                table: "productos",
                newName: "PrecioCompra");

            migrationBuilder.RenameColumn(
                name: "porcentaje_impuesto",
                schema: "catalogo",
                table: "productos",
                newName: "PorcentajeImpuesto");

            migrationBuilder.RenameColumn(
                name: "permite_inventario_negativo",
                schema: "catalogo",
                table: "productos",
                newName: "PermiteInventarioNegativo");

            migrationBuilder.RenameColumn(
                name: "nombre_producto",
                schema: "catalogo",
                table: "productos",
                newName: "NombreProducto");

            migrationBuilder.RenameColumn(
                name: "id_unidad",
                schema: "catalogo",
                table: "productos",
                newName: "IdUnidadMedida");

            migrationBuilder.RenameColumn(
                name: "id_marca",
                schema: "catalogo",
                table: "productos",
                newName: "IdMarca");

            migrationBuilder.RenameColumn(
                name: "id_categoria",
                schema: "catalogo",
                table: "productos",
                newName: "IdCategoria");

            migrationBuilder.RenameColumn(
                name: "gravado_impuesto",
                schema: "catalogo",
                table: "productos",
                newName: "GravadoImpuesto");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "productos",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "productos",
                newName: "FechaCreacion");

            migrationBuilder.RenameColumn(
                name: "codigo_producto",
                schema: "catalogo",
                table: "productos",
                newName: "CodigoProducto");

            migrationBuilder.RenameColumn(
                name: "codigo_barras",
                schema: "catalogo",
                table: "productos",
                newName: "CodigoBarras");

            migrationBuilder.RenameColumn(
                name: "id_producto",
                schema: "catalogo",
                table: "productos",
                newName: "Id");

            migrationBuilder.RenameIndex(
                name: "IX_productos_id_unidad",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_IdUnidadMedida");

            migrationBuilder.RenameIndex(
                name: "IX_productos_id_marca",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_IdMarca");

            migrationBuilder.RenameIndex(
                name: "IX_productos_id_categoria",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_IdCategoria");

            migrationBuilder.RenameIndex(
                name: "IX_productos_codigo_producto",
                schema: "catalogo",
                table: "productos",
                newName: "IX_productos_CodigoProducto");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "marcas",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "marcas",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "marcas",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "pais_origen",
                schema: "catalogo",
                table: "marcas",
                newName: "PaisOrigen");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "marcas",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "marcas",
                newName: "FechaCreacion");

            migrationBuilder.RenameColumn(
                name: "id_marca",
                schema: "catalogo",
                table: "marcas",
                newName: "Id");

            migrationBuilder.RenameColumn(
                name: "nombre_marca",
                schema: "catalogo",
                table: "marcas",
                newName: "Nombre");

            migrationBuilder.RenameColumn(
                name: "descripcion",
                schema: "catalogo",
                table: "categorias",
                newName: "Descripcion");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "categorias",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "categorias",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "categorias",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "imagen_url",
                schema: "catalogo",
                table: "categorias",
                newName: "ImagenUrl");

            migrationBuilder.RenameColumn(
                name: "id_categoria_padre",
                schema: "catalogo",
                table: "categorias",
                newName: "IdCategoriaPadre");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "categorias",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "categorias",
                newName: "FechaCreacion");

            migrationBuilder.RenameColumn(
                name: "id_categoria",
                schema: "catalogo",
                table: "categorias",
                newName: "Id");

            migrationBuilder.RenameColumn(
                name: "nombre_categoria",
                schema: "catalogo",
                table: "categorias",
                newName: "Nombre");

            migrationBuilder.RenameIndex(
                name: "IX_categorias_id_categoria_padre",
                schema: "catalogo",
                table: "categorias",
                newName: "IX_categorias_IdCategoriaPadre");

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<string>(
                name: "CodigoSunat",
                schema: "catalogo",
                table: "unidades_medida",
                type: "text",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "character varying(10)",
                oldMaxLength: 10,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "Id",
                schema: "catalogo",
                table: "unidades_medida",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AlterColumn<decimal>(
                name: "StockMaximo",
                schema: "catalogo",
                table: "productos",
                type: "numeric(10,3)",
                precision: 10,
                scale: 3,
                nullable: false,
                defaultValue: 0m,
                oldClrType: typeof(decimal),
                oldType: "numeric(10,3)",
                oldPrecision: 10,
                oldScale: 3,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "IdUnidadMedida",
                schema: "catalogo",
                table: "productos",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AlterColumn<int>(
                name: "IdMarca",
                schema: "catalogo",
                table: "productos",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AlterColumn<int>(
                name: "IdCategoria",
                schema: "catalogo",
                table: "productos",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "productos",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "productos",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<string>(
                name: "CodigoBarras",
                schema: "catalogo",
                table: "productos",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "Id",
                schema: "catalogo",
                table: "productos",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddColumn<string>(
                name: "ImagenUrl",
                schema: "catalogo",
                table: "productos",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TipoProducto",
                schema: "catalogo",
                table: "productos",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AlterColumn<string>(
                name: "PaisOrigen",
                schema: "catalogo",
                table: "marcas",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100,
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "marcas",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "marcas",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<int>(
                name: "Id",
                schema: "catalogo",
                table: "marcas",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AlterColumn<string>(
                name: "Descripcion",
                schema: "catalogo",
                table: "categorias",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(255)",
                oldMaxLength: 255,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "ImagenUrl",
                schema: "catalogo",
                table: "categorias",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500,
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "IdCategoriaPadre",
                schema: "catalogo",
                table: "categorias",
                type: "integer",
                nullable: true,
                oldClrType: typeof(long),
                oldType: "bigint",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "categorias",
                type: "timestamp with time zone",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "categorias",
                type: "timestamp with time zone",
                nullable: false,
                oldClrType: typeof(DateTime),
                oldType: "timestamp without time zone");

            migrationBuilder.AlterColumn<int>(
                name: "Id",
                schema: "catalogo",
                table: "categorias",
                type: "integer",
                nullable: false,
                oldClrType: typeof(long),
                oldType: "bigint")
                .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn)
                .OldAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn);

            migrationBuilder.AddForeignKey(
                name: "FK_categorias_categorias_IdCategoriaPadre",
                schema: "catalogo",
                table: "categorias",
                column: "IdCategoriaPadre",
                principalSchema: "catalogo",
                principalTable: "categorias",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_productos_categorias_IdCategoria",
                schema: "catalogo",
                table: "productos",
                column: "IdCategoria",
                principalSchema: "catalogo",
                principalTable: "categorias",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_productos_marcas_IdMarca",
                schema: "catalogo",
                table: "productos",
                column: "IdMarca",
                principalSchema: "catalogo",
                principalTable: "marcas",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_productos_unidades_medida_IdUnidadMedida",
                schema: "catalogo",
                table: "productos",
                column: "IdUnidadMedida",
                principalSchema: "catalogo",
                principalTable: "unidades_medida",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
