DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_tipo_comprobante, codigo, nombre, mueve_stock, tipo_movimiento_stock FROM configuracion.tipo_comprobante
    ) LOOP
        RAISE NOTICE 'ID: %, Codigo: %, Nombre: %, Mueve: %, MovStock: %', r.id_tipo_comprobante, r.codigo, r.nombre, r.mueve_stock, r.tipo_movimiento_stock;
    END LOOP;
END $$;
