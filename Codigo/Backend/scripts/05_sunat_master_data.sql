/*
==============================================================================
SCRIPT: LIMPIEZA Y POBLAMIENTO MAESTRO SUNAT (16_master_sunat_data.sql)
==============================================================================
*/

-- ============================================================================
-- PASO 1: MIGRACIONES — ASEGURAR ESTRUCTURA
-- ============================================================================

-- En configuracion.tipo_comprobante
ALTER TABLE configuracion.tipo_comprobante
  ADD COLUMN IF NOT EXISTS es_emitible BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS es_referenciable BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS movimiento_stock_venta VARCHAR(10) NOT NULL DEFAULT 'NEUTRO',
  ADD COLUMN IF NOT EXISTS movimiento_stock_compra VARCHAR(10) NOT NULL DEFAULT 'NEUTRO',
  ADD COLUMN IF NOT EXISTS es_venta BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS es_compra BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS es_orden_compra BOOLEAN NOT NULL DEFAULT false;

-- En configuracion.tipo_documento
ALTER TABLE configuracion.tipo_documento
  ADD COLUMN IF NOT EXISTS es_persona_natural BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS es_empresa BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS aplica_sin_ruc BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS longitud_maxima INTEGER;

-- En ventas.notas
ALTER TABLE ventas.notas
  ADD COLUMN IF NOT EXISTS codigo_tipo_comprobante_ref VARCHAR(10),
  ADD COLUMN IF NOT EXISTS serie_ref                   VARCHAR(10),
  ADD COLUMN IF NOT EXISTS numero_ref                  VARCHAR(20),
  ADD COLUMN IF NOT EXISTS codigo_motivo               VARCHAR(2),
  ADD COLUMN IF NOT EXISTS descripcion_motivo          VARCHAR(200);

-- En compras.notas
ALTER TABLE compras.notas
  ADD COLUMN IF NOT EXISTS codigo_tipo_comprobante_ref VARCHAR(10),
  ADD COLUMN IF NOT EXISTS serie_ref                   VARCHAR(10),
  ADD COLUMN IF NOT EXISTS numero_ref                  VARCHAR(20),
  ADD COLUMN IF NOT EXISTS codigo_motivo               VARCHAR(2),
  ADD COLUMN IF NOT EXISTS descripcion_motivo          VARCHAR(200);

-- Ampliar afectacion_igv en compras.detalle_compra
ALTER TABLE compras.detalle_compra ALTER COLUMN afectacion_igv TYPE VARCHAR(2);

-- En ventas.detalle_venta
ALTER TABLE ventas.detalle_venta
  ADD COLUMN IF NOT EXISTS codigo_afectacion_igv  VARCHAR(2),
  ADD COLUMN IF NOT EXISTS codigo_tributo          VARCHAR(4),
  ADD COLUMN IF NOT EXISTS precio_unitario_base    NUMERIC(12,4),
  ADD COLUMN IF NOT EXISTS descuento_item          NUMERIC(12,4) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS valor_item              NUMERIC(12,4);

-- En compras.detalle_compra
ALTER TABLE compras.detalle_compra
  ADD COLUMN IF NOT EXISTS codigo_tributo          VARCHAR(4),
  ADD COLUMN IF NOT EXISTS precio_unitario_base    NUMERIC(12,4),
  ADD COLUMN IF NOT EXISTS descuento_item          NUMERIC(12,4) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS valor_item              NUMERIC(12,4);

-- ============================================================================
-- PASO 0: LIMPIEZA
-- ============================================================================

-- Primero las tablas que dependen de otras
TRUNCATE configuracion.matriz_regla_sunat        RESTART IDENTITY CASCADE;
TRUNCATE configuracion.regla_documento_comprobante RESTART IDENTITY CASCADE;
TRUNCATE configuracion.series_comprobantes       RESTART IDENTITY CASCADE;

-- Limpiar campos de referencia en notas (ahora que sabemos que existen las columnas)
UPDATE ventas.notas  SET codigo_tipo_comprobante_ref=NULL, serie_ref=NULL, numero_ref=NULL;
UPDATE compras.notas SET codigo_tipo_comprobante_ref=NULL, serie_ref=NULL, numero_ref=NULL;

-- Luego las tablas maestras
TRUNCATE configuracion.tipo_operacion_sunat      RESTART IDENTITY CASCADE;
TRUNCATE configuracion.tipo_comprobante          RESTART IDENTITY CASCADE;
TRUNCATE configuracion.tipo_documento            RESTART IDENTITY CASCADE;

-- ============================================================================
-- PASO 2: INSERT tipo_documento (Catálogo 06 SUNAT)
-- ============================================================================

INSERT INTO configuracion.tipo_documento
  (codigo, nombre, longitud, longitud_maxima, es_numerico,
   es_persona_natural, es_empresa, aplica_sin_ruc,
   estado, activado, fecha_creacion, usuario_creacion)
