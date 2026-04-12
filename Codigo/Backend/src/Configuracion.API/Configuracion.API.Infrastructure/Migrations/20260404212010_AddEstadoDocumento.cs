using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddEstadoDocumento : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "tablas_generales",
                schema: "configuracion",
                columns: new[] { "id_tabla", "codigo", "nombre", "descripcion", "es_sistema", "activado", "fecha_creacion", "usuario_creacion" },
                values: new object[] { 15L, "ESTADO_DOC", "Estado de Documento Comercial", "Estados para Compra, NC y ND", true, true, DateTime.UtcNow, "SISTEMA" }
            );

            migrationBuilder.InsertData(
                table: "tablas_generales_detalle",
                schema: "configuracion",
                columns: new[] { "id_detalle", "id_tabla", "codigo", "nombre", "orden", "estado", "activado", "fecha_creacion", "usuario_creacion" },
                values: new object[,]
                {
                    { 60L, 15L, "REG", "Registrado", 1, true, true, DateTime.UtcNow, "SISTEMA" },
                    { 61L, 15L, "ANUL", "Anulado", 2, true, true, DateTime.UtcNow, "SISTEMA" },
                    { 62L, 15L, "RECH", "Rechazado", 3, true, true, DateTime.UtcNow, "SISTEMA" },
                    { 63L, 15L, "PEND", "Pendiente", 4, true, true, DateTime.UtcNow, "SISTEMA" }
                }
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "tablas_generales_detalle",
                schema: "configuracion",
                keyColumn: "id_detalle",
                keyValue: 60L);
            migrationBuilder.DeleteData(
                table: "tablas_generales_detalle",
                schema: "configuracion",
                keyColumn: "id_detalle",
                keyValue: 61L);
            migrationBuilder.DeleteData(
                table: "tablas_generales_detalle",
                schema: "configuracion",
                keyColumn: "id_detalle",
                keyValue: 62L);
            migrationBuilder.DeleteData(
                table: "tablas_generales_detalle",
                schema: "configuracion",
                keyColumn: "id_detalle",
                keyValue: 63L);
            migrationBuilder.DeleteData(
                table: "tablas_generales",
                schema: "configuracion",
                keyColumn: "id_tabla",
                keyValue: 15L);
        }
    }
}
