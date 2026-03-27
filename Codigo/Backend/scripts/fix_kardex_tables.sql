-- Script de emergencia para crear/corregir tablas de Kardex faltantes
-- Basado en la arquitectura del proyecto y EntidadBase para auditoría

-- Asegurar existencia del esquema
CREATE SCHEMA IF NOT EXISTS inventario;

-- 1. Tabla: inv_kardex_lote
CREATE TABLE IF NOT EXISTS inventario.inv_kardex_lote (
    id bigserial PRIMARY KEY,
    producto_id bigint NOT NULL,
    almacen_id bigint NOT NULL,
    fecha_entrada date NOT NULL,
    hora_entrada time NOT NULL,
    movimiento_origen_id bigint NOT NULL,
    costo_unitario numeric(18,6) NOT NULL,
    cantidad_original numeric(18,6) NOT NULL,
    cantidad_disponible numeric(18,6) NOT NULL,
    estado varchar(1) NOT NULL DEFAULT 'A',
    activado boolean NOT NULL DEFAULT true,
    fecha_creacion timestamp without time zone NOT NULL DEFAULT NOW(),
    usuario_creacion varchar(50) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion timestamp without time zone,
    usuario_modificacion varchar(50)
);

-- 2. Tabla: inv_kardex_movimiento
CREATE TABLE IF NOT EXISTS inventario.inv_kardex_movimiento (
    id bigserial PRIMARY KEY,
    uuid varchar(36) NOT NULL,
    periodo varchar(7) NOT NULL,
    correlativo_kardex bigint NOT NULL,
    fecha_movimiento date NOT NULL,
    hora_movimiento time NOT NULL,
    fecha_hora_compuesta timestamp without time zone NOT NULL,
    modulo_origen varchar(30) NOT NULL,
    tipo_documento varchar(2) NOT NULL,
    serie_documento varchar(10) NOT NULL,
    numero_documento varchar(20) NOT NULL,
    anulado boolean NOT NULL DEFAULT false,
    fecha_anulacion date,
    motivo_anulacion text,
    tipo_operacion varchar(1) NOT NULL,
    motivo_traslado_sunat varchar(4) NOT NULL, -- AMPLIADO A 4 PARA CATÁLOGO 51
    descripcion_movimiento varchar(255) NOT NULL,
    almacen_id bigint NOT NULL,
    almacen_origen_id bigint,
    almacen_destino_id bigint,
    producto_id bigint NOT NULL,
    unidad_medida_codigo varchar(10) NOT NULL,
    factor_conversion numeric(18,6) NOT NULL,
    entrada_cantidad numeric(18,6),
    entrada_costo_unitario numeric(18,6),
    entrada_costo_total numeric(18,6),
    salida_cantidad numeric(18,6),
    salida_costo_unitario numeric(18,6),
    salida_costo_total numeric(18,6),
    saldo_cantidad numeric(18,6) NOT NULL,
    saldo_costo_unitario numeric(18,6) NOT NULL,
    saldo_costo_total numeric(18,6) NOT NULL,
    referencia_id bigint,
    referencia_tipo varchar(50),
    lote_id bigint,
    proveedor_cliente_id bigint,
    observaciones text,
    usuario_registro_id bigint NOT NULL,
    usuario_anulacion_id bigint,
    recalculado_at timestamp without time zone,
    activado boolean NOT NULL DEFAULT true,
    fecha_creacion timestamp without time zone NOT NULL DEFAULT NOW(),
    usuario_creacion varchar(50) NOT NULL DEFAULT 'SYSTEM',
    fecha_modificacion timestamp without time zone,
    usuario_modificacion varchar(50)
);

-- CORRECCIÓN SI LA TABLA YA EXISTÍA CON VARCHAR(2)
ALTER TABLE inventario.inv_kardex_movimiento 
ALTER COLUMN motivo_traslado_sunat TYPE varchar(4);

-- 3. Tabla: inv_kardex_periodo_control
CREATE TABLE IF NOT EXISTS inventario.inv_kardex_periodo_control (
    periodo varchar(7) PRIMARY KEY,
    estado varchar(1) NOT NULL DEFAULT 'A',
    fecha_cierre date,
    usuario_cierre_id bigint,
    created_at timestamp without time zone NOT NULL DEFAULT NOW(),
    updated_at timestamp without time zone
);

-- 4. Tabla: inv_kardex_recalculo_log
CREATE TABLE IF NOT EXISTS inventario.inv_kardex_recalculo_log (
    id bigserial PRIMARY KEY,
    almacen_id integer NOT NULL,
    producto_id integer NOT NULL,
    desde_fecha date NOT NULL,
    motivo varchar(30) NOT NULL,
    registros_afect integer NOT NULL,
    usuario_id integer NOT NULL,
    duracion_ms integer,
    created_at timestamp without time zone NOT NULL DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS ix_inv_kardex_movimiento_fecha_hora ON inventario.inv_kardex_movimiento (fecha_movimiento, hora_movimiento);
CREATE INDEX IF NOT EXISTS ix_inv_kardex_movimiento_periodo_prod ON inventario.inv_kardex_movimiento (periodo, almacen_id, producto_id);
CREATE INDEX IF NOT EXISTS ix_inv_kardex_movimiento_ref ON inventario.inv_kardex_movimiento (referencia_id, referencia_tipo);
CREATE INDEX IF NOT EXISTS ix_inv_kardex_movimiento_doc ON inventario.inv_kardex_movimiento (tipo_documento, serie_documento, numero_documento);

-- Crear el periodo actual
INSERT INTO inventario.inv_kardex_periodo_control (periodo, estado) 
VALUES ('2026-03', 'A')
ON CONFLICT (periodo) DO NOTHING;
