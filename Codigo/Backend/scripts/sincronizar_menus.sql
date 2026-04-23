-- Sincronización Maestra de Menús y Submenús (CORREGIDO: ADMINISTRADOR y plurales)
-- Basado en config/menu.tsx
DO $$ 
DECLARE 
    v_admin_id BIGINT;
    v_ver_id BIGINT;
    v_crear_id BIGINT;
    v_editar_id BIGINT;
    v_eliminar_id BIGINT;
    v_menu_id BIGINT;
    v_sub_id BIGINT;
BEGIN
    -- 1. Obtener IDs de referencia (Corregido a ADMINISTRADOR)
    SELECT id_rol INTO v_admin_id FROM identidad.roles WHERE nombre_rol = 'ADMINISTRADOR' LIMIT 1;
    
    -- Obtener IDs de permisos (Asegurando coincidencia)
    SELECT id_tipo_permiso INTO v_ver_id FROM identidad.tipos_permiso WHERE codigo = 'VER' LIMIT 1;
    SELECT id_tipo_permiso INTO v_crear_id FROM identidad.tipos_permiso WHERE codigo = 'CREAR' LIMIT 1;
    SELECT id_tipo_permiso INTO v_editar_id FROM identidad.tipos_permiso WHERE codigo = 'EDITAR' LIMIT 1;
    SELECT id_tipo_permiso INTO v_eliminar_id FROM identidad.tipos_permiso WHERE codigo = 'ELIMINAR' LIMIT 1;

    -- Validación de existencia de IDs críticos
    IF v_admin_id IS NULL THEN RAISE EXCEPTION 'No se encontró el rol ADMINISTRADOR'; END IF;
    IF v_ver_id IS NULL THEN RAISE EXCEPTION 'No se encontraron los tipos de permiso base'; END IF;

    ---------------------------------------------------------------------------
    -- JERARQUÍA DE MENÚS (INSERT/UPDATE)
    ---------------------------------------------------------------------------
    
    -- DASHBOARD
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('DASHBOARD', 'Dashboard', 'LayoutDashboard', '/dashboard', 1)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    -- CATALOGO
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('CATALOGO', 'Catálogo', 'Package', NULL, 2)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('CAT_PROD', 'Productos', 'Box', '/catalogo/productos', v_menu_id, 1),
    ('CAT_CAT', 'Categorías', 'FolderTree', '/catalogo/categorias', v_menu_id, 2),
    ('CAT_MAR', 'Marcas', 'Tags', '/catalogo/marcas', v_menu_id, 3),
    ('CAT_UM', 'Unidades de Medida', 'Ruler', '/catalogo/unidades-medida', v_menu_id, 4),
    ('CAT_LP', 'Listas de Precios', 'DollarSign', '/catalogo/listas-precios', v_menu_id, 5)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    -- VENTAS
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('VENTAS', 'Ventas', 'ShoppingCart', NULL, 3)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('VTA_POS', 'Punto de Venta', 'Calculator', '/ventas/pos', v_menu_id, 1),
    ('VTA_LISTA', 'Lista de Ventas', 'List', '/ventas/lista', v_menu_id, 2),
    ('VTA_NOTAS', 'Notas SUNAT', 'FileText', '/ventas/notas', v_menu_id, 3),
    ('VTA_COT', 'Cotizaciones', 'FileText', '/ventas/cotizaciones', v_menu_id, 4),
    ('VTA_CLI', 'Clientes', 'Users', '/clientes', v_menu_id, 5)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    -- INVENTARIO
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('INVENTARIO', 'Inventario', 'Warehouse', NULL, 4)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('INV_STOCK', 'Stock', 'Box', '/inventario/stock', v_menu_id, 1),
    ('INV_MOV', 'Operaciones', 'ArrowLeftRight', '/inventario/movimientos', v_menu_id, 2),
    ('INV_TRAS', 'Traslados', 'Truck', '/inventario/traslados', v_menu_id, 3),
    ('INV_KRD_REP', 'Reporte Kardex', 'BarChart3', '/inventario/kardex/reporte', v_menu_id, 4),
    ('INV_KRD_PER', 'Periodos Kardex', 'History', '/inventario/kardex/periodos', v_menu_id, 5),
    ('INV_ALM', 'Almacenes', 'Home', '/inventario/almacenes', v_menu_id, 6)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    -- COMPRAS
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('COMPRAS', 'Compras', 'ShoppingBag', NULL, 5)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('COM_ORD', 'Órdenes de Compra', 'ClipboardList', '/proveedores/ordenes', v_menu_id, 1),
    ('COM_LISTA', 'Lista de Compras', 'ShoppingBag', '/compras/lista', v_menu_id, 2),
    ('COM_NOTAS', 'Notas de Compra', 'FileText', '/compras/notas', v_menu_id, 3),
    ('COM_PROV', 'Proveedores', 'Truck', '/proveedores', v_menu_id, 4)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    -- REPORTES
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('REPORTES', 'Reportes', 'FileText', '/reportes', 6)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, orden = EXCLUDED.orden;

    -- SEGURIDAD
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('SEGURIDAD', 'Seguridad', 'ShieldCheck', NULL, 7)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('SEG_USR', 'Usuarios', 'Users', '/seguridad/usuarios', v_menu_id, 1),
    ('SEG_ROL', 'Roles y Permisos', 'UserCheck', '/seguridad/roles', v_menu_id, 2),
    ('SEG_TRAB', 'Personal', 'UserPlus', '/seguridad/trabajadores', v_menu_id, 3)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    -- CONFIGURACION
    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, orden)
    VALUES ('CONFIGURACION', 'Configuración', 'Settings', NULL, 8)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, orden = EXCLUDED.orden
    RETURNING id_menu INTO v_menu_id;

    INSERT INTO identidad.menus (codigo, nombre, icono, ruta, id_menu_padre, orden) VALUES
    ('CFG_EMP', 'Empresa', 'Building2', '/configuracion/empresa', v_menu_id, 1),
    ('CFG_SUC', 'Sucursales', 'Home', '/configuracion/sucursales', v_menu_id, 2),
    ('CFG_IMP', 'Impuestos', 'Percent', '/configuracion/impuestos', v_menu_id, 3),
    ('CFG_AFEC', 'Afectación IGV', 'ShieldCheck', '/configuracion/afectacion-igv', v_menu_id, 4),
    ('CFG_TRIB', 'Tipos de Tributo', 'Calculator', '/configuracion/tipos-tributo', v_menu_id, 5),
    ('CFG_PAGO', 'Métodos de Pago', 'CreditCard', '/configuracion/metodos-pago', v_menu_id, 6),
    ('CFG_COMP', 'Comprobantes', 'FileJson', '/configuracion/comprobantes', v_menu_id, 7),
    ('CFG_SUN_REG', 'Reglas SUNAT', 'ShieldCheck', '/configuracion/reglas-sunat', v_menu_id, 8),
    ('CFG_SUN_OP', 'Op. SUNAT', 'FileText', '/configuracion/operaciones-sunat', v_menu_id, 9),
    ('CFG_SUN_MAT', 'Matriz SUNAT', 'Table', '/configuracion/matriz-sunat', v_menu_id, 10),
    ('CFG_TABG', 'Tablas Generales', 'List', '/configuracion/tablas-generales', v_menu_id, 11),
    ('CFG_UBIG', 'Ubigeos', 'MapPin', '/configuracion/ubigeos', v_menu_id, 12)
    ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, ruta = EXCLUDED.ruta, id_menu_padre = EXCLUDED.id_menu_padre, orden = EXCLUDED.orden;

    ---------------------------------------------------------------------------
    -- ASIGNACIÓN DE PERMISOS AL ADMINISTRADOR
    ---------------------------------------------------------------------------
    INSERT INTO identidad.roles_menus (id_rol, id_menu, fecha_creacion)
    SELECT v_admin_id, m.id_menu, NOW()
    FROM identidad.menus m
    ON CONFLICT (id_rol, id_menu) DO NOTHING;

    INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso)
    SELECT rm.id_rol_menu, tp.id_tipo_permiso
    FROM identidad.roles_menus rm
    CROSS JOIN (SELECT v_ver_id as id_tipo_permiso UNION SELECT v_crear_id UNION SELECT v_editar_id UNION SELECT v_eliminar_id) tp
    WHERE rm.id_rol = v_admin_id
    ON CONFLICT (id_rol_menu, id_tipo_permiso) DO NOTHING;

    RAISE NOTICE 'Sincronización de menús completada exitosamente.';
END $$;
