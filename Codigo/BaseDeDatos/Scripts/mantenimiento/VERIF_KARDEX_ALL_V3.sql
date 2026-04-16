DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id, fecha_movimiento, tipo_documento, serie_documento, numero_documento, tipo_operacion, entrada_cantidad, salida_cantidad, producto_id
        FROM inventario.inv_kardex_movimiento
    ) LOOP
        RAISE NOTICE 'KD_ID: %, Fec: %, Doc: %-%-% (%), Ent: %, Sal: %, Prod: %', 
                     r.id, r.fecha_movimiento, r.tipo_documento, r.serie_documento, r.numero_documento, r.tipo_operacion, r.entrada_cantidad, r.salida_cantidad, r.producto_id;
    END LOOP;
END $$;
