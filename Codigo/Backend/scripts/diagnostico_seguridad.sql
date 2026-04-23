-- ============================================================================
-- SCRIPT: diagnostico_seguridad.sql
-- DESCRIPCIÓN: Consultas de diagnóstico para el sistema de seguridad e identidad.
-- SCHEMA: identidad
-- FECHA: 2026-04-20
-- ============================================================================

-- 1. Listar todos los roles con su nombre exacto
-- QUERY 1: LISTADO DE ROLES
SELECT id_rol, nombre_rol, descripcion, activado
FROM identidad.roles
ORDER BY nombre_rol;

-- 2. Listar todos los tipos_permiso con su código exacto
-- QUERY 2: LISTADO DE TIPOS DE PERMISO
SELECT id_tipo_permiso, codigo, nombre, activado
FROM identidad.tipos_permiso
ORDER BY codigo;

-- 3. Listar los menús padre (sin id_menu_padre) con sus códigos
-- QUERY 3: LISTADO DE MENÚS PADRE
SELECT id_menu, codigo, nombre, orden, activado
FROM identidad.menus
WHERE id_menu_padre IS NULL
ORDER BY orden;

-- 4. Permisos del usuario 'admin' (o el primer usuario activo)
-- Formato solicitado: "MENU_CODIGO:TIPO_PERMISO_CODIGO"
-- QUERY 4: PERMISOS DEL USUARIO ADMIN
WITH usuario_objetivo AS (
    SELECT id_usuario, username 
    FROM identidad.usuarios 
    WHERE username = 'admin' 
       OR (activado = true AND username != 'admin')
    ORDER BY (CASE WHEN username = 'admin' THEN 0 ELSE 1 END)
    LIMIT 1
)
SELECT 
    uo.username,
    m.codigo || ':' || tp.codigo AS permiso_formateado
FROM usuario_objetivo uo
JOIN identidad.usuarios_roles ur ON uo.id_usuario = ur.id_usuario
JOIN identidad.roles_menus rm ON ur.id_rol = rm.id_rol
JOIN identidad.menus m ON rm.id_menu = m.id_menu
JOIN identidad.roles_menus_permisos rmp ON rm.id_rol_menu = rmp.id_rol_menu
JOIN identidad.tipos_permiso tp ON rmp.id_tipo_permiso = tp.id_tipo_permiso
ORDER BY m.codigo, tp.codigo;

-- 5. Verificar si el rol 'ADMINISTRADOR' tiene los 4 tipos de permiso asignados
-- para cada menú padre solicitado.
-- QUERY 5: VERIFICACIÓN DE PERMISOS COMPLETOS PARA ROL ADMINISTRADOR (PADRES)
WITH menus_base AS (
    SELECT id_menu, codigo 
    FROM identidad.menus 
    WHERE codigo IN ('VENTAS', 'COMPRAS', 'INVENTARIO', 'CATALOGO', 'CONFIGURACION', 'CONTABILIDAD', 'CLIENTES')
      AND id_menu_padre IS NULL
),
permisos_base AS (
    SELECT id_tipo_permiso, codigo 
    FROM identidad.tipos_permiso 
    WHERE codigo IN ('VER', 'CREAR', 'EDITAR', 'ELIMINAR')
),
rol_admin AS (
    SELECT id_rol 
    FROM identidad.roles 
    WHERE nombre_rol = 'ADMINISTRADOR'
),
matriz_esperada AS (
    SELECT mb.id_menu, mb.codigo as menu_codigo, pb.id_tipo_permiso, pb.codigo as permiso_codigo
    FROM menus_base mb, permisos_base pb
)
SELECT 
    me.menu_codigo,
    me.permiso_codigo,
    CASE WHEN rmp.id_rol_menu_permiso IS NOT NULL THEN 'OK' ELSE 'FALTA' END AS estado
FROM matriz_esperada me
LEFT JOIN rol_admin ra ON true
LEFT JOIN identidad.roles_menus rm ON ra.id_rol = rm.id_rol AND me.id_menu = rm.id_menu
LEFT JOIN identidad.roles_menus_permisos rmp ON rm.id_rol_menu = rmp.id_rol_menu AND me.id_tipo_permiso = rmp.id_tipo_permiso
ORDER BY me.menu_codigo, me.permiso_codigo;
