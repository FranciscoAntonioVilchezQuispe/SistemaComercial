DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT k.id_kardex, k.id_producto, k.cantidad, k.tipo_movimiento, k.documento_serie, k.documento_numero
        FROM inventario.kardex k
        WHERE k.documento_serie = 'FN01' AND k.documento_numero = '00000123'
    ) LOOP
        RAISE NOTICE 'Kardex ID: %, Producto: %, Cantidad: %, Tipo: %, Doc: %-%', 
                     r.id_kardex, r.id_producto, r.cantidad, r.tipo_movimiento, r.documento_serie, r.documento_numero;
    END LOOP;
END $$;
