DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT motivo_sunat, nivel_relacion 
        FROM configuracion.matriz_regla_sunat 
        WHERE id_tipo_comprobante IN (5, 6)
    ) LOOP
        RAISE NOTICE 'Motivo: %, Nivel: %', r.motivo_sunat, r.nivel_relacion;
    END LOOP;
END $$;
