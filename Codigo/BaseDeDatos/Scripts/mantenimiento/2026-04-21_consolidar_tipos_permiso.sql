-- SCRIPT: consolidar_tipos_permiso.sql
-- Fecha: 2026-04-21
-- Propósito: Eliminar redundancias en tipos de permiso (Inglés vs Español) y migrar referencias.

DO $$ 
DECLARE
    tipo_rec RECORD;
    new_tipo_id bigint;
BEGIN
    RAISE NOTICE 'Iniciando consolidación de tipos de permiso...';

    -- 1. Asegurar que los códigos en español existen con nombres normalizados
    INSERT INTO identidad.tipos_permiso (codigo, nombre, descripcion, usuario_creacion)
    VALUES 
        ('VER',      'Ver',      'Permite visualizar registros y listados', 'SISTEMA'),
        ('CREAR',    'Crear',    'Permite registrar nuevos datos', 'SISTEMA'),
        ('EDITAR',   'Editar',   'Permite modificar datos existentes', 'SISTEMA'),
        ('ELIMINAR', 'Eliminar', 'Permite eliminar registros', 'SISTEMA'),
        ('ANULAR',   'Anular',   'Permite anular documentos o transacciones', 'SISTEMA'),
        ('APROBAR',  'Aprobar',  'Permite aprobar transacciones o documentos', 'SISTEMA'),
        ('IMPRIMIR', 'Imprimir', 'Permite imprimir documentos', 'SISTEMA'),
        ('EXPORTAR', 'Exportar', 'Permite exportar datos a otros formatos', 'SISTEMA'),
        ('IMPORTAR', 'Importar', 'Permite importar datos desde archivos', 'SISTEMA')
    ON CONFLICT (codigo) DO UPDATE SET 
        nombre = EXCLUDED.nombre,
        descripcion = EXCLUDED.descripcion;

    -- 2. Migrar referencias de códigos en inglés a español
    -- Mapeo: CREATE->CREAR, READ->VER, UPDATE->EDITAR, DELETE->ELIMINAR, EXPORT->EXPORTAR, APPROVE->APROBAR, PRINT->IMPRIMIR, CANCEL->ANULAR, IMPORT->IMPORTAR
    
    FOR tipo_rec IN 
        SELECT id_tipo_permiso, codigo FROM identidad.tipos_permiso 
        WHERE codigo IN ('CREATE', 'READ', 'UPDATE', 'DELETE', 'EXPORT', 'APPROVE', 'PRINT', 'CANCEL', 'IMPORT')
    LOOP
        RAISE NOTICE 'Migrando código redundante: %', tipo_rec.codigo;

        -- Buscar el equivalente en español
        SELECT id_tipo_permiso INTO new_tipo_id FROM identidad.tipos_permiso 
        WHERE codigo = CASE tipo_rec.codigo
            WHEN 'CREATE'  THEN 'CREAR'
            WHEN 'READ'    THEN 'VER'
            WHEN 'UPDATE'  THEN 'EDITAR'
            WHEN 'DELETE'  THEN 'ELIMINAR'
            WHEN 'EXPORT'  THEN 'EXPORTAR'
            WHEN 'APPROVE' THEN 'APROBAR'
            WHEN 'PRINT'   THEN 'IMPRIMIR'
            WHEN 'CANCEL'  THEN 'ANULAR'
            WHEN 'IMPORT'  THEN 'IMPORTAR'
        END;

        IF new_tipo_id IS NOT NULL THEN
            -- Reasignar permisos de roles a los nuevos IDs
            INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, usuario_creacion)
            SELECT id_rol_menu, new_tipo_id, 'MIGRACION'
            FROM identidad.roles_menus_permisos
            WHERE id_tipo_permiso = tipo_rec.id_tipo_permiso
            ON CONFLICT (id_rol_menu, id_tipo_permiso) DO NOTHING;

            -- Limpiar referencias antiguas antes de borrar el tipo
            DELETE FROM identidad.roles_menus_permisos WHERE id_tipo_permiso = tipo_rec.id_tipo_permiso;
        END IF;

        -- 3. Eliminar el registro redundante (Inglés)
        DELETE FROM identidad.tipos_permiso WHERE id_tipo_permiso = tipo_rec.id_tipo_permiso;
    END LOOP;

    RAISE NOTICE 'Consolidación completada exitosamente.';
END $$;
