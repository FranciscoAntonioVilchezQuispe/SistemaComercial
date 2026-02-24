-- =====================================================
-- SCRIPT DE ESTRUCTURA: Reglas SUNAT y Traslados (V2)
-- =====================================================

-- 1. Tipos de Operación SUNAT (Tabla 12)
CREATE TABLE IF NOT EXISTS configuracion.tipo_operacion_sunat (
    id_tipo_operacion SERIAL PRIMARY KEY,
    codigo CHAR(2) UNIQUE NOT NULL, -- 01, 02, 11, etc.
    nombre VARCHAR(200) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(100)
);

-- 2. Matriz de Reglas SUNAT (Referencial)
CREATE TABLE IF NOT EXISTS configuracion.matriz_regla_sunat (
    id_regla SERIAL PRIMARY KEY,
    id_tipo_operacion INTEGER NOT NULL REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion),
    id_tipo_comprobante INTEGER NOT NULL REFERENCES configuracion.tipo_comprobante(id_tipo_comprobante),
    nivel_obligatoriedad INTEGER DEFAULT 0, -- 0=N/A, 1=🔵, 2=🟡
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(100)
);

-- 3. Cabecera de Traslados (Inventario)
CREATE TABLE IF NOT EXISTS inventario.traslados (
    id_traslado SERIAL PRIMARY KEY,
    numero_traslado VARCHAR(20) UNIQUE NOT NULL,
    almacen_origen_id BIGINT NOT NULL,
    almacen_destino_id BIGINT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_despacho TIMESTAMP,
    fecha_recepcion TIMESTAMP,
    gr_serie VARCHAR(10),
    gr_numero VARCHAR(20),
    estado VARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE, EN_TRANSITO, RECIBIDO, ANULADO
    id_usuario_despacho BIGINT,
    id_usuario_recepcion BIGINT,
    observaciones TEXT
);

-- 4. Detalle de Traslados (Inventario)
CREATE TABLE IF NOT EXISTS inventario.traslados_detalle (
    id_detalle_traslado SERIAL PRIMARY KEY,
    id_traslado INTEGER REFERENCES inventario.traslados(id_traslado),
    id_producto BIGINT NOT NULL,
    cantidad_solicitada DECIMAL(18,6) NOT NULL,
    cantidad_despachada DECIMAL(18,6) DEFAULT 0,
    cantidad_recibida DECIMAL(18,6) DEFAULT 0,
    costo_unitario_despacho DECIMAL(18,6),
    observaciones TEXT
);

-- 5. Incidencias de Traslados
CREATE TABLE IF NOT EXISTS inventario.traslados_incidencias (
    id_incidencia SERIAL PRIMARY KEY,
    id_detalle_traslado INTEGER REFERENCES inventario.traslados_detalle(id_detalle_traslado),
    tipo_incidencia VARCHAR(20), -- FALTANTE, DAÑADO, SOBRANTE
    cantidad DECIMAL(18,6) NOT NULL,
    descripcion TEXT
);
