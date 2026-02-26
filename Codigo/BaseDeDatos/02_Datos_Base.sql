-- Script para agregar menÃºs de CatÃ¡logo faltantes
-- Fecha: 2026-01-29
-- DescripciÃ³n: Agrega menÃºs para Unidades de Medida y Listas de Precios

-- Primero, obtener el ID del menÃº padre "CatÃ¡logo"
-- Asumiendo que el cÃ³digo del menÃº CatÃ¡logo es 'CATALOGO'

-- Insertar menÃº para Unidades de Medida
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_UNIDADES_MEDIDA',
    'Unidades de Medida',
    'GestiÃ³n de unidades de medida',
    '/catalogo/unidades-medida',
    'Ruler',
    30,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Insertar menÃº para Listas de Precios
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_LISTAS_PRECIOS',
    'Listas de Precios',
    'GestiÃ³n de listas de precios',
    '/catalogo/listas-precios',
    'DollarSign',
    40,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Asignar permisos de menÃº al rol Administrador (asumiendo id_rol = 1)
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

-- Verificar los menÃºs insertados
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

SELECT 'Menus Nuevos' as tabla, count(*)::bigint FROM identidad.menus WHERE codigo IN ('CAT_UNIDADES_MEDIDA', 'CAT_LISTAS_PRECIOS');
-- =====================================================
-- Script de InicializaciÃ³n: Sistema de Permisos Granulares
-- Base de Datos: sistema_comercial
-- Esquema: identidad
-- =====================================================

-- =====================================================
-- 1. CREAR TABLAS
-- =====================================================

-- Tabla: menus
CREATE TABLE IF NOT EXISTS identidad.menus (
    id_menu BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    ruta VARCHAR(255),
    icono VARCHAR(50),
    orden INTEGER NOT NULL DEFAULT 0,
    id_menu_padre BIGINT,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    FOREIGN KEY (id_menu_padre) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE
);

-- Tabla: tipos_permiso
CREATE TABLE IF NOT EXISTS identidad.tipos_permiso (
    id_tipo_permiso BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- Tabla: roles_menus
CREATE TABLE IF NOT EXISTS identidad.roles_menus (
    id_rol_menu BIGSERIAL PRIMARY KEY,
    id_rol BIGINT NOT NULL,
    id_menu BIGINT NOT NULL,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_menu) REFERENCES identidad.menus(id_menu) ON DELETE CASCADE,
    UNIQUE (id_rol, id_menu)
);

-- Tabla: roles_menus_permisos
CREATE TABLE IF NOT EXISTS identidad.roles_menus_permisos (
    id_rol_menu_permiso BIGSERIAL PRIMARY KEY,
    id_rol_menu BIGINT NOT NULL,
    id_tipo_permiso BIGINT NOT NULL,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    FOREIGN KEY (id_rol_menu) REFERENCES identidad.roles_menus(id_rol_menu) ON DELETE CASCADE,
    FOREIGN KEY (id_tipo_permiso) REFERENCES identidad.tipos_permiso(id_tipo_permiso) ON DELETE CASCADE,
    UNIQUE (id_rol_menu, id_tipo_permiso)
);

-- Tabla: usuarios_roles
CREATE TABLE IF NOT EXISTS identidad.usuarios_roles (
    id_usuario_rol BIGSERIAL PRIMARY KEY,
    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES identidad.usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES identidad.roles(id_rol) ON DELETE CASCADE,
    UNIQUE (id_usuario, id_rol)
);

-- =====================================================
-- 2. CREAR ÃNDICES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_menus_codigo ON identidad.menus(codigo);
CREATE INDEX IF NOT EXISTS idx_menus_menu_padre ON identidad.menus(id_menu_padre);
CREATE INDEX IF NOT EXISTS idx_tipos_permiso_codigo ON identidad.tipos_permiso(codigo);
CREATE INDEX IF NOT EXISTS idx_roles_menus_rol ON identidad.roles_menus(id_rol);
CREATE INDEX IF NOT EXISTS idx_roles_menus_menu ON identidad.roles_menus(id_menu);
CREATE INDEX IF NOT EXISTS idx_usuarios_roles_usuario ON identidad.usuarios_roles(id_usuario);
CREATE INDEX IF NOT EXISTS idx_usuarios_roles_rol ON identidad.usuarios_roles(id_rol);

