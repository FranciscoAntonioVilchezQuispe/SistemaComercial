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
            var tables = new[] { "proveedores", "compras", "ordenes_compra", "detalle_compra", "detalle_orden_compra" };

            foreach (var table in tables)
            {
                migrationBuilder.Sql($@"
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name='{table}' AND column_name='activado') THEN
        ALTER TABLE compras.{table} ADD COLUMN activado boolean NOT NULL DEFAULT true;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name='{table}' AND column_name='fecha_creacion') THEN
        ALTER TABLE compras.{table} ADD COLUMN fecha_creacion timestamp with time zone NOT NULL DEFAULT (now() at time zone 'utc');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name='{table}' AND column_name='usuario_creacion') THEN
        ALTER TABLE compras.{table} ADD COLUMN usuario_creacion character varying(50) NOT NULL DEFAULT 'SISTEMA';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name='{table}' AND column_name='fecha_modificacion') THEN
        ALTER TABLE compras.{table} ADD COLUMN fecha_modificacion timestamp with time zone;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='compras' AND table_name='{table}' AND column_name='usuario_modificacion') THEN
        ALTER TABLE compras.{table} ADD COLUMN usuario_modificacion character varying(50);
    END IF;
END
$$;");
            }
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Opcional: No eliminamos para no perder datos si ya existían
        }
    }
}
