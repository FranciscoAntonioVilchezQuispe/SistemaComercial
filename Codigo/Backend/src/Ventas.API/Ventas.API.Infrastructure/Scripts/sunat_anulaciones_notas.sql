-- Implementación de Anulaciones y Notas SUNAT (Esquema Ventas)
-- [2026-03-29] Traducción a PostgreSQL

-- 1. Modificar tabla ventas para campos de anulación
ALTER TABLE ventas.ventas 
ADD COLUMN IF NOT EXISTS fecha_anulacion TIMESTAMP NULL,
ADD COLUMN IF NOT EXISTS motivo_anulacion TEXT NULL,
ADD COLUMN IF NOT EXISTS numero_resumen_baja VARCHAR(50) NULL,
ADD COLUMN IF NOT EXISTS estado_sunat VARCHAR(20) DEFAULT 'PENDIENTE';

-- 2. Tabla Nota de Crédito
CREATE TABLE IF NOT EXISTS ventas.nota_credito (
    id_nota                 BIGSERIAL PRIMARY KEY,
    serie                   VARCHAR(4)        NOT NULL,
    numero                  BIGINT            NOT NULL,
    tipo_comprobante        VARCHAR(2)        NOT NULL DEFAULT '07',
    
    id_venta_referencia     BIGINT            NOT NULL,
    serie_referencia        VARCHAR(4)        NOT NULL,
    numero_referencia       BIGINT            NOT NULL,
    tipo_doc_referencia     VARCHAR(2)        NOT NULL,
    
    id_tipo_nota            BIGINT            NOT NULL, -- FK a configuracion.motivo_nota_credito
    motivo_sustento         TEXT              NOT NULL,
    
    cliente_tipo_doc        VARCHAR(2)        NOT NULL,
    cliente_nro_doc         VARCHAR(15)       NOT NULL,
    cliente_razon_social    VARCHAR(250)      NOT NULL,
    
    subtotal                DECIMAL(12,2)     NOT NULL DEFAULT 0,
    igv                     DECIMAL(12,2)     NOT NULL DEFAULT 0,
    total                   DECIMAL(12,2)     NOT NULL DEFAULT 0,
    porcentaje_igv          DECIMAL(5,2)      NOT NULL DEFAULT 18.00,
    moneda                  VARCHAR(3)        NOT NULL DEFAULT 'PEN',
    tipo_cambio             DECIMAL(10,4)     NULL,
    
    afecta_stock            BOOLEAN           NOT NULL DEFAULT FALSE,
    fecha_emision           DATE              NOT NULL,
    estado                  VARCHAR(20)       NOT NULL DEFAULT 'PENDIENTE',
    fecha_envio_sunat       TIMESTAMP         NULL,
    respuesta_sunat_codigo  VARCHAR(10)       NULL,
    respuesta_sunat_desc    TEXT              NULL,
    hash_cdr                TEXT              NULL,
    xml_generado            TEXT              NULL,
    
    -- Auditoría (EntidadBase)
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion    VARCHAR(50)       NULL,
    fecha_modificacion      TIMESTAMP         NULL,
    usuario_eliminacion     VARCHAR(50)       NULL,
    fecha_eliminacion       TIMESTAMP         NULL,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_nc_venta FOREIGN KEY (id_venta_referencia) REFERENCES ventas.ventas(id_venta)
);

-- 3. Tabla Detalle de Nota de Crédito
CREATE TABLE IF NOT EXISTS ventas.nota_credito_detalle (
    id_detalle              BIGSERIAL PRIMARY KEY,
    id_nota_credito         BIGINT            NOT NULL,
    id_venta_detalle        BIGINT            NULL,
    id_producto             BIGINT            NOT NULL,
    descripcion             VARCHAR(500)      NOT NULL,
    unidad_medida           VARCHAR(10)       NOT NULL DEFAULT 'NIU',
    cantidad                DECIMAL(12,4)     NOT NULL,
    precio_unitario         DECIMAL(12,4)     NOT NULL,
    subtotal                DECIMAL(12,2)     NOT NULL,
    igv                     DECIMAL(12,2)     NOT NULL,
    total                   DECIMAL(12,2)     NOT NULL,
    
    -- Auditoría
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_ncd_nota_credito FOREIGN KEY (id_nota_credito) REFERENCES ventas.nota_credito(id_nota)
);

