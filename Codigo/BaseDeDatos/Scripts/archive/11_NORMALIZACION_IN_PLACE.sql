-- *****************************************************************************
-- SCRIPT DE NORMALIZACIÓN GLOBAL IN-PLACE - SISTEMA COMERCIAL
-- *****************************************************************************
-- Descripción: Este script sincroniza la base de datos PostgreSQL con el modelo 
--              de negocio (C#), normalizando tipos de fecha a UTC y tamaños 
--              de campos de auditoría sin pérdida de datos.
-- Autor: Antigravity AI (Google DeepMind)
-- Fecha: 2026-03-29
-- *****************************************************************************

DO $$
DECLARE
    r RECORD;
    target_schemas text[] := ARRAY['ventas', 'catalogo', 'public', 'inventario', 'contabilidad', 'identidad', 'clientes', 'compras'];
BEGIN
    RAISE NOTICE 'Iniciando normalización de tipos de datos y auditoría...';

    -- 1. NORMALIZACIÓN DE TIPOS DE FECHA Y LONGITUD DE USUARIOS
    FOR r IN 
        SELECT table_schema, table_name, column_name, data_type, character_maximum_length
        FROM information_schema.columns 
        WHERE table_schema = ANY(target_schemas)
          AND table_type = 'BASE TABLE'
          AND column_name IN ('fecha_creacion', 'fecha_modificacion', 'usuario_creacion', 'usuario_modificacion')
    LOOP
        -- A. Convertir timestamp a timestamp with time zone (UTC)
        IF r.data_type = 'timestamp without time zone' THEN
            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE timestamp with time zone USING %I AT TIME ZONE ''UTC''', 
                           r.table_schema, r.table_name, r.column_name, r.column_name);
            RAISE NOTICE 'Normalizada fecha a UTC en %.%.%', r.table_schema, r.table_name, r.column_name;
        END IF;

        -- B. Ampliar varchar de usuario a 100 si es menor
        IF r.data_type = 'character varying' AND (r.character_maximum_length < 100 OR r.character_maximum_length IS NULL) THEN
            EXECUTE format('ALTER TABLE %I.%I ALTER COLUMN %I TYPE character varying(100)', 
                           r.table_schema, r.table_name, r.column_name);
            RAISE NOTICE 'Ampliado varchar a 100 en %.%.%', r.table_schema, r.table_name, r.column_name;
        END IF;
    END LOOP;

    -- 2. ELIMINACIÓN DE TABLAS DE MIGRACIÓN DUPLICADAS
    -- Se mantiene __EFMigrationsHistory (estándar de .NET) y se elimina __ef_migrations_history
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'clientes' AND table_name = '__ef_migrations_history') THEN
        DROP TABLE clientes.__ef_migrations_history;
        RAISE NOTICE 'Eliminada tabla duplicada clientes.__ef_migrations_history';
    END IF;

    RAISE NOTICE 'Normalización global in-place completada exitosamente.';
END $$;

-- 3. REPORTE DE VERIFICACIÓN
SELECT table_schema, table_name, column_name, data_type, character_maximum_length
FROM information_schema.columns 
WHERE table_schema IN ('ventas', 'catalogo', 'public', 'inventario', 'contabilidad', 'identidad', 'clientes', 'compras')
  AND column_name IN ('fecha_creacion', 'fecha_modificacion', 'usuario_creacion', 'usuario_modificacion')
ORDER BY table_schema, table_name, column_name;
