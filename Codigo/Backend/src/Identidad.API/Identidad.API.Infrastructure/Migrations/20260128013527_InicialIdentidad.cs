using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Identidad.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InicialIdentidad : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "identidad");

            migrationBuilder.EnsureSchema(
                name: "configuracion");

            migrationBuilder.CreateTable(
                name: "areas",
                schema: "identidad",
                columns: table => new
                {
                    id_area = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_area = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_areas", x => x.id_area);
                });

            migrationBuilder.CreateTable(
                name: "empresa",
                schema: "configuracion",
                columns: table => new
                {
                    id_empresa = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ruc = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    razon_social = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    nombre_comercial = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    direccion_fiscal = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    telefono = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    correo_contacto = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    sitio_web = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    logo_url = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    moneda_principal = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_empresa", x => x.id_empresa);
                });

            migrationBuilder.CreateTable(
                name: "permisos",
                schema: "identidad",
                columns: table => new
                {
                    id_permiso = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo_permiso = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    descripcion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    modulo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_permisos", x => x.id_permiso);
                });

            migrationBuilder.CreateTable(
                name: "roles",
                schema: "identidad",
                columns: table => new
                {
                    id_rol = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_rol = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    descripcion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles", x => x.id_rol);
                });

            migrationBuilder.CreateTable(
                name: "series_comprobantes",
                schema: "configuracion",
                columns: table => new
                {
                    id_serie = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    serie = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    correlativo_actual = table.Column<long>(type: "bigint", nullable: false),
                    id_almacen = table.Column<long>(type: "bigint", nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_series_comprobantes", x => x.id_serie);
                });

            migrationBuilder.CreateTable(
                name: "tablas_generales",
                schema: "configuracion",
                columns: table => new
                {
                    id_tabla = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    descripcion = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    es_sistema = table.Column<bool>(type: "boolean", nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tablas_generales", x => x.id_tabla);
                });

            migrationBuilder.CreateTable(
                name: "cargos",
                schema: "identidad",
                columns: table => new
                {
                    id_cargo = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_cargo = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    id_area = table.Column<long>(type: "bigint", nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cargos", x => x.id_cargo);
                    table.ForeignKey(
                        name: "FK_cargos_areas_id_area",
                        column: x => x.id_area,
                        principalSchema: "identidad",
                        principalTable: "areas",
                        principalColumn: "id_area");
                });

            migrationBuilder.CreateTable(
                name: "roles_permisos",
                schema: "identidad",
                columns: table => new
                {
                    id_rol = table.Column<long>(type: "bigint", nullable: false),
                    id_permiso = table.Column<long>(type: "bigint", nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles_permisos", x => new { x.id_rol, x.id_permiso });
                    table.ForeignKey(
                        name: "FK_roles_permisos_permisos_id_permiso",
                        column: x => x.id_permiso,
                        principalSchema: "identidad",
                        principalTable: "permisos",
                        principalColumn: "id_permiso",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_roles_permisos_roles_id_rol",
                        column: x => x.id_rol,
                        principalSchema: "identidad",
                        principalTable: "roles",
                        principalColumn: "id_rol",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "usuarios",
                schema: "identidad",
                columns: table => new
                {
                    id_usuario = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    username = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    password_hash = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    nombres = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    apellidos = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    id_rol = table.Column<long>(type: "bigint", nullable: false),
                    ultimo_acceso = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_usuarios", x => x.id_usuario);
                    table.ForeignKey(
                        name: "FK_usuarios_roles_id_rol",
                        column: x => x.id_rol,
                        principalSchema: "identidad",
                        principalTable: "roles",
                        principalColumn: "id_rol",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "tablas_generales_detalle",
                schema: "configuracion",
                columns: table => new
                {
                    id_detalle = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tabla = table.Column<long>(type: "bigint", nullable: false),
                    codigo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    valor_adicional = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    orden = table.Column<int>(type: "integer", nullable: false),
                    estado = table.Column<bool>(type: "boolean", nullable: false),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_tablas_generales_detalle", x => x.id_detalle);
                    table.ForeignKey(
                        name: "FK_tablas_generales_detalle_tablas_generales_id_tabla",
                        column: x => x.id_tabla,
                        principalSchema: "configuracion",
                        principalTable: "tablas_generales",
                        principalColumn: "id_tabla",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "trabajadores",
                schema: "identidad",
                columns: table => new
                {
                    id_trabajador = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_tipo_documento = table.Column<long>(type: "bigint", nullable: false),
                    numero_documento = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    nombres = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    apellidos = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    fecha_nacimiento = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    telefono = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    email_corporativo = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    id_cargo = table.Column<long>(type: "bigint", nullable: true),
                    id_usuario = table.Column<long>(type: "bigint", nullable: true),
                    Activado = table.Column<bool>(type: "boolean", nullable: false),
                    FechaCreacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UsuarioCreacion = table.Column<string>(type: "text", nullable: false),
                    FechaActualizacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    UsuarioActualizacion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_trabajadores", x => x.id_trabajador);
                    table.ForeignKey(
                        name: "FK_trabajadores_cargos_id_cargo",
                        column: x => x.id_cargo,
                        principalSchema: "identidad",
                        principalTable: "cargos",
                        principalColumn: "id_cargo");
                    table.ForeignKey(
                        name: "FK_trabajadores_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalSchema: "identidad",
                        principalTable: "usuarios",
                        principalColumn: "id_usuario");
                });

            migrationBuilder.CreateIndex(
                name: "IX_cargos_id_area",
                schema: "identidad",
                table: "cargos",
                column: "id_area");

            migrationBuilder.CreateIndex(
                name: "IX_roles_permisos_id_permiso",
                schema: "identidad",
                table: "roles_permisos",
                column: "id_permiso");

            migrationBuilder.CreateIndex(
                name: "IX_tablas_generales_detalle_id_tabla",
                schema: "configuracion",
                table: "tablas_generales_detalle",
                column: "id_tabla");

            migrationBuilder.CreateIndex(
                name: "IX_trabajadores_id_cargo",
                schema: "identidad",
                table: "trabajadores",
                column: "id_cargo");

            migrationBuilder.CreateIndex(
                name: "IX_trabajadores_id_usuario",
                schema: "identidad",
                table: "trabajadores",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "IX_usuarios_id_rol",
                schema: "identidad",
                table: "usuarios",
                column: "id_rol");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "empresa",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "roles_permisos",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "series_comprobantes",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "trabajadores",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "permisos",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "tablas_generales",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "cargos",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "usuarios",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "areas",
                schema: "identidad");

            migrationBuilder.DropTable(
                name: "roles",
                schema: "identidad");
        }
    }
}
