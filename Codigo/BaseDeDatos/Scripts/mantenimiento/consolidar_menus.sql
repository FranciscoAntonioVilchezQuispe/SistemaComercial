-- SCRIPT: consolidar_menus.sql
-- Propósito: Limpiar duplicados y normalizar los menús del sistema.
-- Autor: Antigravity AI

DO $$
DECLARE
    admin_rol_id bigint;
    v_id_menu_padre bigint;
BEGIN
    -- 1. Crear tabla temporal para respaldar permisos actuales si existen
    -- Esto ayuda a no perder la configuración de roles que ya tienen asignados menús
    CREATE TEMP TABLE temp_roles_menus_respaldo AS
    SELECT rm.id_rol, m.codigo as menu_codigo, tp.codigo as permiso_codigo
    FROM identidad.roles_menus rm
    JOIN identidad.menus m ON rm.id_menu = m.id_menu
    JOIN identidad.roles_menus_permisos rmp ON rm.id_rol_menu = rmp.id_rol_menu
    JOIN identidad.tipos_permiso tp ON rmp.id_tipo_permiso = tp.id_tipo_permiso;

    -- 2. Limpieza total de menús y sus dependencias
    -- TRUNCATE CASCADE limpiará roles_menus y roles_menus_permisos
    TRUNCATE TABLE identidad.menus RESTART IDENTITY CASCADE;

    -- 3. Inserción de Menús Principales (Nivel 0)
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, activado, usuario_creacion)
    VALUES
        ('DASHBOARD', 'Dashboard', 'Panel principal del sistema', '/dashboard', 'layout-dashboard', 1, true, 'SISTEMA'),
        ('CATALOGO', 'Catálogo', 'Módulo de gestión de productos', '/catalogo', 'package', 2, true, 'SISTEMA'),
        ('VENTAS', 'Ventas', 'Módulo de gestión de ventas', '/ventas', 'shopping-cart', 3, true, 'SISTEMA'),
        ('INVENTARIO', 'Inventario', 'Módulo de gestión de inventario', '/inventario', 'warehouse', 4, true, 'SISTEMA'),
        ('COMPRAS', 'Compras', 'Módulo de gestión de compras', '/compras', 'shopping-bag', 5, true, 'SISTEMA'),
        ('REPORTES', 'Reportes', 'Módulo de reportes y analítica', '/reportes', 'file-text', 6, true, 'SISTEMA'),
        ('SEGURIDAD', 'Seguridad', 'Gestión de usuarios y permisos', '/seguridad', 'shield-check', 7, true, 'SISTEMA'),
        ('CONFIGURACION', 'Configuración', 'Configuración general del sistema', '/configuracion', 'settings', 8, true, 'SISTEMA');

    -- 4. Submenús de CATALOGO
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'CATALOGO';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('CAT_PRODUCTOS', 'Productos', 'Gestión de catálogo de productos', '/catalogo/productos', 'box', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('CAT_CATEGORIAS', 'Categorías', 'Categorización de productos', '/catalogo/categorias', 'folder-tree', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('CAT_MARCAS', 'Marcas', 'Marcas de productos', '/catalogo/marcas', 'tags', 3, v_id_menu_padre, true, 'SISTEMA'),
        ('CAT_UNIDADES', 'Unidades de Medida', 'Unidades de medida SUNAT', '/catalogo/unidades-medida', 'ruler', 4, v_id_menu_padre, true, 'SISTEMA'),
        ('CAT_PRECIOS', 'Listas de Precios', 'Gestión de listas de precios', '/catalogo/listas-precios', 'dollar-sign', 5, v_id_menu_padre, true, 'SISTEMA');

    -- 5. Submenús de VENTAS
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'VENTAS';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('VEN_POS', 'Punto de Venta', 'Terminal de ventas rápida', '/ventas/pos', 'calculator', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('VEN_LISTA', 'Ventas', 'Listado y gestión de ventas', '/ventas/lista', 'list', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('VEN_NOTAS', 'Notas SUNAT', 'Notas de crédito y débito', '/ventas/notas', 'file-text', 3, v_id_menu_padre, true, 'SISTEMA'),
        ('VEN_COTIZACIONES', 'Cotizaciones', 'Gestión de proformas y cotizaciones', '/ventas/cotizaciones', 'file-text', 4, v_id_menu_padre, true, 'SISTEMA'),
        ('VEN_CLIENTES', 'Clientes', 'Módulo de gestión de clientes', '/clientes', 'users', 5, v_id_menu_padre, true, 'SISTEMA');

    -- 6. Submenús de INVENTARIO
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'INVENTARIO';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('INV_STOCK', 'Stock', 'Consulta de existencias', '/inventario/stock', 'box', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('INV_MOVIMIENTOS', 'Operaciones', 'Entradas y salidas de almacén', '/inventario/movimientos', 'arrow-left-right', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('INV_TRASLADOS', 'Traslados', 'Transferencias entre almacenes', '/inventario/traslados', 'truck', 3, v_id_menu_padre, true, 'SISTEMA'),
        ('INV_KARDEX_REP', 'Reporte Kardex', 'Kardex valorizado SUNAT', '/inventario/kardex/reporte', 'bar-chart-3', 4, v_id_menu_padre, true, 'SISTEMA'),
        ('INV_KARDEX_PER', 'Periodos Kardex', 'Gestión de periodos de inventario', '/inventario/kardex/periodos', 'history', 5, v_id_menu_padre, true, 'SISTEMA'),
        ('INV_ALMACENES', 'Almacenes', 'Gestión de locales y almacenes', '/inventario/almacenes', 'home', 6, v_id_menu_padre, true, 'SISTEMA');

    -- 7. Submenús de COMPRAS
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'COMPRAS';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('COM_ORDENES', 'Órdenes de Compra', 'Pedidos a proveedores', '/proveedores/ordenes', 'clipboard-list', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('COM_LISTA', 'Compras', 'Registro de compras y facturas', '/compras/lista', 'shopping-bag', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('COM_NOTAS', 'Notas de Compra', 'Notas de crédito/débito de compra', '/compras/notas', 'file-text', 3, v_id_menu_padre, true, 'SISTEMA'),
        ('COM_PROVEEDORES', 'Proveedores', 'Gestión de proveedores', '/proveedores', 'truck', 4, v_id_menu_padre, true, 'SISTEMA');

    -- 8. Submenús de SEGURIDAD
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'SEGURIDAD';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('SEG_USUARIOS', 'Usuarios', 'Gestión de cuentas de usuario', '/seguridad/usuarios', 'users', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('SEG_ROLES', 'Roles y Permisos', 'Configuración de accesos', '/seguridad/roles', 'user-check', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('SEG_TRABAJADORES', 'Personal', 'Gestión de personal/trabajadores', '/seguridad/trabajadores', 'user-plus', 3, v_id_menu_padre, true, 'SISTEMA');

    -- 9. Submenús de CONFIGURACION
    SELECT id_menu INTO v_id_menu_padre FROM identidad.menus WHERE codigo = 'CONFIGURACION';
    INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, usuario_creacion)
    VALUES
        ('CONF_EMPRESA', 'Empresa', 'Datos principales del negocio', '/configuracion/empresa', 'building-2', 1, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_SUCURSALES', 'Sucursales', 'Gestión de puntos de venta', '/configuracion/sucursales', 'home', 2, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_IMPUESTOS', 'Impuestos', 'Configuración de IGV/ISC', '/configuracion/impuestos', 'percent', 3, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_AFECTACION_IGV', 'Afectación IGV', 'Tipos de afectación SUNAT', '/configuracion/afectacion-igv', 'shield-check', 4, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_TIPOS_TRIBUTO', 'Tipos de Tributo', 'Catálogo de tributos SUNAT', '/configuracion/tipos-tributo', 'calculator', 5, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_METODOS_PAGO', 'Métodos de Pago', 'Gestión de formas de pago', '/configuracion/metodos-pago', 'credit-card', 6, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_COMPROBANTES', 'Comprobantes', 'Series y correlativos', '/configuracion/comprobantes', 'file-json', 7, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_REGLAS_SUNAT', 'Reglas SUNAT', 'Políticas de facturación electrónica', '/configuracion/reglas-sunat', 'shield-check', 8, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_OPERACIONES_SUNAT', 'Op. SUNAT', 'Tipos de operación comercial', '/configuracion/operaciones-sunat', 'file-text', 9, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_MATRIZ_SUNAT', 'Matriz SUNAT', 'Configuración avanzada de tributos', '/configuracion/matriz-sunat', 'table', 10, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_TABLAS_GRALES', 'Tablas Generales', 'Diccionarios del sistema', '/configuracion/tablas-generales', 'list', 11, v_id_menu_padre, true, 'SISTEMA'),
        ('CONF_UBIGEOS', 'Ubigeos', 'Catálogo de departamentos/provincias/distritos', '/configuracion/ubigeos', 'map-pin', 12, v_id_menu_padre, true, 'SISTEMA');

    -- 10. Restaurar Permisos de Roles (Paso crítico)
    -- Mapeamos lo que podemos de los permisos anteriores a los nuevos menús
    INSERT INTO identidad.roles_menus (id_rol, id_menu, usuario_creacion)
    SELECT DISTINCT tr.id_rol, m.id_menu, 'SISTEMA_CLEAN'
    FROM temp_roles_menus_respaldo tr
    JOIN identidad.menus m ON m.codigo = tr.menu_codigo 
    ON CONFLICT DO NOTHING;

    INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, usuario_creacion)
    SELECT DISTINCT rm.id_rol_menu, tp.id_tipo_permiso, 'SISTEMA_CLEAN'
    FROM temp_roles_menus_respaldo tr
    JOIN identidad.menus m ON m.codigo = tr.menu_codigo
    JOIN identidad.roles_menus rm ON rm.id_rol = tr.id_rol AND rm.id_menu = m.id_menu
    JOIN identidad.tipos_permiso tp ON tp.codigo = tr.permiso_codigo
    ON CONFLICT DO NOTHING;

    -- 11. Caso especial: ADMINISTRADOR debe tener TODO
    SELECT id_rol INTO admin_rol_id FROM identidad.roles WHERE nombre_rol = 'ADMINISTRADOR';
    IF admin_rol_id IS NOT NULL THEN
        -- Asegurar todos los menús para ADMIN
        INSERT INTO identidad.roles_menus (id_rol, id_menu, usuario_creacion)
        SELECT admin_rol_id, id_menu, 'SISTEMA_CLEAN'
        FROM identidad.menus
        ON CONFLICT DO NOTHING;

        -- Asegurar todos los permisos para ADMIN
        INSERT INTO identidad.roles_menus_permisos (id_rol_menu, id_tipo_permiso, usuario_creacion)
        SELECT rm.id_rol_menu, tp.id_tipo_permiso, 'SISTEMA_CLEAN'
        FROM identidad.roles_menus rm
        CROSS JOIN identidad.tipos_permiso tp
        WHERE rm.id_rol = admin_rol_id
        ON CONFLICT DO NOTHING;
    END IF;

    -- 12. Limpieza de tabla temporal
    DROP TABLE temp_roles_menus_respaldo;

    RAISE NOTICE 'Consolidación de menús completada exitosamente.';
END $$;
