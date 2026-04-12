DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT m.id_movimiento, m.id_stock, m.cantidad, m.serie_documento, m.numero_documento
        FROM inventario.movimientos_inventario m
        WHERE m.serie_documento = 'FN01' AND m.numero_documento = '00000123'
    ) LOOP
        RAISE NOTICE 'Movimiento ID: %, Stock ID: %, Cantidad: %, Doc: %-%', 
                     r.id_movimiento, r.id_stock, r.cantidad, r.serie_documento, r.numero_documento;
    END LOOP;
END $$;
