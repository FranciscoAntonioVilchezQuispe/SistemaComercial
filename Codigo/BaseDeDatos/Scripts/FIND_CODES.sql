DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_tipo_movimiento, codigo, nombre FROM inventario.tipos_movimiento WHERE id_tipo_movimiento IN (24, 25, 26, 27)
    ) LOOP
        RAISE NOTICE 'ID: %, Codigo: %, Nombre: %', r.id_tipo_movimiento, r.codigo, r.nombre;
    END LOOP;
END $$;
