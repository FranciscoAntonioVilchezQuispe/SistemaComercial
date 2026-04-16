DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT t.id_tipo_comprobante as id, t.codigo, t.nombre
        FROM configuracion.tipo_comprobante t
        WHERE t.codigo IN ('07', '08')
    ) LOOP
        RAISE NOTICE 'Doc ID: %, Codigo: %, Nombre: %', r.id, r.codigo, r.nombre;
    END LOOP;
END $$;
