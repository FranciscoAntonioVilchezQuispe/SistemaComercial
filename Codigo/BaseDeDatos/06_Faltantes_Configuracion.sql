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
