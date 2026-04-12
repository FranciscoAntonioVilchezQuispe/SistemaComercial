UPDATE inventario.stock SET cantidad_actual = (
    SELECT COALESCE(SUM(entrada_cantidad), 0) - COALESCE(SUM(salida_cantidad), 0)
    FROM inventario.inv_kardex_movimiento
    WHERE producto_id = inventario.stock.id_producto
    AND almacen_id = inventario.stock.id_almacen
    AND anulado = false
);
