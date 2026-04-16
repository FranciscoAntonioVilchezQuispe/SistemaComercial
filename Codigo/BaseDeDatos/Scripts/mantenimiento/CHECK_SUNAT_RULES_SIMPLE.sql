DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT r.motivo_sunat, t.codigo, r.nivel_relacion 
        FROM configuracion.matriz_regla_sunat r
        JOIN configuracion.tipo_comprobante t ON r.id_tipo_comprobante = t.id_tipo_comprobante
        WHERE t.codigo IN ('01', '03', '07', '08')
    ) LOOP
        RAISE NOTICE 'Op: %, Doc: %, Nivel: %', r.motivo_sunat, r.codigo, r.nivel_relacion;
    END LOOP;
END $$;
