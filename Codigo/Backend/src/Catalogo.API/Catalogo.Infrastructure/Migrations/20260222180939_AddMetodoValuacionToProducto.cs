using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Catalogo.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddMetodoValuacionToProducto : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "fecha_modificacion");

            migrationBuilder.RenameColumn(
                name: "Activado",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "activado");

            migrationBuilder.RenameColumn(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "usuario_creacion");

            migrationBuilder.RenameColumn(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "usuario_modificacion");

            migrationBuilder.RenameColumn(
                name: "FechaCreacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "fecha_creacion");

            migrationBuilder.RenameColumn(
                name: "FechaActualizacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "fecha_modificacion");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "variantes_producto",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "variantes_producto",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "productos",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "productos",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<long>(
                name: "id_tipo_producto",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: true,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.AddColumn<string>(
                name: "metodo_valuacion",
                schema: "catalogo",
                table: "productos",
                type: "character varying(2)",
                maxLength: 2,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "marcas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "marcas",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "imagenes_producto",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "imagenes_producto",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "categorias",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "categorias",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.CreateTable(
                name: "listas_precios",
                schema: "catalogo",
                columns: table => new
                {
                    id_lista_precio = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_lista = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    es_base = table.Column<bool>(type: "boolean", nullable: false),
                    porcentaje_ganancia_sugerido = table.Column<decimal>(type: "numeric(5,2)", nullable: true),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_listas_precios", x => x.id_lista_precio);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "listas_precios",
                schema: "catalogo");

            migrationBuilder.DropColumn(
                name: "metodo_valuacion",
                schema: "catalogo",
                table: "productos");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "variantes_producto",
                newName: "FechaCreacion");

            migrationBuilder.RenameColumn(
                name: "activado",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "Activado");

            migrationBuilder.RenameColumn(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "UsuarioActualizacion");

            migrationBuilder.RenameColumn(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "UsuarioCreacion");

            migrationBuilder.RenameColumn(
                name: "fecha_modificacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "FechaActualizacion");

            migrationBuilder.RenameColumn(
                name: "fecha_creacion",
                schema: "catalogo",
                table: "imagenes_producto",
                newName: "FechaCreacion");

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "variantes_producto",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "variantes_producto",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "unidades_medida",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "productos",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "productos",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<long>(
                name: "id_tipo_producto",
                schema: "catalogo",
                table: "productos",
                type: "bigint",
                nullable: false,
                defaultValue: 0L,
                oldClrType: typeof(long),
                oldType: "bigint",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "marcas",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "marcas",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioActualizacion",
                schema: "catalogo",
                table: "imagenes_producto",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "UsuarioCreacion",
                schema: "catalogo",
                table: "imagenes_producto",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_modificacion",
                schema: "catalogo",
                table: "categorias",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50,
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "usuario_creacion",
                schema: "catalogo",
                table: "categorias",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(50)",
                oldMaxLength: 50);
        }
    }
}
