-- SCRIPT: seed_roles_base.sql
-- Propósito: Asegurar la existencia de roles y permisos base para el módulo de seguridad.
-- Autor: Antigravity AI

DO $$
DECLARE
    admin_rol_id bigint;
    vendedor_rol_id bigint;
    menu_record RECORD;
    tipo_ver_id bigint;
    tipo_crear_id bigint;
    tipo_editar_id bigint;
    tipo_eliminar_id bigint;
    rol_menu_id bigint;
BEGIN
    -- 1. Asegurar tipos de permiso base
    INSERT INTO identidad.tipos_permiso (codigo, nombre, descripcion, usuario_creacion)
    VALUES 
        ('VER', 'Ver', 'Permite visualizar el menú y listados', 'SISTEMA'),
        ('CREAR', 'Crear', 'Permite registrar nuevos elementos', 'SISTEMA'),
        ('EDITAR', 'Editar', 'Permite modificar elementos existentes', 'SISTEMA'),
        ('ELIMINAR', 'Eliminar', 'Permite anular o eliminar elementos', 'SISTEMA')
    ON CONFLICT (codigo) DO NOTHING;

    SELECT id_tipo_permiso INTO tipo_ver_id FROM identidad.tipos_permiso WHERE codigo = 'VER';
    SELECT id_tipo_permiso INTO tipo_crear_id FROM identidad.tipos_permiso WHERE codigo = 'CREAR';
    SELECT id_tipo_permiso INTO tipo_editar_id FROM identidad.tipos_permiso WHERE codigo = 'EDITAR';
    SELECT id_tipo_permiso INTO tipo_eliminar_id FROM identidad.tipos_permiso WHERE codigo = 'ELIMINAR';

    -- 2. Asegurar Roles Base
    INSERT INTO identidad.roles (nombre_rol, descripcion, usuario_creacion)
    VALUES ('ADMINISTRADOR', 'Acceso total al sistema', 'SISTEMA')
    ON CONFLICT (nombre_rol) DO NOTHING;
    
    INSERT INTO identidad.roles (nombre_rol, descripcion, usuario_creacion)
    VALUES ('VENDEDOR', 'Acceso a ventas y stock', 'SISTEMA')
    ON CONFLICT (nombre_rol) DO NOTHING;

    SELECT id_rol INTO admin_rol_id FROM identidad.roles WHERE nombre_rol = 'ADMINISTRADOR';
    SELECT id_rol INTO vendedor_rol_id FROM identidad.roles WHERE nombre_rol = 'VENDEDOR';

    -- 3. Asignar TODOS los menús con TODOS los permisos al ADMINISTRADOR
    FOR menu_record IN SELECT id_menu FROM identidad.menus WHERE activado = true
    LOOP
        -- Vincular menú al rol (identidad.roles_menus)
        INSERT INTO identidad.roles_menus (id_rol, id_menu, usuario_creacion)
        VALUES (admin_rol_id, menu_record.id_menu, 'SISTEMA')
        ON CONFLICT (id_rol, id_menu) DO NOTHING;

        SELECT id_rol_menu INTO rol_menu_id 
        FROM identidad.roles_menus 
        WHERE id_rol = admin_rol_id AND id_menu = menu_record.id_menu;

        -- Asignar los 4 permisos base al menú para este rol
        INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, usuario_creacion)
        VALUES 
            (rol_menu_id, tipo_ver_id, 'SISTEMA'),
            (rol_menu_id, tipo_crear_id, 'SISTEMA'),
            (rol_menu_id, tipo_editar_id, 'SISTEMA'),
            (rol_menu_id, tipo_eliminar_id, 'SISTEMA')
        ON CONFLICT (id_rol_menu, id_tipo_permiso) DO NOTHING;
    END LOOP;

    RAISE NOTICE 'Sincronización de roles y permisos base completada.';
END $$;
