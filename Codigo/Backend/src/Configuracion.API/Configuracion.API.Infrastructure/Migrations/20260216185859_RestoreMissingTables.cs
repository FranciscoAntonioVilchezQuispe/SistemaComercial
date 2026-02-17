using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RestoreMissingTables : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // 1. CREACIÓN DE TABLAS (SI NO EXISTEN)
            migrationBuilder.Sql(@"
                CREATE TABLE IF NOT EXISTS configuracion.tipos_comprobantes (
                    id_tipo_comprobante BIGSERIAL PRIMARY KEY,
                    codigo VARCHAR(10) NOT NULL,
                    nombre VARCHAR(100) NOT NULL,
                    mueve_stock BOOLEAN NOT NULL DEFAULT false,
                    tipo_movimiento_stock VARCHAR(20) NOT NULL DEFAULT 'DEPENDIENTE',
                    activado BOOLEAN NOT NULL DEFAULT true,
                    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
                    usuario_creacion VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
                    fecha_modificacion TIMESTAMP WITH TIME ZONE,
                    usuario_modificacion VARCHAR(50)
                );

                CREATE TABLE IF NOT EXISTS configuracion.impuestos (
                    id_impuesto BIGSERIAL PRIMARY KEY,
                    codigo VARCHAR(10) NOT NULL,
                    nombre VARCHAR(100) NOT NULL,
                    porcentaje DECIMAL(5,2) NOT NULL DEFAULT 0,
                    es_igv BOOLEAN NOT NULL DEFAULT false,
                    activado BOOLEAN NOT NULL DEFAULT true,
                    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
                    usuario_creacion VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
                    fecha_modificacion TIMESTAMP WITH TIME ZONE,
                    usuario_modificacion VARCHAR(50)
                );

                CREATE TABLE IF NOT EXISTS configuracion.sucursales (
                    id_sucursal BIGSERIAL PRIMARY KEY,
                    id_empresa BIGINT NOT NULL,
                    nombre_sucursal VARCHAR(100) NOT NULL,
                    direccion VARCHAR(255),
                    telefono VARCHAR(50),
                    es_principal BOOLEAN NOT NULL DEFAULT false,
                    activado BOOLEAN NOT NULL DEFAULT true,
                    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
                    usuario_creacion VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
                    fecha_modificacion TIMESTAMP WITH TIME ZONE,
                    usuario_modificacion VARCHAR(50)
                );

                CREATE TABLE IF NOT EXISTS configuracion.metodos_pago (
                    id_metodo_pago BIGSERIAL PRIMARY KEY,
                    codigo VARCHAR(20) NOT NULL,
                    nombre VARCHAR(100) NOT NULL,
                    es_efectivo BOOLEAN NOT NULL DEFAULT false,
                    id_tipo_documento_pago BIGINT,
                    activado BOOLEAN NOT NULL DEFAULT true,
                    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
                    usuario_creacion VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
                    fecha_modificacion TIMESTAMP WITH TIME ZONE,
                    usuario_modificacion VARCHAR(50)
                );

                CREATE TABLE IF NOT EXISTS configuracion.configuraciones (
                    id_configuracion BIGSERIAL PRIMARY KEY,
                    clave VARCHAR(100) NOT NULL,
                    valor TEXT NOT NULL,
                    descripcion VARCHAR(255),
                    grupo VARCHAR(50),
                    activado BOOLEAN NOT NULL DEFAULT true,
                    fecha_creacion TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
                    usuario_creacion VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
                    fecha_modificacion TIMESTAMP WITH TIME ZONE,
                    usuario_modificacion VARCHAR(50)
                );
            ");

            // 2. SIEMBRA DE DATOS BÁSICOS
            migrationBuilder.Sql(@"
                INSERT INTO configuracion.tipos_comprobantes (codigo, nombre, mueve_stock, tipo_movimiento_stock, activado, usuario_creacion, fecha_creacion)
                SELECT '01', 'FACTURA', false, 'NEUTRO', true, 'SYSTEM', NOW()
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.tipos_comprobantes WHERE codigo = '01');

                INSERT INTO configuracion.tipos_comprobantes (codigo, nombre, mueve_stock, tipo_movimiento_stock, activado, usuario_creacion, fecha_creacion)
                SELECT '03', 'BOLETA DE VENTA', false, 'NEUTRO', true, 'SYSTEM', NOW()
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.tipos_comprobantes WHERE codigo = '03');

                INSERT INTO configuracion.impuestos (codigo, nombre, porcentaje, es_igv, activado, usuario_creacion, fecha_creacion)
                SELECT '1000', 'IGV', 18.00, true, true, 'SYSTEM', NOW()
                WHERE NOT EXISTS (SELECT 1 FROM configuracion.impuestos WHERE codigo = '1000');
            ");
        }


        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
