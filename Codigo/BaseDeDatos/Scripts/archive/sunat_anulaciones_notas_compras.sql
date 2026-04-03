-- Implementación de Anulaciones y Notas SUNAT (Esquema Compras)
-- [2026-03-29] Traducción a PostgreSQL

-- 1. Modificar tabla compras para campos de anulación
ALTER TABLE compras.compras 
ADD COLUMN IF NOT EXISTS fecha_anulacion TIMESTAMP NULL,
ADD COLUMN IF NOT EXISTS motivo_anulacion TEXT NULL,
ADD COLUMN IF NOT EXISTS estado_sunat VARCHAR(20) DEFAULT 'EMITIDO';

-- 2. Tabla Nota de Crédito (Compra)
CREATE TABLE IF NOT EXISTS compras.nota_credito (
    id_nota                 BIGSERIAL PRIMARY KEY,
    serie                   VARCHAR(10)       NOT NULL,
    numero                  VARCHAR(20)       NOT NULL,
    tipo_comprobante        VARCHAR(2)        NOT NULL DEFAULT '07',
    
    id_compra_referencia    BIGINT            NOT NULL,
    serie_referencia        VARCHAR(10)       NOT NULL,
    numero_referencia       VARCHAR(20)       NOT NULL,
    tipo_doc_referencia     VARCHAR(2)        NOT NULL,
    
    id_tipo_nota            BIGINT            NOT NULL, -- FK a configuracion.motivo_nota_credito
    motivo_sustento         TEXT              NOT NULL,
    
    id_proveedor            BIGINT            NOT NULL,
    proveedor_tipo_doc      VARCHAR(2)        NOT NULL,
    proveedor_nro_doc       VARCHAR(15)       NOT NULL,
    proveedor_razon_social  VARCHAR(250)      NOT NULL,
    
    subtotal                DECIMAL(12,2)     NOT NULL DEFAULT 0,
    igv                     DECIMAL(12,2)     NOT NULL DEFAULT 0,
    total                   DECIMAL(12,2)     NOT NULL DEFAULT 0,
    moneda                  VARCHAR(3)        NOT NULL DEFAULT 'PEN',
    tipo_cambio             DECIMAL(10,4)     NULL,
    
    afecta_stock            BOOLEAN           NOT NULL DEFAULT FALSE,
    fecha_emision           DATE              NOT NULL,
    estado                  VARCHAR(20)       NOT NULL DEFAULT 'PENDIENTE',
    
    -- Auditoría (EntidadBase)
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion    VARCHAR(50)       NULL,
    fecha_modificacion      TIMESTAMP         NULL,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_nc_compra FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras(id_compra)
);

-- 3. Tabla Detalle de Nota de Crédito (Compra)
CREATE TABLE IF NOT EXISTS compras.nota_credito_detalle (
    id_detalle              BIGSERIAL PRIMARY KEY,
    id_nota_credito         BIGINT            NOT NULL,
    id_compra_detalle       BIGINT            NULL,
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

    CONSTRAINT fk_ncd_nota_credito FOREIGN KEY (id_nota_credito) REFERENCES compras.nota_credito(id_nota)
);

-- 4. Tabla Nota de Débito (Compra)
CREATE TABLE IF NOT EXISTS compras.nota_debito (
    id_nota                 BIGSERIAL PRIMARY KEY,
    serie                   VARCHAR(10)       NOT NULL,
    numero                  VARCHAR(20)       NOT NULL,
    tipo_comprobante        VARCHAR(2)        NOT NULL DEFAULT '08',
    
    id_compra_referencia    BIGINT            NOT NULL,
    serie_referencia        VARCHAR(10)       NOT NULL,
    numero_referencia       VARCHAR(20)       NOT NULL,
    tipo_doc_referencia     VARCHAR(2)        NOT NULL,
    
    id_tipo_nota            BIGINT            NOT NULL, -- FK a configuracion.motivo_nota_debito
    motivo_sustento         TEXT              NOT NULL,
    
    id_proveedor            BIGINT            NOT NULL,
    proveedor_tipo_doc      VARCHAR(2)        NOT NULL,
    proveedor_nro_doc       VARCHAR(15)       NOT NULL,
    proveedor_razon_social  VARCHAR(250)      NOT NULL,
    
    subtotal                DECIMAL(12,2)     NOT NULL DEFAULT 0,
    igv                     DECIMAL(12,2)     NOT NULL DEFAULT 0,
    total                   DECIMAL(12,2)     NOT NULL DEFAULT 0,
    moneda                  VARCHAR(3)        NOT NULL DEFAULT 'PEN',
    tipo_cambio             DECIMAL(10,4)     NULL,
    
    afecta_stock            BOOLEAN           NOT NULL DEFAULT FALSE,
    fecha_emision           DATE              NOT NULL,
    estado                  VARCHAR(20)       NOT NULL DEFAULT 'PENDIENTE',
    
    -- Auditoría
    usuario_creacion        VARCHAR(50)       NOT NULL,
    fecha_creacion          TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_modificacion    VARCHAR(50)       NULL,
    fecha_modificacion      TIMESTAMP         NULL,
    activado                BOOLEAN           NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_nd_compra FOREIGN KEY (id_compra_referencia) REFERENCES compras.compras(id_compra)
);

-- 5. Tabla Detalle de Nota de Débito (Compra)
CREATE TABLE IF NOT EXISTS compras.nota_debito_detalle (
    id_detalle              BIGSERIAL PRIMARY KEY,
    id_nota_debito          BIGINT            NOT NULL,
    id_compra_detalle       BIGINT            NULL,
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

    CONSTRAINT fk_ndd_nota_debito FOREIGN KEY (id_nota_debito) REFERENCES compras.nota_debito(id_nota)
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_nc_compra_ref ON compras.nota_credito(id_compra_referencia);
CREATE INDEX IF NOT EXISTS idx_nd_compra_ref ON compras.nota_debito(id_compra_referencia);
