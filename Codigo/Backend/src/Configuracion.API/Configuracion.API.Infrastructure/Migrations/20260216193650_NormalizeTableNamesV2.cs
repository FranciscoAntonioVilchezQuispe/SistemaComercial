using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class NormalizeTableNamesV2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Renombrar tablas
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.tipos_comprobantes RENAME TO tipo_comprobante;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.impuestos RENAME TO impuesto;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.sucursales RENAME TO sucursal;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.metodos_pago RENAME TO metodo_pago;");

            // Renombrar tablas SUNAT (pueden estar en mayúsculas por migraciones previas)
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.\"DOCUMENTOIDENTIDAD\" RENAME TO tipo_documento;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.documentoidentidad RENAME TO tipo_documento;");

            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.\"DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE\" RENAME TO regla_documento_comprobante;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.documentoidentidad_documentocomprobante RENAME TO regla_documento_comprobante;");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.impuesto RENAME CONSTRAINT pk_impuesto TO pk_impuestos;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.sucursal RENAME CONSTRAINT pk_sucursal TO pk_sucursales;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.metodo_pago RENAME CONSTRAINT pk_metodo_pago TO pk_metodos_pago;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.tipo_documento RENAME CONSTRAINT pk_tipo_documento TO pk_documentoidentidad;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.regla_documento_comprobante RENAME CONSTRAINT pk_regla_documento_comprobante TO pk_documentoidentidad_documentocomprobante;");

            // Revertir tablas
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.tipo_comprobante RENAME TO tipos_comprobantes;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.impuesto RENAME TO impuestos;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.sucursal RENAME TO sucursales;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.metodo_pago RENAME TO metodos_pago;");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.tipo_documento RENAME TO \"DOCUMENTOIDENTIDAD\";");
            migrationBuilder.Sql("ALTER TABLE IF EXISTS configuracion.regla_documento_comprobante RENAME TO \"DOCUMENTOIDENTIDAD_DOCUMENTOCOMPROBANTE\";");
        }

    }
}
