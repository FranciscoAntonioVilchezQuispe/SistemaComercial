using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Inventario.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AumentarLogMotivoKardex : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
            DO $$ 
            BEGIN 
                ALTER TABLE inventario.inv_kardex_recalculo_log ALTER COLUMN motivo TYPE varchar(250);
            EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'AlterColumn for motivo already applied or failed';
            END $$;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "configuracion");

            migrationBuilder.AlterColumn<string>(
                name: "motivo",
                schema: "inventario",
                table: "inv_kardex_recalculo_log",
                type: "character varying(30)",
                maxLength: 30,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(250)",
                oldMaxLength: 250);
        }
    }
}
