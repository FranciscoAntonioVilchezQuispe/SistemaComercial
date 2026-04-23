-- ============================================================================
-- SCRIPT: seed_roles_base.sql
-- DESCRIPCIÓN: Script semilla idempotente para el rol ADMINISTRADOR y permisos base.
-- SCHEMA: identidad
-- FECHA: 2026-04-20
-- ============================================================================

DO $$ 
DECLARE 
    v_usuario_creacion VARCHAR := 'system';
    v_fecha_creacion TIMESTAMP := NOW();
    v_rol_admin_id BIGINT;
    v_tipo_permiso_ids BIGINT[];
    v_menu_record RECORD;
    v_rol_menu_id BIGINT;
    v_tipo_permiso_id BIGINT;
    v_count_roles_menus INTEGER := 0;
    v_count_permisos INTEGER := 0;
BEGIN
    RAISE NOTICE 'Iniciando seed de seguridad...';

    -- 1. INSERT del rol 'ADMINISTRADOR' si no existe
    INSERT INTO identidad.roles (nombre_rol, descripcion, activado, fecha_creacion, usuario_creacion)
    SELECT 'ADMINISTRADOR', 'Rol con acceso total al sistema', true, v_fecha_creacion, v_usuario_creacion
    WHERE NOT EXISTS (SELECT 1 FROM identidad.roles WHERE nombre_rol = 'ADMINISTRADOR')
    RETURNING id_rol INTO v_rol_admin_id;

    IF v_rol_admin_id IS NULL THEN
        SELECT id_rol INTO v_rol_admin_id FROM identidad.roles WHERE nombre_rol = 'ADMINISTRADOR';
        RAISE NOTICE 'Rol ADMINISTRADOR ya existe (ID: %)', v_rol_admin_id;
    ELSE
        RAISE NOTICE 'Rol ADMINISTRADOR creado (ID: %)', v_rol_admin_id;
    END IF;

    -- 2. INSERT de los 4 tipos de permiso (VER, CREAR, EDITAR, ELIMINAR)
    -- VER
    INSERT INTO identidad.tipos_permiso (codigo, nombre, activado, fecha_creacion, usuario_creacion)
    SELECT 'VER', 'Visualizar registros', true, v_fecha_creacion, v_usuario_creacion
    WHERE NOT EXISTS (SELECT 1 FROM identidad.tipos_permiso WHERE codigo = 'VER');
    
    -- CREAR
    INSERT INTO identidad.tipos_permiso (codigo, nombre, activado, fecha_creacion, usuario_creacion)
    SELECT 'CREAR', 'Crear nuevos registros', true, v_fecha_creacion, v_usuario_creacion
    WHERE NOT EXISTS (SELECT 1 FROM identidad.tipos_permiso WHERE codigo = 'CREAR');
    
    -- EDITAR
    INSERT INTO identidad.tipos_permiso (codigo, nombre, activado, fecha_creacion, usuario_creacion)
    SELECT 'EDITAR', 'Modificar registros existentes', true, v_fecha_creacion, v_usuario_creacion
    WHERE NOT EXISTS (SELECT 1 FROM identidad.tipos_permiso WHERE codigo = 'EDITAR');
    
    -- ELIMINAR
    INSERT INTO identidad.tipos_permiso (codigo, nombre, activado, fecha_creacion, usuario_creacion)
    SELECT 'ELIMINAR', 'Eliminar o desactivar registros', true, v_fecha_creacion, v_usuario_creacion
    WHERE NOT EXISTS (SELECT 1 FROM identidad.tipos_permiso WHERE codigo = 'ELIMINAR');

    -- Obtener IDs de tipos de permiso
    SELECT array_agg(id_tipo_permiso) INTO v_tipo_permiso_ids FROM identidad.tipos_permiso WHERE codigo IN ('VER', 'CREAR', 'EDITAR', 'ELIMINAR');

    -- 3. Vincular Menús al Rol ADMINISTRADOR
    FOR v_menu_record IN SELECT id_menu, codigo FROM identidad.menus LOOP
        
        -- Crear roles_menus si no existe para este rol y menú
        v_rol_menu_id := NULL;
        
        INSERT INTO identidad.roles_menus (id_rol, id_menu, fecha_creacion)
        SELECT v_rol_admin_id, v_menu_record.id_menu, v_fecha_creacion
        WHERE NOT EXISTS (SELECT 1 FROM identidad.roles_menus WHERE id_rol = v_rol_admin_id AND id_menu = v_menu_record.id_menu)
        RETURNING id_rol_menu INTO v_rol_menu_id;

        IF v_rol_menu_id IS NULL THEN
            SELECT id_rol_menu INTO v_rol_menu_id FROM identidad.roles_menus WHERE id_rol = v_rol_admin_id AND id_menu = v_menu_record.id_menu;
        ELSE
            v_count_roles_menus := v_count_roles_menus + 1;
        END IF;

        -- Para cada roles_menus, asignar los 4 tipos de permiso
        FOREACH v_tipo_permiso_id IN ARRAY v_tipo_permiso_ids LOOP
            INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso)
            SELECT v_rol_menu_id, v_tipo_permiso_id
            WHERE NOT EXISTS (SELECT 1 FROM identidad.roles_menus_permisos WHERE id_rol_menu = v_rol_menu_id AND id_tipo_permiso = v_tipo_permiso_id);
            
            IF FOUND THEN
                v_count_permisos := v_count_permisos + 1;
            END IF;
        END LOOP;

    END LOOP;

    RAISE NOTICE 'Proceso completado.';
    RAISE NOTICE 'Registros nuevos en roles_menus: %', v_count_roles_menus;
    RAISE NOTICE 'Registros nuevos en roles_menus_permisos: %', v_count_permisos;

END $$;
