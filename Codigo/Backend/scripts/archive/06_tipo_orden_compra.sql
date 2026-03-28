-- ==============================================================================
-- SCRIPT: AGREGAR TIPO DE COMPROBANTE Y SERIE PARA ORDEN DE COMPRA
-- Descripción: Registra el código '99' y la serie OC01 para Órdenes de Compra.
-- ==============================================================================

-- 1. Insertar el tipo de comprobante
INSERT INTO configuracion.tipo_comprobante 
  (codigo, nombre, mueve_stock, tipo_movimiento_stock, movimiento_stock_venta, movimiento_stock_compra,
   es_venta, es_compra, es_orden_compra, es_emitible, es_referenciable,
   activado, fecha_creacion, usuario_creacion)
VALUES 
  ('99', 'ORDEN DE COMPRA', false, 'NEUTRO', 'NEUTRO', 'NEUTRO', 
   false, false, true, true, true, 
   true, NOW(), 'SYSTEM')
ON CONFLICT (codigo) DO NOTHING;

-- 2. Insertar la serie vinculada (usando subconsulta para el ID)
INSERT INTO configuracion.series_comprobantes 
(id_tipo_comprobante, serie, correlativo_actual, id_almacen, activado, usuario_creacion, fecha_creacion)
VALUES 
  ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '99' LIMIT 1), 
   'OC01', 0, (SELECT id_almacen FROM inventario.almacenes WHERE nombre_almacen = 'ALMACEN CENTRAL' LIMIT 1), 
   true, 'SYSTEM', NOW())
ON CONFLICT DO NOTHING;

-- 3. Verificación final
SELECT 
    t.id_tipo_comprobante, 
    t.codigo, 
    t.nombre, 
    s.id_serie, 
    s.serie, 
    s.correlativo_actual
FROM configuracion.tipo_comprobante t
JOIN configuracion.series_comprobantes s ON t.id_tipo_comprobante = s.id_tipo_comprobante
WHERE t.codigo = '99';
