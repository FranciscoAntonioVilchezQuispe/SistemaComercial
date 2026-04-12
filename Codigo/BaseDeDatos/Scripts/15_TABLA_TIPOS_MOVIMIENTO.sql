-- SCRIPT: CREACIÓN DE TABLA TIPOS DE MOVIMIENTO (SUNAT TABLA 12)
-- FECHA: 2026-04-07
-- DESCRIPCIÓN: Estandariza los tipos de movimiento del Kardex según SUNAT.

-- 1. Crear tabla en el esquema inventario
CREATE TABLE IF NOT EXISTS inventario.tipos_movimiento (
    id_tipo_movimiento BIGINT PRIMARY KEY,
    codigo CHARACTER VARYING(10) NOT NULL, -- Código SUNAT (Tabla 12)
    nombre CHARACTER VARYING(100) NOT NULL,
    factor DECIMAL(3,2) DEFAULT 0 NOT NULL, -- 1 para entrada, -1 para salida, 0 para informativo
    mueve_stock BOOLEAN DEFAULT TRUE NOT NULL,
    activado BOOLEAN DEFAULT TRUE NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion CHARACTER VARYING(100) DEFAULT 'SISTEMA' NOT NULL,
    fecha_modificacion TIMESTAMP WITH TIME ZONE,
    usuario_modificacion CHARACTER VARYING(100)
);

-- 2. Índice por código para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_tipos_movimiento_codigo ON inventario.tipos_movimiento(codigo);

-- 3. Carga de Datos Iniciales (Seed Data basado en Tabla 12 SUNAT + Factores Stock)
INSERT INTO inventario.tipos_movimiento (id_tipo_movimiento, codigo, nombre, factor, mueve_stock)
VALUES 
(1,  '02', 'COMPRA NACIONAL', 1, true),
(2,  '01', 'VENTA NACIONAL', -1, true),
(3,  '13', 'AJUSTE POSITIVO (SOBRANTE)', 1, true),
(4,  '14', 'AJUSTE NEGATIVO (MERMA/PERDIDA)', -1, true),
(5,  '04', 'TRANSFERENCIA ENTRE ALMACENES', 0, true), -- El factor depende de si es origen o destino en la lógica
(6,  '06', 'NC COMPRA (DEVOLUCION A PROVEEDOR)', -1, true),
(7,  '05', 'NC VENTA (DEVOLUCION DE CLIENTE)', 1, true),
(8,  '02', 'ND COMPRA (INCREMENTO COSTO/CANT)', 1, true),
(9,  '01', 'ND VENTA (INCREMENTO VENTA)', -1, true),
(10, '16', 'SALDO INICIAL', 1, true)
ON CONFLICT (id_tipo_movimiento) DO UPDATE 
SET codigo = EXCLUDED.codigo, 
    nombre = EXCLUDED.nombre, 
    factor = EXCLUDED.factor, 
    mueve_stock = EXCLUDED.mueve_stock;

-- 4. Actualización de FK en movimientos_inventario (Opcional, pero recomendado)
-- ALTER TABLE inventario.movimientos_inventario 
-- ADD CONSTRAINT fk_movimiento_tipo 
-- FOREIGN KEY (id_tipo_movimiento) 
-- REFERENCES inventario.tipos_movimiento(id_tipo_movimiento);
