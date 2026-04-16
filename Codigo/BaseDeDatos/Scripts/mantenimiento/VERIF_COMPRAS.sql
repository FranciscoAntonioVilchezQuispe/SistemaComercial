DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_compra, serie_comprobante, numero_comprobante, fecha_emision FROM compras.compras
    ) LOOP
        RAISE NOTICE 'Compra ID: %, Doc: %-%', r.id_compra, r.serie_comprobante, r.numero_comprobante;
    END LOOP;
END $$;
