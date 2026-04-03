-- *****************************************************************************
-- SCRIPT MAESTRO DE ESTABILIZACIÓN GLOBAL - SISTEMA COMERCIAL
-- *****************************************************************************
-- Descripción: Este script normaliza la auditoría y estabiliza el esquema 
--              en todos los esquemas de negocio para asegurar compatibilidad 
--              con el modelo EntidadBase del backend .NET.
-- Autor: Antigravity AI (Google DeepMind)
-- Fecha: 2026-03-29
-- *****************************************************************************

-- 1. NORMALIZACIÓN DE COLUMNAS DE AUDITORÍA (IDEMPOTENTE)
DO $$
DECLARE
    r RECORD;
    -- Esquemas de negocio del sistema
    target_schemas text[] := ARRAY['ventas', 'catalogo', 'public', 'inventario', 'contabilidad', 'identidad', 'clientes', 'compras'];
BEGIN
    RAISE NOTICE 'Iniciando estabilización global de auditoría...';
    
    FOR r IN 
        SELECT table_schema, table_name 
        FROM information_schema.tables 
        WHERE table_schema = ANY(target_schemas)
          AND table_type = 'BASE TABLE'
          AND table_name NOT LIKE '%__EFMigrationsHistory%'
          AND table_name NOT LIKE '%ef_migrations%'
    LOOP
        -- Añadir fecha_modificacion si no existe
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                       WHERE table_schema = r.table_schema AND table_name = r.table_name AND column_name = 'fecha_modificacion') THEN
            EXECUTE format('ALTER TABLE %I.%I ADD COLUMN fecha_modificacion timestamp with time zone NULL', r.table_schema, r.table_name);
            RAISE NOTICE 'Añadida fecha_modificacion a %.%', r.table_schema, r.table_name;
        END IF;

        -- Añadir usuario_modificacion si no existe
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                       WHERE table_schema = r.table_schema AND table_name = r.table_name AND column_name = 'usuario_modificacion') THEN
            EXECUTE format('ALTER TABLE %I.%I ADD COLUMN usuario_modificacion character varying(50) NULL', r.table_schema, r.table_name);
            RAISE NOTICE 'Añadida usuario_modificacion a %.%', r.table_schema, r.table_name;
        END IF;
    END LOOP;
    
    RAISE NOTICE 'Estabilización global completada exitosamente.';
END $$;

-- 2. REPORTE DE CONSISTENCIA FINAL
SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_schema IN ('ventas', 'catalogo', 'public', 'inventario', 'contabilidad', 'identidad', 'clientes', 'compras')
  AND column_name IN ('fecha_modificacion', 'usuario_modificacion')
ORDER BY table_schema, table_name, column_name;
