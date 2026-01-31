using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AgregarTiposComprobante : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "configuracion");

            // Tablas existentes omitidas para evitar error 42P07
            /*
            migrationBuilder.CreateTable(
                name: "configuraciones",
                ...
            );
            migrationBuilder.CreateTable(
                name: "empresa",
                ...
            );
            ... (Omitiendo resto de tablas existentes)
            */

            /*
             migrationBuilder.CreateTable(
                name: "tipos_comprobantes",
                ...
            );

            // Modificar tabla series_comprobantes existente
            migrationBuilder.AddColumn<long>(
                name: "id_tipo_comprobante",
                ...
            );
            
            // Crear indice
            migrationBuilder.CreateIndex(
                name: "ix_series_comprobantes_id_tipo_comprobante",
                ...
            );

            // Crear FK
            migrationBuilder.AddForeignKey(
                name: "fk_series_comprobantes_tipos_comprobantes_id_tipo_comprobante",
                ...
            );
            */
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "configuraciones",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "impuestos",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "metodos_pago",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "series_comprobantes",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "sucursales",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "tablas_generales_detalle",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "tipos_comprobantes",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "empresa",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "tablas_generales",
                schema: "configuracion");
        }
    }
}
