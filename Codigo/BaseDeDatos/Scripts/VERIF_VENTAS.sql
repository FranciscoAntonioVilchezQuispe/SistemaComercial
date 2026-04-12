DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_venta, serie, numero, fecha_emision FROM ventas.ventas
    ) LOOP
        RAISE NOTICE 'Venta ID: %, Serie: %-%', r.id_venta, r.serie, r.numero;
    END LOOP;
END $$;
