-- =====================================================
-- Script de Inicialización: Sistema de Permisos Granulares
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
-- 2. CREAR ÍNDICES
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
-- 4. INSERTAR DATOS INICIALES - MENÚS
-- =====================================================

-- Menús principales (sin padre)
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden) 
VALUES
    ('DASHBOARD', 'Dashboard', 'Panel principal del sistema', '/dashboard', 'dashboard', 1),
    ('VENTAS', 'Ventas', 'Módulo de gestión de ventas', '/ventas', 'shopping-cart', 2),
    ('COMPRAS', 'Compras', 'Módulo de gestión de compras', '/compras', 'shopping-bag', 3),
    ('INVENTARIO', 'Inventario', 'Módulo de gestión de inventario', '/inventario', 'warehouse', 4),
    ('CLIENTES', 'Clientes', 'Módulo de gestión de clientes', '/clientes', 'users', 5),
    ('CATALOGO', 'Catálogo', 'Módulo de gestión de productos', '/catalogo', 'book', 6),
    ('CONTABILIDAD', 'Contabilidad', 'Módulo de contabilidad', '/contabilidad', 'calculator', 7),
    ('CONFIGURACION', 'Configuración', 'Configuración del sistema', '/configuracion', 'settings', 8),
    ('IDENTIDAD', 'Identidad', 'Gestión de usuarios y permisos', '/identidad', 'shield', 9)
ON CONFLICT (codigo) DO NOTHING;

-- Submenús de VENTAS
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('VENTAS_LISTA', 'Lista de Ventas', 'Ver todas las ventas', '/ventas/lista', 'list', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_NUEVA', 'Nueva Venta', 'Registrar nueva venta', '/ventas/nueva', 'plus', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_COTIZACIONES', 'Cotizaciones', 'Gestionar cotizaciones', '/ventas/cotizaciones', 'file-text', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS')),
    ('VENTAS_CAJAS', 'Cajas', 'Gestión de cajas', '/ventas/cajas', 'credit-card', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'VENTAS'))
ON CONFLICT (codigo) DO NOTHING;

-- Submenús de COMPRAS
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('COMPRAS_LISTA', 'Lista de Compras', 'Ver todas las compras', '/compras/lista', 'list', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_NUEVA', 'Nueva Compra', 'Registrar nueva compra', '/compras/nueva', 'plus', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_ORDENES', 'Órdenes de Compra', 'Gestionar órdenes', '/compras/ordenes', 'clipboard', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS')),
    ('COMPRAS_PROVEEDORES', 'Proveedores', 'Gestión de proveedores', '/compras/proveedores', 'truck', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'COMPRAS'))
ON CONFLICT (codigo) DO NOTHING;

-- Submenús de INVENTARIO
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('INVENTARIO_STOCK', 'Stock', 'Consultar stock disponible', '/inventario/stock', 'package', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO')),
    ('INVENTARIO_MOVIMIENTOS', 'Movimientos', 'Movimientos de inventario', '/inventario/movimientos', 'repeat', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO')),
    ('INVENTARIO_ALMACENES', 'Almacenes', 'Gestión de almacenes', '/inventario/almacenes', 'home', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'INVENTARIO'))
ON CONFLICT (codigo) DO NOTHING;

-- Submenús de CATALOGO
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('CATALOGO_PRODUCTOS', 'Productos', 'Gestión de productos', '/catalogo/productos', 'box', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_CATEGORIAS', 'Categorías', 'Gestión de categorías', '/catalogo/categorias', 'folder', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_MARCAS', 'Marcas', 'Gestión de marcas', '/catalogo/marcas', 'tag', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO')),
    ('CATALOGO_PRECIOS', 'Listas de Precios', 'Gestión de precios', '/catalogo/precios', 'dollar-sign', 4, (SELECT id_menu FROM identidad.menus WHERE codigo = 'CATALOGO'))
ON CONFLICT (codigo) DO NOTHING;

-- Submenús de IDENTIDAD
INSERT INTO identidad.menus (codigo, nombre, descripcion, ruta, icono, orden, id_menu_padre) 
VALUES
    ('IDENTIDAD_USUARIOS', 'Usuarios', 'Gestión de usuarios', '/identidad/usuarios', 'user', 1, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD')),
    ('IDENTIDAD_ROLES', 'Roles', 'Gestión de roles', '/identidad/roles', 'users', 2, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD')),
    ('IDENTIDAD_PERMISOS', 'Permisos', 'Asignación de permisos', '/identidad/permisos', 'lock', 3, (SELECT id_menu FROM identidad.menus WHERE codigo = 'IDENTIDAD'))
ON CONFLICT (codigo) DO NOTHING;

-- =====================================================
-- 5. VERIFICACIÓN
-- =====================================================

-- Contar registros insertados
SELECT 'Tipos de Permiso' as tabla, COUNT(*) as total FROM identidad.tipos_permiso
UNION ALL
SELECT 'Menús', COUNT(*) FROM identidad.menus
UNION ALL
SELECT 'Roles-Menús', COUNT(*) FROM identidad.roles_menus
UNION ALL
SELECT 'Roles-Menús-Permisos', COUNT(*) FROM identidad.roles_menus_permisos
UNION ALL
SELECT 'Usuarios-Roles', COUNT(*) FROM identidad.usuarios_roles;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
