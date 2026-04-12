DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT n.id_nota, n.serie, n.numero, n.tipo_comprobante, n.id_compra_referencia, n.total, 
               (SELECT count(*) FROM compras.nota_credito_detalle d WHERE d.id_nota_credito = n.id_nota) as cantidad_detalles 
        FROM compras.nota_credito n 
        ORDER BY n.fecha_creacion DESC 
        LIMIT 1
    ) LOOP
        RAISE NOTICE 'Nota ID: %, Serie: %, Numero: %, Total: %, Detalles: %', 
                     r.id_nota, r.serie, r.numero, r.total, r.cantidad_detalles;
    END LOOP;
END $$;
