using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Inicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Las tablas ya existen en la base de datos.
            // Vaciamos el contenido para permitir que EF Core registre la migración sin fallar por duplicados.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "detalle_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "detalle_orden_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "compras",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "ordenes_compra",
                schema: "compras");

            migrationBuilder.DropTable(
                name: "proveedores",
                schema: "compras");
        }
    }
}
