DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_tipo_comprobante, codigo, nombre, mueve_stock, tipo_movimiento_stock, movimiento_stock_compra, movimiento_stock_venta FROM configuracion.tipo_comprobante
    ) LOOP
        RAISE NOTICE 'ID: %, Codigo: %, Nombre: %, MovStock: %, MovCompra: %, MovVenta: %', r.id_tipo_comprobante, r.codigo, r.nombre, r.tipo_movimiento_stock, r.movimiento_stock_compra, r.movimiento_stock_venta;
    END LOOP;
END $$;