VALUES
  ('0', 'SIN DOCUMENTO', 1, 1, false, true, false, true, true, true, NOW(), 'SYSTEM'),
  ('1', 'DNI', 8, 8, true, true, false, false, true, true, NOW(), 'SYSTEM'),
  ('4', 'CARNET DE EXTRANJERIA', 9, 12, false, true, false, false, true, true, NOW(), 'SYSTEM'),
  ('6', 'RUC', 11, 11, true, false, true, false, true, true, NOW(), 'SYSTEM'),
  ('7', 'PASAPORTE', 6, 17, false, true, false, false, true, true, NOW(), 'SYSTEM'),
  ('A', 'CEDULA DIPLOMATICA de IDENTIDAD', 6, 15, false, true, false, false, true, true, NOW(), 'SYSTEM'),
  ('B', 'DOC. IDENTIDAD PAIS DE RESIDENCIA', 6, 15, false, true, false, false, true, true, NOW(), 'SYSTEM');

-- ============================================================================
-- PASO 3: INSERT tipo_comprobante (Catálogos 01 y 52 SUNAT)
-- ============================================================================

INSERT INTO configuracion.tipo_comprobante
  (codigo, nombre, mueve_stock, tipo_movimiento_stock, movimiento_stock_venta, movimiento_stock_compra,
   es_venta, es_compra, es_orden_compra, es_emitible, es_referenciable,
   activado, fecha_creacion, usuario_creacion)
VALUES
  ('01', 'FACTURA', true, 'SALIDA', 'SALIDA', 'NEUTRO', true, false, false, true, true, true, NOW(), 'SYSTEM'),
  ('03', 'BOLETA DE VENTA', true, 'SALIDA', 'SALIDA', 'NEUTRO', true, false, false, true, true, true, NOW(), 'SYSTEM'),
  ('02', 'RECIBO POR HONORARIOS', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', true, false, false, true, true, true, NOW(), 'SYSTEM'),
  ('04', 'LIQUIDACION DE COMPRA', true, 'ENTRADA', 'NEUTRO', 'ENTRADA', false, true, false, true, true, true, NOW(), 'SYSTEM'),
  ('07', 'NOTA DE CREDITO', true, 'DEPENDIENTE', 'ENTRADA', 'SALIDA', false, false, false, true, true, true, NOW(), 'SYSTEM'),
  ('08', 'NOTA DE DEBITO', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, true, true, true, NOW(), 'SYSTEM'),
  ('09', 'GUIA DE REMISION REMITENTE', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM'),
  ('31', 'GUIA DE REMISION TRANSPORTISTA', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM'),
  ('50', 'DUA', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM'),
  ('52', 'DESPACHO SIMPLIFICADO', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM'),
  ('87', 'NOTA DE CREDITO ESPECIAL', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM'),
  ('88', 'NOTA DE DEBITO ESPECIAL', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', false, false, false, false, true, true, NOW(), 'SYSTEM');

-- ============================================================================
-- PASO 4: INSERT tipo_operacion_sunat (Catálogo 51 SUNAT)
-- ============================================================================

INSERT INTO configuracion.tipo_operacion_sunat (codigo, nombre)
VALUES
  ('0101', 'VENTA INTERNA'), ('0112', 'VENTA INTERNA - GASTOS DEDUCIBLES'), ('0113', 'VENTA INTERNA - NRUS'),
  ('0200', 'EXPORTACION DE BIENES'), ('0201', 'EXPORTACION DE SERVICIOS'), ('0202', 'EXPORTACION - HOSPEDAJE'),
  ('0300', 'NO ONEROSA - ADQUISICION DE BIENES'), ('0401', 'TRASLADO ENTRE ESTABLECIMIENTOS'),
  ('1001', 'OPERACION SUJETA A DETRACCION'), ('2001', 'OPERACION SUJETA A PERCEPCION');

-- ============================================================================
-- PASO 5: REGLAS Y SERIES (INSERCIONES INDIVIDUALES PARA ASEGURAR PERSISTENCIA)
-- ============================================================================
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('6', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '01'));
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('6', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '03'));
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('1', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '03'));
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('6', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '02'));
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('6', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '07'));
INSERT INTO configuracion.regla_documento_comprobante (codigo_documento, id_tipo_comprobante) VALUES ('1', (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '07'));

INSERT INTO configuracion.series_comprobantes (serie, correlativo_actual, id_tipo_comprobante) VALUES ('F001', 0, (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '01'));
INSERT INTO configuracion.series_comprobantes (serie, correlativo_actual, id_tipo_comprobante) VALUES ('B001', 0, (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '03'));
INSERT INTO configuracion.series_comprobantes (serie, correlativo_actual, id_tipo_comprobante) VALUES ('FC01', 0, (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '07'));
INSERT INTO configuracion.series_comprobantes (serie, correlativo_actual, id_tipo_comprobante) VALUES ('FD01', 0, (SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '08'));

INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '01'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0101'), 1);
INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '03'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0101'), 1);
INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '07'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0101'), 1);
INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '08'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0101'), 1);
INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '04'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0101'), 1);
INSERT INTO configuracion.matriz_regla_sunat (id_tipo_comprobante, id_tipo_operacion, nivel_obligatoriedad) VALUES ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '04'), (SELECT id_tipo_operacion FROM configuracion.tipo_operacion_sunat WHERE codigo = '0300'), 1);
