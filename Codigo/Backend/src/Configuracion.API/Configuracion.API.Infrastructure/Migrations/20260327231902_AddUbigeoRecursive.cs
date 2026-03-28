using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUbigeoRecursive : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ubigeos",
                schema: "configuracion",
                columns: table => new
                {
                    codigo = table.Column<string>(type: "character varying(6)", maxLength: 6, nullable: false),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    nivel = table.Column<short>(type: "smallint", nullable: false),
                    parent_id = table.Column<string>(type: "character varying(6)", maxLength: 6, nullable: true),
                    id = table.Column<long>(type: "bigint", nullable: false),
                    activado = table.Column<bool>(type: "boolean", nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_creacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    fecha_modificacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    usuario_modificacion = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_ubigeos", x => x.codigo);
                    table.ForeignKey(
                        name: "fk_ubigeos_ubigeos_parent_id",
                        column: x => x.parent_id,
                        principalSchema: "configuracion",
                        principalTable: "ubigeos",
                        principalColumn: "codigo",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "ix_ubigeos_parent_id",
                schema: "configuracion",
                table: "ubigeos",
                column: "parent_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ubigeos",
                schema: "configuracion");
        }
    }
}
