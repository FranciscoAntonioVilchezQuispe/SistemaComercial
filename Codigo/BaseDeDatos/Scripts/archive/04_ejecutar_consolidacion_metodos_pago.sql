-- SCRIPT UNIFICADO: Insertar datos semilla + Consolidar Métodos de Pago
-- Orden: 1) Seed en configuracion.metodos_pago, 2) Migrar FK de ventas.pagos, 3) DROP ventas.metodos_pago

-- 1. Insertar datos semilla en configuracion.metodos_pago (tabla ya creada por EF Core migration)
INSERT INTO configuracion.metodos_pago (codigo, nombre, es_efectivo, activado, fecha_creacion, usuario_creacion)
VALUES 
('EFECTIVO', 'Pago en Efectivo', TRUE, TRUE, NOW(), 'SISTEMA'),
('TARJETA', 'Tarjeta de Débito/Crédito', FALSE, TRUE, NOW(), 'SISTEMA'),
('TRANSFERENCIA', 'Transferencia Bancaria', FALSE, TRUE, NOW(), 'SISTEMA'),
('YAPE_PLIN', 'Billetera Digital (Yape/Plin)', FALSE, TRUE, NOW(), 'SISTEMA')
ON CONFLICT DO NOTHING;

-- 2. Migrar las FK de ventas.pagos al nuevo esquema
DO $$ 
BEGIN
    -- Verificar si la tabla legacy existe antes de hacer cualquier cosa
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'ventas' AND table_name = 'metodos_pago') THEN

        -- Eliminar constraint antigua si existe
        IF EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_pago_metodo' AND table_schema = 'ventas') THEN
            ALTER TABLE ventas.pagos DROP CONSTRAINT fk_pago_metodo;
        END IF;

        -- Actualizar IDs en ventas.pagos basados en mapeo de códigos
        UPDATE ventas.pagos p
        SET id_metodo_pago = cm.id_metodo_pago
        FROM ventas.metodos_pago vm
        INNER JOIN configuracion.metodos_pago cm ON (
            (vm.codigo = 'EFE' AND cm.codigo = 'EFECTIVO') OR
            (vm.codigo = 'TAR' AND cm.codigo = 'TARJETA') OR
            (vm.codigo = 'TRA' AND cm.codigo = 'TRANSFERENCIA') OR
            (vm.codigo = 'YAP' AND cm.codigo = 'YAPE_PLIN')
        )
        WHERE p.id_metodo_pago = vm.id_metodo_pago;

        -- Crear nueva constraint apuntando a configuracion
        ALTER TABLE ventas.pagos
        ADD CONSTRAINT fk_ventas_pagos_metodo_config 
        FOREIGN KEY (id_metodo_pago) 
        REFERENCES configuracion.metodos_pago(id_metodo_pago);

        -- Eliminar tabla redundante
        DROP TABLE ventas.metodos_pago CASCADE;

        RAISE NOTICE '✅ Consolidación completada: ventas.metodos_pago eliminada, FK actualizada.';
    ELSE
        RAISE NOTICE 'ℹ️ ventas.metodos_pago no existe, solo se aplicó seed data.';
    END IF;

    -- Verificar si falta la FK (caso donde ventas.metodos_pago ya fue eliminada previamente)
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_ventas_pagos_metodo_config' AND table_schema = 'ventas') THEN
        -- Solo agregar si la tabla pagos existe y tiene la columna
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'pagos' AND column_name = 'id_metodo_pago') THEN
            ALTER TABLE ventas.pagos
            ADD CONSTRAINT fk_ventas_pagos_metodo_config 
            FOREIGN KEY (id_metodo_pago) 
            REFERENCES configuracion.metodos_pago(id_metodo_pago);
            RAISE NOTICE '✅ FK fk_ventas_pagos_metodo_config creada.';
        END IF;
    END IF;
END $$;
