-- CORRECCIÓN DE IDs PARA COINCIDIR CON EL ENUM TipoMovimientoInventario
-- Primero limpiamos para evitar conflictos
DELETE FROM inventario.tipos_movimiento WHERE id_tipo_movimiento BETWEEN 1 AND 10;

-- Insertamos con los IDs correctos del Enum
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
(27, '01', 'ND VENTA (INCREMENTO VENTA)', -1, true)
ON CONFLICT (id_tipo_movimiento) DO UPDATE 
SET codigo = EXCLUDED.codigo, 
    nombre = EXCLUDED.nombre, 
    factor = EXCLUDED.factor, 
    mueve_stock = EXCLUDED.mueve_stock;
