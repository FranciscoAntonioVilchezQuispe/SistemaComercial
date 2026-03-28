using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class FixDetalleAudit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Migración baselined: los cambios ya existen en la base de datos.
            // Vaciada manualmente para evitar conflictos por columnas ya existentes.
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Opcional: No eliminamos para no perder datos si ya existían
        }
    }
}
