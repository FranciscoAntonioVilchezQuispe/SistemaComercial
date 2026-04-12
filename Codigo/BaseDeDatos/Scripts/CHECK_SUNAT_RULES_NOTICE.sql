DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT r.motivo_sunat as op, t.codigo as doc, r.nivel_relacion as niv
        FROM configuracion.matriz_regla_sunat r
        JOIN configuracion.tipo_comprobante t ON r.id_tipo_comprobante = t.id_tipo_comprobante
        WHERE t.codigo IN ('01', '07', '08')
    ) LOOP
        RAISE NOTICE 'Op: %, Doc: %, Nivel: %', r.op, r.doc, r.niv;
    END LOOP;
END $$;
