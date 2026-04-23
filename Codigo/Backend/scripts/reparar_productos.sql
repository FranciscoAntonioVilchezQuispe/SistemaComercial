-- Reparación de integridad: productos con método de valuación nulo
UPDATE catalogo.productos 
SET metodo_valuacion = 'PP' 
WHERE metodo_valuacion IS NULL OR metodo_valuacion = '';

-- Verificación
SELECT id_producto, nombre_producto, metodo_valuacion 
FROM catalogo.productos 
WHERE metodo_valuacion IS NULL;
