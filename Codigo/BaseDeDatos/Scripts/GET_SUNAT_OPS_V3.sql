DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_tipo_operacion, codigo, nombre FROM configuracion.tipo_operacion_sunat WHERE activado = true
    ) LOOP
        RAISE NOTICE 'ID: %, Codigo: %, Nombre: %', r.id_tipo_operacion, r.codigo, r.nombre;
    END LOOP;
END $$;
