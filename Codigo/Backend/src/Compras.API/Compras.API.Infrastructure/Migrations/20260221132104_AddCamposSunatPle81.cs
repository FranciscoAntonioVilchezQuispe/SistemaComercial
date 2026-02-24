using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Compras.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCamposSunatPle81 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "afectacion_igv",
                schema: "compras",
                table: "detalle_compra",
                type: "character varying(1)",
                maxLength: 1,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "base_exonerada",
                schema: "compras",
                table: "compras",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "base_gravada",
                schema: "compras",
                table: "compras",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<decimal>(
                name: "base_inafecta",
                schema: "compras",
                table: "compras",
                type: "numeric(12,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_vencimiento",
                schema: "compras",
                table: "compras",
                type: "timestamp with time zone",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "afectacion_igv",
                schema: "compras",
                table: "detalle_compra");

            migrationBuilder.DropColumn(
                name: "base_exonerada",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "base_gravada",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "base_inafecta",
                schema: "compras",
                table: "compras");

            migrationBuilder.DropColumn(
                name: "fecha_vencimiento",
                schema: "compras",
                table: "compras");
        }
    }
}