-- =====================================================
-- 3. INSERTAR DATOS INICIALES - TIPOS DE PERMISO
-- =====================================================

INSERT INTO identidad.tipos_permiso (codigo, nombre, descripcion) 
VALUES
    ('CREATE', 'Crear', 'Permite crear nuevos registros'),
    ('READ', 'Leer', 'Permite ver y consultar registros'),
    ('UPDATE', 'Actualizar', 'Permite modificar registros existentes'),
    ('DELETE', 'Eliminar', 'Permite eliminar registros'),
    ('EXPORT', 'Exportar', 'Permite exportar datos a archivos'),
    ('IMPORT', 'Importar', 'Permite importar datos desde archivos'),
    ('APPROVE', 'Aprobar', 'Permite aprobar transacciones o documentos'),
    ('PRINT', 'Imprimir', 'Permite imprimir documentos'),
    ('CANCEL', 'Anular', 'Permite anular documentos o transacciones')
ON CONFLICT (codigo) DO NOTHING;

-- =====================================================
-- 4. INSERTAR DATOS INICIALES - MENÃšS
-- =====================================================

-- MenÃºs principales (sin padre)
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden) 
VALUES
    ('DASHBOARD', 'Dashboard', 'Panel principal del sistema', '/dashboard', 'dashboard', 1),
    ('VENTAS', 'Ventas', 'MÃ³dulo de gestiÃ³n de ventas', '/ventas', 'shopping-cart', 2),
    ('COMPRAS', 'Compras', 'MÃ³dulo de gestiÃ³n de compras', '/compras', 'shopping-bag', 3),
    ('INVENTARIO', 'Inventario', 'MÃ³dulo de gestiÃ³n de inventario', '/inventario', 'warehouse', 4),
    ('CLIENTES', 'Clientes', 'MÃ³dulo de gestiÃ³n de clientes', '/clientes', 'users', 5),
    ('CATALOGO', 'CatÃ¡logo', 'MÃ³dulo de gestiÃ³n de productos', '/catalogo', 'book', 6),
    ('CONTABILIDAD', 'Contabilidad', 'MÃ³dulo de contabilidad', '/contabilidad', 'calculator', 7),
    ('CONFIGURACION', 'ConfiguraciÃ³n', 'ConfiguraciÃ³n del sistema', '/configuracion', 'settings', 8),
    ('IDENTIDAD', 'Identidad', 'GestiÃ³n de usuarios y permisos', '/identidad', 'shield', 9)
ON CONFLICT (codigo) DO NOTHING;

-- SubmenÃºs de VENTAS
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('VENTAS_LISTA', 'Lista de Ventas', 'Ver todas las ventas', '/ventas/lista', 'list', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_NUEVA', 'Nueva Venta', 'Registrar nueva venta', '/ventas/nueva', 'plus', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_COTIZACIONES', 'Cotizaciones', 'Gestionar cotizaciones', '/ventas/cotizaciones', 'file-text', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_CAJAS', 'Cajas', 'GestiÃ³n de cajas', '/ventas/cajas', 'credit-card', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS'))
ON CONFLICT (codigo) DO NOTHING;

-- SubmenÃºs de COMPRAS
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('COMPRAS_LISTA', 'Lista de Compras', 'Ver todas las compras', '/compras/lista', 'list', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_NUEVA', 'Nueva Compra', 'Registrar nueva compra', '/compras/nueva', 'plus', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_ORDENES', 'Ã“rdenes de Compra', 'Gestionar Ã³rdenes', '/compras/ordenes', 'clipboard', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_PROVEEDORES', 'Proveedores', 'GestiÃ³n de proveedores', '/compras/proveedores', 'truck', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS'))
ON CONFLICT (codigo) DO NOTHING;

