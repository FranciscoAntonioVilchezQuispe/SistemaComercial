-- MIGRACIÓN: AGREGAR COLUMNAS DE FACTOR A TIPOS_MOVIMIENTO
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='tipos_movimiento' AND column_name='factor') THEN
        ALTER TABLE inventario.tipos_movimiento ADD COLUMN factor DECIMAL(3,2) DEFAULT 0 NOT NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='inventario' AND table_name='tipos_movimiento' AND column_name='mueve_stock') THEN
        ALTER TABLE inventario.tipos_movimiento ADD COLUMN mueve_stock BOOLEAN DEFAULT TRUE NOT NULL;
    END IF;
END $$;

-- Actualizar/Insertar datos corregidos
INSERT INTO inventario.tipos_movimiento (id_tipo_movimiento, codigo, nombre, factor, mueve_stock)
VALUES 
(1,  '02', 'COMPRA NACIONAL', 1, true),
(2,  '01', 'VENTA NACIONAL', -1, true),
(3,  '13', 'AJUSTE POSITIVO (SOBRANTE)', 1, true),
(4,  '14', 'AJUSTE NEGATIVO (MERMA/PERDIDA)', -1, true),
(5,  '04', 'TRANSFERENCIA ENTRE ALMACENES', 0, true),
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
