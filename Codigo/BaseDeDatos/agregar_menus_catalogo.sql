-- Script para agregar menús de Catálogo faltantes
-- Fecha: 2026-01-29
-- Descripción: Agrega menús para Unidades de Medida y Listas de Precios

-- Primero, obtener el ID del menú padre "Catálogo"
-- Asumiendo que el código del menú Catálogo es 'CATALOGO'

-- Insertar menú para Unidades de Medida
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_UNIDADES_MEDIDA',
    'Unidades de Medida',
    'Gestión de unidades de medida',
    '/catalogo/unidades-medida',
    'Ruler',
    30,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Insertar menú para Listas de Precios
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_LISTAS_PRECIOS',
    'Listas de Precios',
    'Gestión de listas de precios',
    '/catalogo/listas-precios',
    'DollarSign',
    40,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Asignar permisos de menú al rol Administrador (asumiendo id_rol = 1)
-- Primero para Unidades de Medida
INSERT INTO identidad.roles_menus (id_rol, id_menu, activado, fecha_creacion, usuario_creacion)
SELECT 
    1,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CAT_UNIDADES_MEDIDA';

-- Luego para Listas de Precios
INSERT INTO identidad.roles_menus (id_rol, id_menu, activado, fecha_creacion, usuario_creacion)
SELECT 
    1,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CAT_LISTAS_PRECIOS';

-- Verificar los menús insertados
SELECT 
    m.id_menu,
    m.codigo,
    m.nombre,
    m.ruta,
    m.orden,
    mp.nombre as menu_padre
FROM identidad.menus m
LEFT JOIN identidad.menus mp ON m.id_menu_padre = mp.id_menu
WHERE m.codigo IN ('CAT_UNIDADES_MEDIDA', 'CAT_LISTAS_PRECIOS')
ORDER BY m.orden;
