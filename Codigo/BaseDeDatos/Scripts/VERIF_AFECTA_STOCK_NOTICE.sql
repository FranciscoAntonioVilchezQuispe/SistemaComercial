DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT id_nota, serie, numero, afecta_stock FROM compras.nota_credito WHERE id_nota = 2
    ) LOOP
        RAISE NOTICE 'Nota ID: %, Serie: %, Numero: %, Afecta Stock: %', 
                     r.id_nota, r.serie, r.numero, r.afecta_stock;
    END LOOP;
END $$;
