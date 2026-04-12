DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT k.id, k.producto_id, k.salida_cantidad, k.serie_documento, k.numero_documento
        FROM inventario.inv_kardex_movimiento k
        WHERE k.serie_documento = 'FN01' AND k.numero_documento = '00000123'
    ) LOOP
        RAISE NOTICE 'Kardex ID: %, Producto: %, Salida: %, Doc: %-%', 
                     r.id, r.producto_id, r.salida_cantidad, r.serie_documento, r.numero_documento;
    END LOOP;
END $$;
