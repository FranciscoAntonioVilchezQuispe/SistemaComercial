using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Configuracion.API.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class SyncSunatMasterData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Bloque SQL Nuclear para sincronizar tipo_afectacion_igv
            migrationBuilder.Sql(@"
                DO $$ 
                BEGIN 
                    -- 0. Eliminar vistas dependientes para evitar errores de dependencia
                    DROP VIEW IF EXISTS vistas.vw_detalle_venta;

                    -- 1. Manejo de la tabla tipo_afectacion_igv
                    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv') THEN
                        
                        -- Renombrar codigo a codigo_sunat si existe
                        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'codigo') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv RENAME COLUMN codigo TO codigo_sunat;
                        END IF;

                        -- Agregar columnas faltantes si no existen
                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'descripcion') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN descripcion VARCHAR(150);
                            -- Migrar datos de 'nombre' a 'descripcion' si 'nombre' existe
                            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'nombre') THEN
                                UPDATE configuracion.tipo_afectacion_igv SET descripcion = nombre;
                                ALTER TABLE configuracion.tipo_afectacion_igv DROP COLUMN nombre;
                            END IF;
                            ALTER TABLE configuracion.tipo_afectacion_igv ALTER COLUMN descripcion SET NOT NULL;
                        END IF;

                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'es_gravado') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN es_gravado BOOLEAN DEFAULT FALSE;
                            -- Inferir de afecta_igv
                            IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'afecta_igv') THEN
                                UPDATE configuracion.tipo_afectacion_igv SET es_gravado = afecta_igv;
                                ALTER TABLE configuracion.tipo_afectacion_igv DROP COLUMN afecta_igv;
                            END IF;
                            ALTER TABLE configuracion.tipo_afectacion_igv ALTER COLUMN es_gravado SET NOT NULL;
                        END IF;

                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'es_exonerado') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN es_exonerado BOOLEAN DEFAULT FALSE NOT NULL;
                            UPDATE configuracion.tipo_afectacion_igv SET es_exonerado = TRUE WHERE codigo_sunat LIKE '2%';
                        END IF;

                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'es_inafecto') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN es_inafecto BOOLEAN DEFAULT FALSE NOT NULL;
                            UPDATE configuracion.tipo_afectacion_igv SET es_inafecto = TRUE WHERE codigo_sunat LIKE '3%';
                        END IF;

                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'es_gratuito') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN es_gratuito BOOLEAN DEFAULT FALSE NOT NULL;
                            UPDATE configuracion.tipo_afectacion_igv SET es_gratuito = TRUE WHERE codigo_sunat NOT IN ('10', '20', '30', '40');
                        END IF;

                        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'configuracion' AND table_name = 'tipo_afectacion_igv' AND column_name = 'codigo_tributo_default') THEN
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN codigo_tributo_default VARCHAR(4);
                            ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN nombre_tributo_default VARCHAR(10);
                        END IF;

                    ELSE
                        -- Si no existe, crearla
                        CREATE TABLE configuracion.tipo_afectacion_igv (
                            id_afectacion BIGSERIAL PRIMARY KEY,
                            codigo_sunat VARCHAR(2) NOT NULL,
                            descripcion VARCHAR(150) NOT NULL,
                            es_gravado BOOLEAN NOT NULL,
                            es_exonerado BOOLEAN NOT NULL,
                            es_inafecto BOOLEAN NOT NULL,
                            es_gratuito BOOLEAN NOT NULL,
                            codigo_tributo_default VARCHAR(4),
                            nombre_tributo_default VARCHAR(10),
                            activado BOOLEAN DEFAULT TRUE NOT NULL,
                            fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
                            usuario_creacion VARCHAR(100) DEFAULT 'SISTEMA' NOT NULL,
                            fecha_modificacion TIMESTAMP WITH TIME ZONE,
                            usuario_modificacion VARCHAR(100)
                        );
                    END IF;

                    -- 2. Manejo de la tabla tipo_tributo
                    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'configuracion' AND table_name = 'tipo_tributo') THEN
                        CREATE TABLE configuracion.tipo_tributo (
                            id_tributo BIGSERIAL PRIMARY KEY,
                            codigo_sunat VARCHAR(4) NOT NULL,
                            nombre VARCHAR(100) NOT NULL,
                            codigo_internacional VARCHAR(10) NOT NULL,
                            descripcion VARCHAR(200),
                            activado BOOLEAN DEFAULT TRUE NOT NULL,
                            fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
                            usuario_creacion VARCHAR(100) DEFAULT 'SISTEMA' NOT NULL,
                            fecha_modificacion TIMESTAMP WITH TIME ZONE,
                            usuario_modificacion VARCHAR(100)
                        );
                    END IF;

                    -- 3. Recrear vistas con los nuevos nombres de columna
                    CREATE OR REPLACE VIEW vistas.vw_detalle_venta AS
                    SELECT 
                        d.id_detalle_venta, d.id_venta, p.id_producto, p.codigo_producto, d.descripcion_producto,
                        um.codigo_sunat AS codigo_unidad_medida, um.simbolo AS simbolo_unidad,
                        d.cantidad, d.precio_unitario_base, d.precio_unitario AS precio_unitario_con_igv,
                        d.descuento_item, d.valor_item,
                        ta.codigo_sunat AS codigo_afectacion_igv, ta.descripcion AS nombre_afectacion_igv,
                        d.codigo_tributo, d.porcentaje_impuesto AS porcentaje_igv, d.impuesto_item, d.total_item
                    FROM ventas.detalle_venta d
                    JOIN catalogo.productos p ON d.id_producto = p.id_producto
                    JOIN catalogo.unidades_medida um ON p.id_unidad = um.id_unidad
                    LEFT JOIN configuracion.tipo_afectacion_igv ta ON d.codigo_afectacion_igv = ta.id_afectacion::text OR d.codigo_afectacion_igv = ta.codigo_sunat;
                END $$;
            ");
        }



        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "tipo_tributo",
                schema: "configuracion");

            migrationBuilder.DropTable(
                name: "tipo_afectacion_igv",
                schema: "configuracion");
        }
    }
}
