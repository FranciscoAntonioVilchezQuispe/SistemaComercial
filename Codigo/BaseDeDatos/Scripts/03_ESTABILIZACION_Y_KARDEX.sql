-- =============================================================================
-- SCRIPT: 03_ESTABILIZACION_Y_KARDEX.sql
-- FECHA: 2026-04-16
-- DESCRIPCIÃ“N: ConsolidaciÃ³n de tablas maestras de inventario, configuraciÃ³n 
--              de movimientos de stock y limpiezas de datos post-integraciÃ³n.
-- =============================================================================

-- 1. CREACIÃ“N DE TABLA TIPOS DE MOVIMIENTO (SUNAT TABLA 12)
-- Estandariza los tipos de movimiento del Kardex segÃºn SUNAT.

CREATE TABLE IF NOT EXISTS inventario.tipos_movimiento (
    id_tipo_movimiento BIGINT PRIMARY KEY,
    codigo CHARACTER VARYING(10) NOT NULL, -- CÃ³digo SUNAT (Tabla 12)
    nombre CHARACTER VARYING(100) NOT NULL,
    factor DECIMAL(3,2) DEFAULT 0 NOT NULL, -- 1 para entrada, -1 para salida, 0 para informativo
    mueve_stock BOOLEAN DEFAULT TRUE NOT NULL,
    activado BOOLEAN DEFAULT TRUE NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion CHARACTER VARYING(100) DEFAULT 'SISTEMA' NOT NULL,
    fecha_modificacion TIMESTAMP WITH TIME ZONE,
    usuario_modificacion CHARACTER VARYING(100)
);

-- Ãndice por cÃ³digo para bÃºsquedas rÃ¡pidas
CREATE INDEX IF NOT EXISTS idx_tipos_movimiento_codigo ON inventario.tipos_movimiento(codigo);

-- 2. CARGA DE DATOS MAESTROS (TIPOS DE MOVIMIENTO)
-- Los IDs coinciden con el Enum TipoMovimientoInventario del Backend.

DELETE FROM inventario.tipos_movimiento WHERE id_tipo_movimiento BETWEEN 1 AND 50;

INSERT INTO inventario.tipos_movimiento (id_tipo_movimiento, codigo, nombre, factor, mueve_stock)
VALUES 
(19, '02', 'COMPRA NACIONAL', 1, true),
(20, '01', 'VENTA NACIONAL', -1, true),
(21, '13', 'AJUSTE POSITIVO (SOBRANTE)', 1, true),
(22, '14', 'AJUSTE NEGATIVO (MERMA/PERDIDA)', -1, true),
(23, '04', 'TRANSFERENCIA ENTRE ALMACENES', 0, true),
(24, '06', 'NC COMPRA (DEVOLUCION A PROVEEDOR)', -1, true),
(25, '05', 'NC VENTA (DEVOLUCION DE CLIENTE)', 1, true),
(26, '02', 'ND COMPRA (INCREMENTO COSTO/CANT)', 1, true),
(27, '01', 'ND VENTA (INCREMENTO VENTA)', -1, true),
(28, '16', 'SALDO INICIAL', 1, true)
ON CONFLICT (id_tipo_movimiento) DO UPDATE 
SET codigo = EXCLUDED.codigo, 
    nombre = EXCLUDED.nombre, 
    factor = EXCLUDED.factor, 
    mueve_stock = EXCLUDED.mueve_stock;

-- 3. CONFIGURACIÃ“N DE NOTAS PARA EL KARDEX (COMPROBANTES)
-- Asegura que las notas muevan stock correctamente segÃºn el mÃ³dulo.

-- Actualizar configuraciÃ³n para Nota de CrÃ©dito (07)
UPDATE configuracion.tipo_comprobante
SET mueve_stock = true,
    tipo_movimiento_stock = 'DEPENDIENTE',
    movimiento_stock_venta = 'ENTRADA', -- NC Venta es una devoluciÃ³n del cliente (Ingreso)
    movimiento_stock_compra = 'SALIDA',  -- NC Compra es una devoluciÃ³n al proveedor (Salida)
    fecha_modificacion = CURRENT_TIMESTAMP,
    usuario_modificacion = 'SISTEMA_KARDEX'
WHERE codigo = '07';

-- Actualizar configuraciÃ³n para Nota de DÃ©bito (08)
UPDATE configuracion.tipo_comprobante
SET mueve_stock = true,
    tipo_movimiento_stock = 'DEPENDIENTE',
    movimiento_stock_venta = 'SALIDA',  -- ND Venta aumenta la deuda/cantidad vendida (Salida)
    movimiento_stock_compra = 'ENTRADA', -- ND Compra aumenta la deuda/cantidad comprada (Entrada)
    fecha_modificacion = CURRENT_TIMESTAMP,
    usuario_modificacion = 'SISTEMA_KARDEX'
WHERE codigo = '08';

-- 4. LIMPIEZA DE DATOS TRANSACCIONALES (FIX AMBIENTAL)
-- Esta secciÃ³n es para regularizar inconsistencias de stock durante pruebas.

DO $$
BEGIN
    -- Limpieza de NC de prueba si existen
    DELETE FROM compras.nota_credito_detalle WHERE id_nota_credito = 1;
    DELETE FROM compras.nota_credito WHERE id_nota = 1;

    -- Restaurar estado de compra de prueba
    UPDATE compras.compras 
    SET id_estado = 1, -- Registrado
        id_nota_credito = NULL,
        tipo_anulacion = NULL,
        fecha_anulacion = NULL,
        motivo_anulacion = NULL,
        observaciones = 'Restaurado por limpieza consolidada'
    WHERE id_compra = 1;

    RAISE NOTICE 'Script 03_ESTABILIZACION_Y_KARDEX ejecutado exitosamente.';
END $$;
