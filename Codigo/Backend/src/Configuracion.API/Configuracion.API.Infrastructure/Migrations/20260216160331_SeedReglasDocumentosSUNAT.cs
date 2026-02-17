using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SeedReglasDocumentosSUNAT : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                INSERT INTO configuracion.""DOCUMENTOIDENTIDAD"" (codigo, nombre, longitud, es_numerico, estado, activado, fecha_creacion, usuario_creacion)
                SELECT '1', 'DNI', 8, true, true, true, NOW(), 'SISTEMA'
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.""DOCUMENTOIDENTIDAD"" WHERE codigo = '1');
                
                INSERT INTO configuracion.""DOCUMENTOIDENTIDAD"" (codigo, nombre, longitud, es_numerico, estado, activado, fecha_creacion, usuario_creacion)
                SELECT '6', 'RUC', 11, true, true, true, NOW(), 'SISTEMA'
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.""DOCUMENTOIDENTIDAD"" WHERE codigo = '6');

                INSERT INTO configuracion.""DOCUMENTOIDENTIDAD"" (codigo, nombre, longitud, es_numerico, estado, activado, fecha_creacion, usuario_creacion)
                SELECT '4', 'CARNET EXTRANJERIA', 12, false, true, true, NOW(), 'SISTEMA'
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.""DOCUMENTOIDENTIDAD"" WHERE codigo = '4');

                INSERT INTO configuracion.""DOCUMENTOIDENTIDAD"" (codigo, nombre, longitud, es_numerico, estado, activado, fecha_creacion, usuario_creacion)
                SELECT '7', 'PASAPORTE', 12, false, true, true, NOW(), 'SISTEMA'
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.""DOCUMENTOIDENTIDAD"" WHERE codigo = '7');
            ");
        }




        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
