-- SCRIPT DE CONSOLIDACIÓN DE MÉTODOS DE PAGO (FASE 10)
-- Unifica ventas.metodos_pago en configuracion.metodos_pago

DO $$ 
BEGIN
    -- 1. Asegurar que los códigos de ventas existan en configuración antes de re-mapear
    -- Mapeo: EFE -> EFECTIVO, TAR -> TARJETA, TRA -> TRANSFERENCIA, YAP -> YAPE_PLIN
    
    -- 2. Eliminar constraint antigua en ventas.pagos
    IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_pago_metodo' AND table_schema = 'ventas') THEN
        ALTER TABLE ventas.pagos DROP CONSTRAINT fk_pago_metodo;
    END IF;

    -- 3. Actualizar los IDs en ventas.pagos basados en el mapeo de códigos
    -- Primero actualizamos a los nuevos IDs del esquema configuracion
    
    UPDATE ventas.pagos p
    SET id_metodo_pago = (SELECT id_metodo_pago FROM configuracion.metodos_pago WHERE codigo = 'EFECTIVO')
    WHERE p.id_metodo_pago IN (SELECT id_metodo_pago FROM ventas.metodos_pago WHERE codigo = 'EFE');

    UPDATE ventas.pagos p
    SET id_metodo_pago = (SELECT id_metodo_pago FROM configuracion.metodos_pago WHERE codigo = 'TARJETA')
    WHERE p.id_metodo_pago IN (SELECT id_metodo_pago FROM ventas.metodos_pago WHERE codigo = 'TAR');

    UPDATE ventas.pagos p
    SET id_metodo_pago = (SELECT id_metodo_pago FROM configuracion.metodos_pago WHERE codigo = 'TRANSFERENCIA')
    WHERE p.id_metodo_pago IN (SELECT id_metodo_pago FROM ventas.metodos_pago WHERE codigo = 'TRA');

    UPDATE ventas.pagos p
    SET id_metodo_pago = (SELECT id_metodo_pago FROM configuracion.metodos_pago WHERE codigo = 'YAPE_PLIN')
    WHERE p.id_metodo_pago IN (SELECT id_metodo_pago FROM ventas.metodos_pago WHERE codigo = 'YAP');

    -- 4. Crear la nueva constraint apuntando a configuracion.metodos_pago
    ALTER TABLE ventas.pagos
    ADD CONSTRAINT fk_ventas_pagos_metodo_config 
    FOREIGN KEY (id_metodo_pago) 
    REFERENCES configuracion.metodos_pago(id_metodo_pago);

    -- 5. Eliminar la tabla redundante y su secuencia
    DROP TABLE IF EXISTS ventas.metodos_pago CASCADE;
    -- La cascada debería encargarse de la secuencia si estaba ligada, pero por seguridad:
    DROP SEQUENCE IF EXISTS ventas.metodos_pago_id_metodo_pago_seq;

END $$;
