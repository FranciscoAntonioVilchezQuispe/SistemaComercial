DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT m.id, m.id_producto, m.cantidad, m.serie_documento, m.numero_documento
        FROM inventario.movimientos_inventario m
        WHERE m.serie_documento = 'FN01' AND m.numero_documento = '00000123'
    ) LOOP
        RAISE NOTICE 'Movimiento ID: %, Producto: %, Cantidad: %, Doc: %-%', 
                     r.id, r.id_producto, r.cantidad, r.serie_documento, r.numero_documento;
    END LOOP;
END $$;
