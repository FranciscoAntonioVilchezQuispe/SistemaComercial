using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SeedMatrixCompatibilidadSUNAT : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // 1. Asegurar tipos de comprobante
            migrationBuilder.Sql(@"
                INSERT INTO configuracion.tipo_comprobante (codigo, nombre, mueve_stock, tipo_movimiento_stock, activado, usuario_creacion, fecha_creacion)
                SELECT '02', 'RECIBO POR HONORARIOS', false, 'NEUTRO', true, 'SYSTEM', NOW()
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.tipo_comprobante WHERE codigo = '02');

                INSERT INTO configuracion.tipo_comprobante (codigo, nombre, mueve_stock, tipo_movimiento_stock, activado, usuario_creacion, fecha_creacion)
                SELECT '04', 'LIQUIDACIÓN DE COMPRA', true, 'ENTRADA', true, 'SYSTEM', NOW()
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.tipo_comprobante WHERE codigo = '04');
            ");

            // 2. Asegurar tipos de documento
            migrationBuilder.Sql(@"
                INSERT INTO configuracion.tipo_documento (codigo, nombre, longitud, es_numerico, estado, activado, fecha_creacion, usuario_creacion)
                SELECT '0', 'SIN DOCUMENTO', 1, false, true, true, NOW(), 'SYSTEM'
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.tipo_documento WHERE codigo = '0');
            ");

            // 3. Limpiar relaciones previas para aplicar la matriz exacta
            migrationBuilder.Sql("DELETE FROM configuracion.regla_documento_comprobante;");

            // 4. Insertar relaciones según Matriz
            migrationBuilder.Sql(@"
                -- RUC (6) -> FACTURA(01), BOLETA(03), LIQ.COMPRA(04), RECIBO HON.(02)
                INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante, activado, usuario_creacion, fecha_creacion)
                SELECT '6', id_tipo_comprobante, true, 'SYSTEM', NOW() 
                FROM configuracion.tipo_comprobante WHERE codigo IN ('01', '02', '03', '04');

                -- DNI (1) -> BOLETA(03), RECIBO HON.(02)
                INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante, activado, usuario_creacion, fecha_creacion)
                SELECT '1', id_tipo_comprobante, true, 'SYSTEM', NOW() 
                FROM configuracion.tipo_comprobante WHERE codigo IN ('03', '02');

                -- CARNÉ EXTRANJERÍA (4) -> BOLETA(03)
                INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante, activado, usuario_creacion, fecha_creacion)
                SELECT '4', id_tipo_comprobante, true, 'SYSTEM', NOW() 
                FROM configuracion.tipo_comprobante WHERE codigo IN ('03');

                -- PASAPORTE (7) -> BOLETA(03)
                INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante, activado, usuario_creacion, fecha_creacion)
                SELECT '7', id_tipo_comprobante, true, 'SYSTEM', NOW() 
                FROM configuracion.tipo_comprobante WHERE codigo IN ('03');

                -- SIN DOCUMENTO (0) -> BOLETA(03)
                INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante, activado, usuario_creacion, fecha_creacion)
                SELECT '0', id_tipo_comprobante, true, 'SYSTEM', NOW() 
                FROM configuracion.tipo_comprobante WHERE codigo IN ('03');
            ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DELETE FROM configuracion.regla_documento_comprobante;");
        }
    }
}