-- SubmenÃºs de INVENTARIO
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('INVENTARIO_STOCK', 'Stock', 'Consultar stock disponible', '/inventario/stock', 'package', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO')),
    ('INVENTARIO_MOVIMIENTOS', 'Movimientos', 'Movimientos de inventario', '/inventario/movimientos', 'repeat', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO')),
    ('INVENTARIO_ALMACENES', 'Almacenes', 'GestiÃ³n de almacenes', '/inventario/almacenes', 'home', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO'))
ON CONFLICT (codigo) DO NOTHING;

-- SubmenÃºs de CATALOGO
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('CATALOGO_PRODUCTOS', 'Productos', 'GestiÃ³n de productos', '/catalogo/productos', 'box', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_CATEGORIAS', 'CategorÃ­as', 'GestiÃ³n de categorÃ­as', '/catalogo/categorias', 'folder', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_MARCAS', 'Marcas', 'GestiÃ³n de marcas', '/catalogo/marcas', 'tag', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_PRECIOS', 'Listas de Precios', 'GestiÃ³n de precios', '/catalogo/precios', 'dollar-sign', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO'))
ON CONFLICT (codigo) DO NOTHING;

-- SubmenÃºs de IDENTIDAD
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('IDENTIDAD_USUARIOS', 'Usuarios', 'GestiÃ³n de usuarios', '/identidad/usuarios', 'user', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD')),
    ('IDENTIDAD_ROLES', 'Roles', 'GestiÃ³n de roles', '/identidad/roles', 'users', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD')),
    ('IDENTIDAD_PERMISOS', 'Permisos', 'AsignaciÃ³n de permisos', '/identidad/permisos', 'lock', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD'))
ON CONFLICT (codigo) DO NOTHING;

-- =====================================================
-- 5. VERIFICACIÃ“N
-- =====================================================

-- Contar registros insertados
SELECT 'Tipos de Permiso' as tabla, COUNT(*) as total FROM identidad.tipos_permiso
UNION ALL
SELECT 'MenÃºs', COUNT(*) FROM identidad.menus
UNION ALL
SELECT 'Roles-MenÃºs', COUNT(*) FROM identidad.roles_menus
UNION ALL
SELECT 'Roles-MenÃºs-Permisos', COUNT(*) FROM identidad.roles_menus_permisos
UNION ALL
SELECT 'Usuarios-Roles', COUNT(*) FROM identidad.usuarios_roles;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
-- =====================================================
-- Script de Datos Semilla (Datos de Prueba)
-- Base de Datos: sistema_comercial
-- =====================================================

-- 1. CATALOGO BASE
-- =====================================================
INSERT INTO catalogo.categorias (nombre_categoria, descripcion, usuario_creacion)
VALUES ('General', 'CategorÃ­a por defecto', 'SEEDER')
ON CONFLICT DO NOTHING;

INSERT INTO catalogo.marcas (nombre_marca, pais_origen, usuario_creacion)
VALUES ('Generica', 'Peru', 'SEEDER')
ON CONFLICT DO NOTHING;

INSERT INTO catalogo.unidades_medida (codigo_sunat, nombre_unidad, simbolo, usuario_creacion)
VALUES ('NIU', 'Unidad', 'UND', 'SEEDER')
ON CONFLICT DO NOTHING;

-- 2. PRODUCTO DE PRUEBA
-- =====================================================
DO $$
DECLARE
    v_id_categoria bigint;
    v_id_marca bigint;
    v_id_unidad bigint;
BEGIN
    SELECT id_categoria INTO v_id_categoria FROM catalogo.categorias WHERE nombre_categoria = 'General' LIMIT 1;
    SELECT id_marca INTO v_id_marca FROM catalogo.marcas WHERE nombre_marca = 'Generica' LIMIT 1;
    SELECT id_unidad INTO v_id_unidad FROM catalogo.unidades_medida WHERE simbolo = 'UND' LIMIT 1;

    INSERT INTO catalogo.productos (
        codigo_producto, nombre_producto, descripcion, 
        id_categoria, id_marca, id_unidad, 
        precio_venta_publico, stock_minimo, usuario_creacion
    )
    VALUES (
        'PROD-001', 'Producto de Prueba', 'Este es un producto generado automÃ¡ticamente',
        v_id_categoria, v_id_marca, v_id_unidad,
        100.00, 10, 'SEEDER'
    )
    ON CONFLICT DO NOTHING;
END $$;

-- 3. CLIENTE DE PRUEBA
-- =====================================================
INSERT INTO clientes.clientes (
    numero_documento, razon_social, direccion, 
    email, usuario_creacion
)
VALUES (
    '12345678', 'Cliente Mostrador', 'Av. Principal 123',
    'cliente@ejemplo.com', 'SEEDER'
)
ON CONFLICT DO NOTHING;

-- 4. CONFIGURACION BASICA (EMPRESA)
-- =====================================================
-- Asumimos que la tabla empresa existe en esquema configuracion
INSERT INTO configuracion.empresa (
    razon_social, ruc, direccion, usuario_creacion
)
VALUES (
    'Mi Empresa S.A.C.', '20123456789', 'Calle Las Flores 456', 'SEEDER'
)
ON CONFLICT DO NOTHING;

SELECT 'Categorias' as tabla, count(*)::bigint FROM catalogo.categorias UNION ALL SELECT 'Marcas', count(*)::bigint FROM catalogo.marcas;
-- =====================================================
-- Script de Tablas Faltantes - Configuracion
-- Esquema: configuracion
-- =====================================================

-- 1. TIPOS DE COMPROBANTE
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracion.tipos_comprobantes (
    id_tipo_comprobante BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    mueve_stock BOOLEAN NOT NULL DEFAULT false,
    tipo_movimiento_stock VARCHAR(20) NOT NULL DEFAULT 'DEPENDIENTE',
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- 2. SUCURSALES
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracion.sucursales (
    id_sucursal BIGSERIAL PRIMARY KEY,
    id_empresa BIGINT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    es_principal BOOLEAN NOT NULL DEFAULT false,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100),
    FOREIGN KEY (id_empresa) REFERENCES configuracion.empresa(id_empresa)
);

-- 3. IMPUESTOS
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracion.impuestos (
    id_impuesto BIGSERIAL PRIMARY KEY,
    codigo_sunat VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    porcentaje NUMERIC(5,2) NOT NULL DEFAULT 0,
    es_porcentaje BOOLEAN NOT NULL DEFAULT true,
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);

-- 4. PARAMETROS DE CONFIGURACION
-- =====================================================
CREATE TABLE IF NOT EXISTS configuracion.parametros_configuracion (
    id_parametro BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    valor VARCHAR(255),
    descripcion VARCHAR(500),
    grupo VARCHAR(50),
    activado BOOLEAN NOT NULL DEFAULT true,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
    usuario_creacion VARCHAR(100) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(100)
);
-- =====================================================
-- Script de Datos - Configuracion (Tablas Faltantes)
-- =====================================================

-- 1. TIPOS DE COMPROBANTE
INSERT INTO configuracion.tipos_comprobantes (codigo, nombre, mueve_stock, tipo_movimiento_stock)
VALUES 
    ('01', 'FACTURA', false, 'NEUTRO'),
    ('03', 'BOLETA DE VENTA', false, 'NEUTRO'),
    ('07', 'NOTA DE CREDITO', true, 'ENTRADA'),
    ('08', 'NOTA DE DEBITO', false, 'NEUTRO'),
    ('09', 'GUIA DE REMISION', true, 'SALIDA'),
    ('00', 'COTIZACION', false, 'NEUTRO')
ON CONFLICT DO NOTHING;

-- 2. IMPUESTOS
INSERT INTO configuracion.impuestos (codigo_sunat, nombre, porcentaje)
VALUES 
    ('1000', 'IGV', 18.00),
    ('2000', 'ISC', 0.00),
    ('9997', 'EXONERADO', 0.00),
    ('9998', 'INAFECTO', 0.00)
ON CONFLICT DO NOTHING;

-- 3. PARAMETROS
INSERT INTO configuracion.parametros_configuracion (codigo, valor, descripcion, grupo)
VALUES 
    ('MONEDA_DEFECTO', 'PEN', 'Moneda por defecto del sistema', 'GENERAL'),
    ('IGV_DEFECTO', '18.00', 'Porcentaje de IGV actual', 'FISCAL')
ON CONFLICT DO NOTHING;

-- 4. SUCURSAL (Requiere Empresa existente, ID=1 asumiendo seed)
-- Nota: Si no hay empresa con ID 1, esto puede fallar si no se inserta antes. 
-- El script 04_Datos_Semilla.sql inserta Empresa.
INSERT INTO configuracion.sucursales (id_empresa, codigo, nombre, direccion, es_principal)
SELECT id_empresa, '001', 'Sucursal Principal', 'Av. Principal 123', true
FROM configuracion.empresa WHERE ruc = '20123456789' LIMIT 1;
-- Limpiar datos de prueba antes de restaurar del dump
TRUNCATE TABLE catalogo.productos, catalogo.variantes_producto, catalogo.categorias, catalogo.marcas, catalogo.unidades_medida CASCADE;
TRUNCATE TABLE clientes.clientes, clientes.contactos_cliente CASCADE;
TRUNCATE TABLE compras.compras, compras.detalle_compra, compras.ordenes_compra, compras.detalle_orden_compra, compras.proveedores CASCADE;
TRUNCATE TABLE configuracion.tablas_generales, configuracion.tablas_generales_detalle CASCADE;
TRUNCATE TABLE configuracion.configuraciones CASCADE;
DELETE FROM configuracion.empresa; 
INSERT INTO catalogo.categorias VALUES (1, 'General', 'Categoria General', NULL, NULL, true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.categorias VALUES (2, 'General 2', 'prueba', NULL, NULL, false, '2026-01-28 23:41:36.75824', 'API_USER', '2026-01-29 12:27:20.601968', 'API_USER');
INSERT INTO catalogo.marcas VALUES (1, 'Generico', 'Peru', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO catalogo.productos VALUES (1, 'PROD_CLI_01', NULL, NULL, 'Producto Client', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:55:17.057057', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (2, 'PROD001', NULL, NULL, 'Producto Prueba', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 22:59:25.458681', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (3, 'PROD_WRAPPER_02', NULL, NULL, 'Producto Wrapper 2', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:11:00.248331', '', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (4, 'PROD_AUDIT_03', NULL, NULL, 'Producto Auditado', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:18:23.828687', 'API_USER', NULL, NULL, NULL);
INSERT INTO catalogo.productos VALUES (5, 'prueba', NULL, NULL, 'esta', NULL, 1, 1, 1, false, 0.00, 0.00, 0.00, 0.00, 0.000, 0.000, false, true, 18.00, NULL, true, '2026-01-27 23:37:50.466669', 'API_USER', NULL, NULL, NULL);
INSERT INTO catalogo.unidades_medida VALUES (1, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (2, 'KGM', 'Kilogramo', 'KG', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (3, 'LTR', 'Litro', 'LT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (4, 'MTR', 'Metro', 'MT', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (5, 'BX', 'Caja', 'CJA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO catalogo.unidades_medida VALUES (6, 'NIU', 'Unidad', 'UND', true, '2026-01-27 17:36:29.051209', 'SYSTEM', '2026-01-27 17:36:29.051209', NULL);
INSERT INTO configuracion.configuraciones VALUES (1, 'IMPUESTO_PORCENTAJE', '18', 'Porcentaje de IGV/IVA por defecto', 'VENTAS', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO configuracion.configuraciones VALUES (2, 'MONEDA_PRINCIPAL', 'PEN', 'Moneda base del sistema', 'SISTEMA', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO configuracion.empresa VALUES (1, '20123456789', 'EMPRESA DEMO S.A.C.', 'MI TIENDA', 'AV. PRINCIPAL 123, LIMA', NULL, NULL, NULL, NULL, 'PEN', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO configuracion.tablas_generales VALUES (1, 'TIPO_DOCUMENTO', 'Tipos de Documento de Identidad', NULL, true, '2026-01-27 20:38:29.859421-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (3, 'TIPO_CLIENTE', 'Tipos de Cliente', NULL, true, '2026-01-27 20:38:29.870662-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (4, 'TIPO_MOVIMIENTO_CAJA', 'Tipos de Movimiento de Caja', NULL, true, '2026-01-27 20:38:29.871674-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (5, 'TIPO_PRODUCTO', 'Tipos de Producto', NULL, true, '2026-01-27 20:38:29.872644-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (6, 'TIPO_MOVIMIENTO_INVENTARIO', 'Tipos de Movimiento de Inventario', NULL, true, '2026-01-27 20:38:29.873586-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (7, 'TIPO_CUENTA_CONTABLE', 'Tipos de Cuenta Contable', NULL, true, '2026-01-27 20:38:29.87462-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (8, 'ESTADO_VENTA', 'Estados de Venta', NULL, true, '2026-01-27 20:38:29.875555-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (9, 'ESTADO_COTIZACION', 'Estados de CotizaciÃƒÂ³n', NULL, true, '2026-01-27 20:38:29.876572-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (10, 'ESTADO_CAJA', 'Estados de Caja', NULL, true, '2026-01-27 20:38:29.877676-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (11, 'ESTADO_ORDEN_COMPRA', 'Estados de Orden de Compra', NULL, true, '2026-01-27 20:38:29.878602-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (12, 'ESTADO_ASIENTO', 'Estados de Asiento Contable', NULL, true, '2026-01-27 20:38:29.879531-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (13, 'ESTADO_PAGO', 'Estados de Pago', NULL, true, '2026-01-27 20:38:29.880536-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (1, 1, 'DNI', 'Documento Nacional de Identidad', NULL, 1, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (2, 1, 'RUC', 'Registro ÃƒÅ¡nico de Contribuyentes', NULL, 2, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (3, 1, 'CE', 'Carnet de ExtranjerÃƒÂ­a', NULL, 3, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (4, 1, 'PAS', 'Pasaporte', NULL, 4, true, '2026-01-27 20:38:29.865474-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (5, 2, 'BOL', 'Boleta de Venta', NULL, 1, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (6, 2, 'FAC', 'Factura', NULL, 2, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (7, 2, 'NVT', 'Nota de Venta', NULL, 3, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (8, 2, 'TK', 'Ticket', NULL, 4, true, '2026-01-27 20:38:29.870018-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (9, 3, 'PUB', 'PÃƒÂºblico General', NULL, 1, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (10, 3, 'CORP', 'Corporativo', NULL, 2, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (11, 3, 'VIP', 'Cliente VIP', NULL, 3, true, '2026-01-27 20:38:29.871144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (12, 4, 'ING', 'Ingreso', NULL, 1, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (13, 4, 'EGR', 'Egreso', NULL, 2, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (14, 4, 'APE', 'Apertura', NULL, 3, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (15, 4, 'CIE', 'Cierre', NULL, 4, true, '2026-01-27 20:38:29.87213-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (16, 5, 'PROD', 'Producto Terminado', NULL, 1, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (17, 5, 'SERV', 'Servicio', NULL, 2, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (18, 5, 'INS', 'Insumo', NULL, 3, true, '2026-01-27 20:38:29.873074-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (19, 6, 'ING_COM', 'Ingreso por Compra', NULL, 1, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (20, 6, 'SAL_VEN', 'Salida por Venta', NULL, 2, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (21, 6, 'AJU_POS', 'Ajuste Positivo', NULL, 3, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (22, 6, 'AJU_NEG', 'Ajuste Negativo', NULL, 4, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (23, 6, 'TRA_ALM', 'Transferencia entre Almacenes', NULL, 5, true, '2026-01-27 20:38:29.874075-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (24, 7, 'ACT', 'Activo', NULL, 1, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (25, 7, 'PAS', 'Pasivo', NULL, 2, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (26, 7, 'PAT', 'Patrimonio', NULL, 3, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (27, 7, 'ING', 'Ingresos', NULL, 4, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (28, 7, 'GAS', 'Gastos', NULL, 5, true, '2026-01-27 20:38:29.875044-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (29, 8, 'COM', 'Completada', NULL, 1, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (30, 8, 'ANU', 'Anulada', NULL, 2, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (31, 8, 'PPG', 'Pendiente de Pago', NULL, 3, true, '2026-01-27 20:38:29.876001-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (32, 9, 'PEN', 'Pendiente', NULL, 1, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (33, 9, 'APR', 'Aprobada', NULL, 2, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (34, 9, 'REC', 'Rechazada', NULL, 3, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (35, 9, 'VEN', 'Vencida', NULL, 4, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales VALUES (36, 9, 'CVT', 'Convertida a Venta', NULL, 5, true, '2026-01-27 20:38:29.87705-05', 'SISTEMA', NULL, NULL, true);

-- TIPO MONEDA
INSERT INTO configuracion.tablas_generales VALUES (14, 'TIPO_MONEDA', 'Tipos de Moneda', NULL, true, '2026-02-12 20:00:00', 'SISTEMA', NULL, NULL, true);

INSERT INTO configuracion.tablas_generales_detalle VALUES (51, 14, 'PEN', 'Sol', 'S/', 1, true, '2026-02-12 20:00:00', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (52, 14, 'USD', 'DÃ³lar Americano', '$', 2, true, '2026-02-12 20:00:00', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (37, 10, 'ABI', 'Abierta', NULL, 1, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (38, 10, 'CIE', 'Cerrada', NULL, 2, true, '2026-01-27 20:38:29.878144-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (39, 11, 'BOR', 'Borrador', NULL, 1, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (40, 11, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (41, 11, 'APR', 'Aprobada', NULL, 3, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (42, 11, 'REC', 'Rechazada', NULL, 4, true, '2026-01-27 20:38:29.879005-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (43, 12, 'MAY', 'Mayorizado', NULL, 1, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (44, 12, 'PEN', 'Pendiente', NULL, 2, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (45, 12, 'ANU', 'Anulado', NULL, 3, true, '2026-01-27 20:38:29.880009-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (46, 13, 'PAG', 'Pagado', NULL, 1, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (47, 13, 'PAR', 'Parcial', NULL, 2, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (48, 13, 'CRE', 'A CrÃƒÂ©dito', NULL, 3, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (49, 13, 'PEN', 'Pendiente', NULL, 4, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO configuracion.tablas_generales_detalle VALUES (50, 13, 'ANU', 'Anulado', NULL, 5, true, '2026-01-27 20:38:29.881027-05', 'SISTEMA', NULL, NULL, true);
INSERT INTO identidad.menus VALUES (1, 'DASHBOARD', 'Dashboard', 'Panel principal del sistema', '/dashboard', 'dashboard', 1, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (2, 'VENTAS', 'Ventas', 'MÃ³dulo de gestiÃ³n de ventas', '/ventas', 'shopping-cart', 2, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (3, 'COMPRAS', 'Compras', 'MÃ³dulo de gestiÃ³n de compras', '/compras', 'shopping-bag', 3, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (4, 'INVENTARIO', 'Inventario', 'MÃ³dulo de gestiÃ³n de inventario', '/inventario', 'warehouse', 4, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (5, 'CLIENTES', 'Clientes', 'MÃ³dulo de gestiÃ³n de clientes', '/clientes', 'users', 5, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (6, 'CATALOGO', 'CatÃ¡logo', 'MÃ³dulo de gestiÃ³n de productos', '/catalogo', 'book', 6, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (7, 'CONTABILIDAD', 'Contabilidad', 'MÃ³dulo de contabilidad', '/contabilidad', 'calculator', 7, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (8, 'CONFIGURACION', 'ConfiguraciÃ³n', 'ConfiguraciÃ³n del sistema', '/configuracion', 'settings', 8, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (9, 'IDENTIDAD', 'Identidad', 'GestiÃ³n de usuarios y permisos', '/identidad', 'shield', 9, NULL, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (10, 'VENTAS_LISTA', 'Lista de Ventas', 'Ver todas las ventas', '/ventas/lista', 'list', 1, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (11, 'VENTAS_NUEVA', 'Nueva Venta', 'Registrar nueva venta', '/ventas/nueva', 'plus', 2, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (12, 'VENTAS_COTIZACIONES', 'Cotizaciones', 'Gestionar cotizaciones', '/ventas/cotizaciones', 'file-text', 3, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (13, 'VENTAS_CAJAS', 'Cajas', 'GestiÃ³n de cajas', '/ventas/cajas', 'credit-card', 4, 2, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (14, 'COMPRAS_LISTA', 'Lista de Compras', 'Ver todas las compras', '/compras/lista', 'list', 1, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (15, 'COMPRAS_NUEVA', 'Nueva Compra', 'Registrar nueva compra', '/compras/nueva', 'plus', 2, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (16, 'COMPRAS_ORDENES', 'Ã“rdenes de Compra', 'Gestionar Ã³rdenes', '/compras/ordenes', 'clipboard', 3, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (17, 'COMPRAS_PROVEEDORES', 'Proveedores', 'GestiÃ³n de proveedores', '/compras/proveedores', 'truck', 4, 3, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (18, 'INVENTARIO_STOCK', 'Stock', 'Consultar stock disponible', '/inventario/stock', 'package', 1, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (19, 'INVENTARIO_MOVIMIENTOS', 'Movimientos', 'Movimientos de inventario', '/inventario/movimientos', 'repeat', 2, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (20, 'INVENTARIO_ALMACENES', 'Almacenes', 'GestiÃ³n de almacenes', '/inventario/almacenes', 'home', 3, 4, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (21, 'CATALOGO_PRODUCTOS', 'Productos', 'GestiÃ³n de productos', '/catalogo/productos', 'box', 1, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (22, 'CATALOGO_CATEGORIAS', 'CategorÃ­as', 'GestiÃ³n de categorÃ­as', '/catalogo/categorias', 'folder', 2, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (23, 'CATALOGO_MARCAS', 'Marcas', 'GestiÃ³n de marcas', '/catalogo/marcas', 'tag', 3, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (24, 'CATALOGO_PRECIOS', 'Listas de Precios', 'GestiÃ³n de precios', '/catalogo/precios', 'dollar-sign', 4, 6, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (25, 'IDENTIDAD_USUARIOS', 'Usuarios', 'GestiÃ³n de usuarios', '/identidad/usuarios', 'user', 1, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (26, 'IDENTIDAD_ROLES', 'Roles', 'GestiÃ³n de roles', '/identidad/roles', 'users', 2, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.menus VALUES (27, 'IDENTIDAD_PERMISOS', 'Permisos', 'AsignaciÃ³n de permisos', '/identidad/permisos', 'lock', 3, 9, true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.roles VALUES (1, 'ADMINISTRADOR', 'Acceso total al sistema', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (2, 'VENDEDOR', 'Acceso a mÃ³dulo de ventas y clientes', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (3, 'CAJERO', 'Acceso a apertura/cierre de caja y cobros', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.roles VALUES (4, 'ALMACENERO', 'Acceso a inventarios y kardex', true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO identidad.tipos_permiso VALUES (1, 'CREATE', 'Crear', 'Permite crear nuevos registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (2, 'READ', 'Leer', 'Permite ver y consultar registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (3, 'UPDATE', 'Actualizar', 'Permite modificar registros existentes', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (4, 'DELETE', 'Eliminar', 'Permite eliminar registros', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (5, 'EXPORT', 'Exportar', 'Permite exportar datos a archivos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (6, 'IMPORT', 'Importar', 'Permite importar datos desde archivos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (7, 'APPROVE', 'Aprobar', 'Permite aprobar transacciones o documentos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (8, 'PRINT', 'Imprimir', 'Permite imprimir documentos', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.tipos_permiso VALUES (9, 'CANCEL', 'Anular', 'Permite anular documentos o transacciones', true, '2026-01-28 10:38:51.065407', 'SYSTEM', NULL, NULL);
INSERT INTO identidad.usuarios VALUES (1, 'admin', '$2a$12$R9h/cIPz0gi.URNNXRFXjOios9lnpSHkTE.oFw0kX8k.js9l0.y', 'admin@sistema.com', 'Administrador', 'Principal', 1, NULL, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO inventario.almacenes VALUES (1, 'ALMACEN CENTRAL', 'SEDE PRINCIPAL', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221140_Inicial', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260127221706_AjusteEsquema', '8.0.8');
INSERT INTO public."__EFMigrationsHistory" VALUES ('20260129221256_AgregarTiposComprobante', '8.0.0');
INSERT INTO ventas.metodos_pago VALUES (1, 'EFE', 'Efectivo', false, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (2, 'TAR', 'Tarjeta CrÃ©dito/DÃ©bito', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (3, 'TRA', 'Transferencia Bancaria', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
INSERT INTO ventas.metodos_pago VALUES (4, 'YAP', 'Yape/Plin', true, true, '2026-01-27 17:36:28.866902', 'SYSTEM', '2026-01-27 17:36:28.866902', NULL);
-- Script para agregar menÃºs de CatÃ¡logo faltantes
-- Fecha: 2026-01-29
-- DescripciÃ³n: Agrega menÃºs para Unidades de Medida y Listas de Precios

-- Primero, obtener el ID del menÃº padre "CatÃ¡logo"
-- Asumiendo que el cÃ³digo del menÃº CatÃ¡logo es 'CATALOGO'

-- Insertar menÃº para Unidades de Medida
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_UNIDADES_MEDIDA',
    'Unidades de Medida',
    'GestiÃ³n de unidades de medida',
    '/catalogo/unidades-medida',
    'Ruler',
    30,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Insertar menÃº para Listas de Precios
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre, activado, fecha_creacion, usuario_creacion)
SELECT 
    'CAT_LISTAS_PRECIOS',
    'Listas de Precios',
    'GestiÃ³n de listas de precios',
    '/catalogo/listas-precios',
    'DollarSign',
    40,
    id_menu,
    true,
    NOW(),
    'SYSTEM'
FROM identidad.menus
WHERE codigo = 'CATALOGO';

-- Asignar permisos de menÃº al rol Administrador (asumiendo id_rol = 1)
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

-- Verificar los menÃºs insertados
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
