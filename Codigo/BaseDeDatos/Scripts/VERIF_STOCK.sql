DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_stock, id_producto, cantidad_actual, cantidad_reservada FROM inventario.stock
    ) LOOP
        RAISE NOTICE 'Stock ID: %, Prod: %, Cant: %, Resv: %', r.id_stock, r.id_producto, r.cantidad_actual, r.cantidad_reservada;
    END LOOP;
END $$;