-- 4. Tabla Nota de Débito
CREATE TABLE IF NOT EXISTS ventas.nota_debito (
    id_nota                 BIGSERIAL PRIMARY KEY,
    serie                   VARCHAR(4)        NOT NULL,
    numero                  BIGINT            NOT NULL,
    tipo_comprobante        VARCHAR(2)        NOT NULL DEFAULT '08',
    
    id_venta_referencia     BIGINT            NOT NULL,
    serie_referencia        VARCHAR(4)        NOT NULL,
    numero_referencia       BIGINT            NOT NULL,
    tipo_doc_referencia     VARCHAR(2)        NOT NULL,
    
    id_tipo_nota            BIGINT            NOT NULL, -- FK a configuracion.motivo_nota_debito
    motivo_sustento         TEXT              NOT NULL,
    
    cliente_tipo_doc        VARCHAR(2)        NOT NULL,
    cliente_nro_doc         VARCHAR(15)       NOT NULL,
    cliente_razon_social    VARCHAR(250)      NOT NULL,
    
    subtotal                DECIMAL(12,2)     NOT NULL DEFAULT 0,
    igv                     DECIMAL(12,2)     NOT NULL DEFAULT 0,
    total                   DECIMAL(12,2)     NOT NULL DEFAULT 0,
    porcentaje_igv          DECIMAL(5,2)      NOT NULL DEFAULT 18.00,
    moneda                  VARCHAR(3)        NOT NULL DEFAULT 'PEN',
    tipo_cambio             DECIMAL(10,4)     NULL,
    
    afecta_stock            BOOLEAN           NOT NULL DEFAULT FALSE,
    fecha_emision           DATE              NOT NULL,
    estado                  VARCHAR(20)       NOT NULL DEFAULT 'PENDIENTE',
    fecha_envio_sunat       TIMESTAMP         NULL,
    respuesta_sunat_codigo  VARCHAR(10)       NULL,
    respuesta_sunat_desc    TEXT              NULL,
    hash_cdr                TEXT              NULL,
    xml_generado            TEXT              NULL,
    
    -- Auditoría
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion    VARCHAR(50)       NULL,
    fecha_modificacion      TIMESTAMP         NULL,
    usuario_eliminacion     VARCHAR(50)       NULL,
    fecha_eliminacion       TIMESTAMP         NULL,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_nd_venta FOREIGN KEY (id_venta_referencia) REFERENCES ventas.ventas(id_venta)
);

-- 5. Tabla Detalle de Nota de Débito
CREATE TABLE IF NOT EXISTS ventas.nota_debito_detalle (
    id_detalle              BIGSERIAL PRIMARY KEY,
    id_nota_debito          BIGINT            NOT NULL,
    id_venta_detalle        BIGINT            NULL,
    id_producto             BIGINT            NOT NULL,
    descripcion             VARCHAR(500)      NOT NULL,
    unidad_medida           VARCHAR(10)       NOT NULL DEFAULT 'NIU',
    cantidad                DECIMAL(12,4)     NOT NULL DEFAULT 0,
    precio_unitario         DECIMAL(12,4)     NOT NULL,
    subtotal                DECIMAL(12,2)     NOT NULL,
    igv                     DECIMAL(12,2)     NOT NULL,
    total                   DECIMAL(12,2)     NOT NULL,
    
    -- Auditoría
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_ndd_nota_debito FOREIGN KEY (id_nota_debito) REFERENCES ventas.nota_debito(id_nota)
);

-- Índices sugeridos
CREATE INDEX IF NOT EXISTS idx_nc_venta_ref ON ventas.nota_credito(id_venta_referencia);
CREATE INDEX IF NOT EXISTS idx_nd_venta_ref ON ventas.nota_debito(id_venta_referencia);
