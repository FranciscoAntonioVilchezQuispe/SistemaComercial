-- Script: Agregar permisos VEN_TURNOS y VEN_CAJAS
-- Fecha: 2026-04-22

-- 2. Asignar los nuevos menus al rol ADMINISTRADOR en roles_menus
INSERT INTO identidad.roles_menus (id_rol, id_menu, activado, fecha_creacion, usuario_creacion)
SELECT
    r.id_rol,
    m.id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.roles r
CROSS JOIN identidad.menus m
WHERE r.nombre_rol = 'ADMINISTRADOR'
AND m.codigo IN ('VEN_TURNOS', 'VEN_CAJAS');

-- 3. Asignar todos los tipos de permiso (VER, CREAR, EDITAR, ELIMINAR) a esos menus para el rol ADMIN
INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, activado, fecha_creacion, usuario_creacion)
SELECT
    rm.id_rol_menu,
    tp.id_tipo_permiso,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.roles_menus rm
JOIN identidad.menus m ON m.id_menu = rm.id_menu
CROSS JOIN identidad.tipos_permiso tp
WHERE m.codigo IN ('VEN_TURNOS', 'VEN_CAJAS')
AND tp.codigo IN ('VER', 'CREAR', 'EDITAR', 'ELIMINAR')
ON CONFLICT (id_rol_menu, id_tipo_permiso) DO NOTHING;

-- Verificacion: listar lo insertado
SELECT m.codigo, tp.codigo as tipo_permiso, rm.id_rol_menu
FROM identidad.roles_menus rm
JOIN identidad.menus m ON m.id_menu = rm.id_menu
JOIN identidad.roles_menus_permisos rmp ON rmp.id_rol_menu = rm.id_rol_menu
JOIN identidad.tipos_permiso tp ON tp.id_tipo_permiso = rmp.id_tipo_permiso
WHERE m.codigo IN ('VEN_TURNOS', 'VEN_CAJAS')
ORDER BY m.codigo, tp.codigo;
