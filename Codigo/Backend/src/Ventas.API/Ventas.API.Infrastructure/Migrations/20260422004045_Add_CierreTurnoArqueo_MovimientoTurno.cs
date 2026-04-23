using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Ventas.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class Add_CierreTurnoArqueo_MovimientoTurno : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<long>(
                name: "id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja",
                type: "bigint",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "diferencia_arqueo",
                schema: "ventas",
                table: "cierre_turno",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "monto_esperado",
                schema: "ventas",
                table: "cierre_turno",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "monto_fisico_contado",
                schema: "ventas",
                table: "cierre_turno",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "total_egresos_manuales",
                schema: "ventas",
                table: "cierre_turno",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "total_ingresos_manuales",
                schema: "ventas",
                table: "cierre_turno",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.CreateIndex(
                name: "ix_movimientos_caja_id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja",
                column: "id_turno_vendedor");

            migrationBuilder.AddForeignKey(
                name: "fk_movimientos_caja_turno_vendedor_id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja",
                column: "id_turno_vendedor",
                principalSchema: "ventas",
                principalTable: "turno_vendedor",
                principalColumn: "id_turno_vendedor");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_movimientos_caja_turno_vendedor_id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja");

            migrationBuilder.DropIndex(
                name: "ix_movimientos_caja_id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja");

            migrationBuilder.DropColumn(
                name: "id_turno_vendedor",
                schema: "ventas",
                table: "movimientos_caja");

            migrationBuilder.DropColumn(
                name: "diferencia_arqueo",
                schema: "ventas",
                table: "cierre_turno");

            migrationBuilder.DropColumn(
                name: "monto_esperado",
                schema: "ventas",
                table: "cierre_turno");

            migrationBuilder.DropColumn(
                name: "monto_fisico_contado",
                schema: "ventas",
                table: "cierre_turno");

            migrationBuilder.DropColumn(
                name: "total_egresos_manuales",
                schema: "ventas",
                table: "cierre_turno");

            migrationBuilder.DropColumn(
                name: "total_ingresos_manuales",
                schema: "ventas",
                table: "cierre_turno");
        }
    }
}
