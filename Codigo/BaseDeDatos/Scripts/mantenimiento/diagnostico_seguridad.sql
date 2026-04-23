-- SCRIPT: diagnostico_seguridad.sql
-- Propósito: Verificar el estado de la configuración de seguridad (roles, menús, permisos).
-- Ejecución: En DBeaver o psql.

\echo '--- [1] ROLES CONFIGURADOS ---'
SELECT id_rol, nombre_rol, activado 
FROM identidad.roles 
ORDER BY id_rol;

\echo '--- [2] TIPOS DE PERMISO DISPONIBLES ---'
SELECT id_tipo_permiso, codigo, nombre 
FROM identidad.tipos_permiso 
ORDER BY id_tipo_permiso;

\echo '--- [3] MENÚS Y CÓDIGOS ---'
SELECT id_menu, codigo, nombre, ruta, id_menu_padre 
FROM identidad.menus 
WHERE activado = true 
ORDER BY orden, id_menu;

\echo '--- [4] MATRIZ DE PERMISOS POR ROL ---'
SELECT 
    r.nombre_rol,
    m.codigo AS menu_codigo,
    m.nombre AS menu_nombre,
    tp.codigo AS permiso_codigo
FROM identidad.roles_menus_permisos rmp
JOIN identidad.roles_menus rm ON rmp.id_rol_menu = rm.id_rol_menu
JOIN identidad.roles r ON rm.id_rol = r.id_rol
JOIN identidad.menus m ON rm.id_menu = m.id_menu
JOIN identidad.tipos_permiso tp ON rmp.id_tipo_permiso = tp.id_tipo_permiso
ORDER BY r.nombre_rol, m.codigo;

\echo '--- [5] USUARIOS Y SUS ROLES ---'
SELECT 
    u.username,
    u.nombres || ' ' || u.apellidos AS nombre_completo,
    r.nombre_rol,
    u.activado
FROM identidad.usuarios u
LEFT JOIN identidad.usuarios_roles ur ON u.id_usuario = ur.id_usuario
LEFT JOIN identidad.roles r ON ur.id_rol = r.id_rol
ORDER BY u.username;
