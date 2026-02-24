using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AgregarMatrizSunat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "matriz_regla_sunat",
                schema: "configuracion",
                columns: table => new
                {
                    id_regla = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo_operacion = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    codigo_documento = table.Column<string>(type: "character varying(2)", maxLength: 2, nullable: false),
                    nivel_obligatoriedad = table.Column<int>(type: "integer", nullable: false),
                    activo = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_matriz_regla_sunat", x => x.id_regla);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "matriz_regla_sunat",
                schema: "configuracion");
        }
    }
}
