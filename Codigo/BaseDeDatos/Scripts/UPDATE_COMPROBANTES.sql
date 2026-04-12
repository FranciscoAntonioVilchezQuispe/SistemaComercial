UPDATE configuracion.tipo_comprobante
SET tipo_movimiento_stock = 'DEPENDIENTE',
    movimiento_stock_compra = 'ENTRADA',
    movimiento_stock_venta = 'SALIDA'
WHERE codigo IN ('01', '03');
