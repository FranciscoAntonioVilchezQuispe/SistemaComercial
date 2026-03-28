using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Clientes.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddSunatFieldsToCliente : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "condicion_sunat",
                schema: "clientes",
                table: "clientes",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "es_agente_percepcion",
                schema: "clientes",
                table: "clientes",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_agente_retencion",
                schema: "clientes",
                table: "clientes",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "es_buen_contribuyente",
                schema: "clientes",
                table: "clientes",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "estado_sunat",
                schema: "clientes",
                table: "clientes",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_ultima_consulta_sunat",
                schema: "clientes",
                table: "clientes",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ubigeo",
                schema: "clientes",
                table: "clientes",
                type: "character varying(6)",
                maxLength: 6,
                nullable: true);

            // --- SQL Manual: Reseteo de secuencia e Índices SUNAT ---
            migrationBuilder.Sql(@"
                DO $$
                BEGIN
                    -- Reseteo de secuencia para evitar error 23505 (llave duplicada)
                    PERFORM setval('clientes.clientes_id_cliente_seq', (SELECT COALESCE(MAX(id_cliente), 0) FROM clientes.clientes) + 1);
                END $$;
            ");

            migrationBuilder.Sql(@"
                CREATE UNIQUE INDEX IF NOT EXISTS uq_clientes_numero_documento 
                ON clientes.clientes(numero_documento) WHERE activado = true;
                
                -- Índice GIN para búsqueda rápida por razón social
                CREATE INDEX IF NOT EXISTS idx_clientes_razon_social 
                ON clientes.clientes USING gin(to_tsvector('spanish', razon_social));
            ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "condicion_sunat",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "es_agente_percepcion",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "es_agente_retencion",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "es_buen_contribuyente",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "estado_sunat",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "fecha_ultima_consulta_sunat",
                schema: "clientes",
                table: "clientes");

            migrationBuilder.DropColumn(
                name: "ubigeo",
                schema: "clientes",
                table: "clientes");
        }
    }
}
