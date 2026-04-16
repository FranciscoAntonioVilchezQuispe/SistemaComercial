-- SCRIPT DE INICIALIZACIÓN DE IDENTIDAD Y PERMISOS GRANULARES
-- Fecha: 2026-04-16

DO $$ 
BEGIN
    RAISE NOTICE 'Iniciando limpieza y refuerzo de integridad...';

    -- Asegurar restricciones únicas para permitir ON CONFLICT
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'menus_codigo_key') THEN
        ALTER TABLE identidad.menus ADD CONSTRAINT menus_codigo_key UNIQUE (codigo);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tipos_permiso_codigo_key') THEN
        ALTER TABLE identidad.tipos_permiso ADD CONSTRAINT tipos_permiso_codigo_key UNIQUE (codigo);
    END IF;

    RAISE NOTICE 'Poblando tipos de permiso...';
    -- 1. TIPOS DE PERMISO (CRUD+)
    INSERT INTO identidad.tipos_permiso (codigo, nombre, descripcion, fecha_creacion, usuario_creacion)
    VALUES 
    ('VER', 'Visualizar', 'Permitir ver la información y listados', NOW(), 'SISTEMA'),
    ('CREAR', 'Crear', 'Permitir registro de nuevos datos', NOW(), 'SISTEMA'),
    ('EDITAR', 'Editar', 'Permitir modificación de datos existentes', NOW(), 'SISTEMA'),
    ('ELIMINAR', 'Eliminar', 'Permitir borrado físico o lógico', NOW(), 'SISTEMA'),
    ('ANULAR', 'Anular', 'Permitir anulación de documentos (Ventas/Compras)', NOW(), 'SISTEMA'),
    ('EXPORTAR', 'Exportar', 'Permitir exportación a Excel/PDF', NOW(), 'SISTEMA')
    ON CONFLICT (codigo) DO NOTHING;

    RAISE NOTICE 'Poblando jerarquía de menús...';
    -- 2. MENÚS Y SUBMENÚS
    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, fecha_creacion, usuario_creacion)
    VALUES ('DASHBOARD', 'Dashboard', '/dashboard', 'LayoutDashboard', 1, NOW(), 'SISTEMA')
    ON CONFLICT (codigo) DO NOTHING;

    INSERT INTO identidad.menus (codigo, nombre, icono, orden, fecha_creacion, usuario_creacion)
    VALUES ('CATALOGO', 'Catálogo', 'Package', 2, NOW(), 'SISTEMA')
    ON CONFLICT (codigo) DO NOTHING;

    -- Subitems Catálogo
    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, id_menu_padre, fecha_creacion, usuario_creacion)
    SELECT 'CATALOGO_PRODUCTOS', 'Productos', '/catalogo/productos', 'Box', 1, id_menu, NOW(), 'SISTEMA' FROM identidad.menus WHERE codigo = 'CATALOGO'
    ON CONFLICT (codigo) DO NOTHING;
    
    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, id_menu_padre, fecha_creacion, usuario_creacion)
    SELECT 'CATALOGO_CATEGORIAS', 'Categorías', '/catalogo/categorias', 'FolderTree', 2, id_menu, NOW(), 'SISTEMA' FROM identidad.menus WHERE codigo = 'CATALOGO'
    ON CONFLICT (codigo) DO NOTHING;

    INSERT INTO identidad.menus (codigo, nombre, icono, orden, fecha_creacion, usuario_creacion)
    VALUES ('SEGURIDAD', 'Seguridad', 'ShieldCheck', 5, NOW(), 'SISTEMA')
    ON CONFLICT (codigo) DO NOTHING;

    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, id_menu_padre, fecha_creacion, usuario_creacion)
    SELECT 'SEGURIDAD_USUARIOS', 'Usuarios', '/seguridad/usuarios', 'Users', 1, id_menu, NOW(), 'SISTEMA' FROM identidad.menus WHERE codigo = 'SEGURIDAD'
    ON CONFLICT (codigo) DO NOTHING;
    
    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, id_menu_padre, fecha_creacion, usuario_creacion)
    SELECT 'SEGURIDAD_ROLES', 'Roles y Permisos', '/seguridad/roles', 'UserCheck', 2, id_menu, NOW(), 'SISTEMA' FROM identidad.menus WHERE codigo = 'SEGURIDAD'
    ON CONFLICT (codigo) DO NOTHING;

    INSERT INTO identidad.menus (codigo, nombre, ruta, icono, orden, id_menu_padre, fecha_creacion, usuario_creacion)
    SELECT 'SEGURIDAD_TRABAJADORES', 'Personal', '/seguridad/trabajadores', 'UserPlus', 3, id_menu, NOW(), 'SISTEMA' FROM identidad.menus WHERE codigo = 'SEGURIDAD'
    ON CONFLICT (codigo) DO NOTHING;

    RAISE NOTICE 'Configurando relación Usuario-Trabajador para Admin...';
    -- 3. TRABAJADOR OBLIGATORIO PARA ADMIN
    -- Primero creamos un trabajador si no existe
    IF NOT EXISTS (SELECT 1 FROM identidad.trabajadores WHERE numero_documento = '00000000') THEN
        INSERT INTO identidad.trabajadores (id_tipo_documento, numero_documento, nombres, apellidos, email_corporativo, fecha_creacion, usuario_creacion)
        VALUES (1, '00000000', 'ADMINISTRADOR', 'DEL SISTEMA', 'admin@sistema.com', NOW(), 'SISTEMA');
    END IF;

    -- Vinculamos al usuario admin con ese trabajador
    UPDATE identidad.usuarios 
    SET nombres = 'ADMINISTRADOR', apellidos = 'DEL SISTEMA' 
    WHERE username = 'admin';

    -- 4. VINCULACIÓN DE ROLES Y PERMISOS PARA ADMIN
    RAISE NOTICE 'Asignando permisos masivos al rol ADMIN...';
    
    -- Roles a Menús
    INSERT INTO identidad.roles_menus (id_rol, id_menu, fecha_creacion, usuario_creacion)
    SELECT r.id_rol, m.id_menu, NOW(), 'SISTEMA'
    FROM identidad.roles r, identidad.menus m
    WHERE (r.nombre_rol = 'ADMIN' OR r.nombre_rol = 'ADMINISTRADOR')
    ON CONFLICT DO NOTHING;

    -- Permisos granulares
    INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, fecha_creacion, usuario_creacion)
    SELECT rm.id_rol_menu, tp.id_tipo_permiso, NOW(), 'SISTEMA'
    FROM identidad.roles_menus rm
    JOIN identidad.roles r ON rm.id_rol = r.id_rol
    CROSS JOIN identidad.tipos_permiso tp
    WHERE (r.nombre_rol = 'ADMIN' OR r.nombre_rol = 'ADMINISTRADOR')
    ON CONFLICT DO NOTHING;

    RAISE NOTICE 'Inicialización completada exitosamente.';
END $$;
