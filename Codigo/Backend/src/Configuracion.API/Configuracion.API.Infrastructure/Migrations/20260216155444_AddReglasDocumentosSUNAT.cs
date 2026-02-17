using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddReglasDocumentosSUNAT : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP TABLE IF EXISTS configuracion.\"DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE\" CASCADE;");
            migrationBuilder.Sql("DROP TABLE IF EXISTS configuracion.\"DOCUMENTOIDENTIDAD\" CASCADE;");


            migrationBuilder.CreateTable(
                name: "DOCUMENTOIDENTIDAD",
                schema: "configuracion",
                columns: table => new
                {
                    id_regla = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    longitud = table.Column<int>(type: "integer", nullable: false),
                    es_numerico = table.Column<bool>(type: "boolean", nullable: false),
                    estado = table.Column<bool>(type: "boolean", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_documentoidentidad", x => x.id_regla);
                });

            migrationBuilder.CreateTable(
                name: "DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE",
                schema: "configuracion",
                columns: table => new
                {
                    id_relacion = table.Column<long>(type: "bigint", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    codigo_documento = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    id_tipo_comprobante = table.Column<long>(type: "bigint", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_documentoidentidad_documentocomprobante", x => x.id_relacion);
                    /*
                                        table.ForeignKey(
                                            name: "fk_documentoidentidad_documentocomprobante_tipos_comprobantes_",
                                            column: x => x.id_tipo_comprobante,
                                            principalSchema: "configuracion",
                                            principalTable: "tipos_comprobantes",
                                            principalColumn: "id_tipo_comprobante",
                                            onDelete: ReferentialAction.Cascade);
                    */

                });

            migrationBuilder.CreateIndex(
                name: "ix_documentoidentidad_documentocomprobante_id_tipo_comprobante",
                schema: "configuracion",
                table: "DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE",
                column: "id_tipo_comprobante");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "DOCUMENTOIDENTIDAD",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE",
                schema: "configuracion");
        }
    }
}
