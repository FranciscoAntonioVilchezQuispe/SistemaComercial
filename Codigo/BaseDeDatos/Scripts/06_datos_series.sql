-- ==============================================================================
-- SCRIPT: INSERCIÓN DE SERIES DE COMPROBANTES INICIALES
-- Descripción: Registra las series F001, B001, FC01 y FD01 para el Almacén Central.
-- ==============================================================================

INSERT INTO configuracion.series_comprobantes 
(id_tipo_comprobante, serie, correlativo_actual, id_almacen, activado, usuario_creacion, fecha_creacion)
VALUES 
  -- Factura Electrónica (F001)
  ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '01' LIMIT 1), 
   'F001', 0, (SELECT id_almacen FROM inventario.almacenes WHERE nombre_almacen = 'ALMACEN CENTRAL' LIMIT 1), 
   true, 'SYSTEM', NOW()),
  
  -- Boleta de Venta Electrónica (B001)
  ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '03' LIMIT 1), 
   'B001', 0, (SELECT id_almacen FROM inventario.almacenes WHERE nombre_almacen = 'ALMACEN CENTRAL' LIMIT 1), 
   true, 'SYSTEM', NOW()),
  
  -- Nota de Crédito para Factura (FC01)
  ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '07' LIMIT 1), 
   'FC01', 0, (SELECT id_almacen FROM inventario.almacenes WHERE nombre_almacen = 'ALMACEN CENTRAL' LIMIT 1), 
   true, 'SYSTEM', NOW()),
   
  -- Nota de Débito para Factura (FD01)
  ((SELECT id_tipo_comprobante FROM configuracion.tipo_comprobante WHERE codigo = '08' LIMIT 1), 
   'FD01', 0, (SELECT id_almacen FROM inventario.almacenes WHERE nombre_almacen = 'ALMACEN CENTRAL' LIMIT 1), 
   true, 'SYSTEM', NOW())
ON CONFLICT DO NOTHING;

-- Verificación de los datos insertados
SELECT 
    s.id_serie, 
    t.nombre as tipo_comprobante, 
    s.serie, 
    s.correlativo_actual, 
    a.nombre_almacen
FROM configuracion.series_comprobantes s
JOIN configuracion.tipo_comprobante t ON s.id_tipo_comprobante = t.id_tipo_comprobante
LEFT JOIN inventario.almacenes a ON s.id_almacen = a.id_almacen
ORDER BY t.codigo, s.serie;
