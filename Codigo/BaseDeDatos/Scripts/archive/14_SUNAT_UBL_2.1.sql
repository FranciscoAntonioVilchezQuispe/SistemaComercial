-- =========================================================================
-- SCRIPT DE ACTUALIZACIÓN: SUNAT UBL 2.1 (MÓDULO DE VENTAS)
-- Fecha: 2026-03-30
-- Descripción: Creación de esquemas, tablas de soporte y adición de campos
--              para cumplir con los requerimientos de facturación electrónica.
-- =========================================================================

DO $$ 
BEGIN

    -- 1. CREAR SCHEMA SUNAT
    CREATE SCHEMA IF NOT EXISTS sunat;

    -- 2. CREAR TABLA CAT_ESTADO_CPE
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'sunat' AND table_name = 'cat_estado_cpe') THEN
        CREATE TABLE sunat.cat_estado_cpe (
            id_estado VARCHAR(20) PRIMARY KEY,
            descripcion VARCHAR(100) NOT NULL,
            es_final BOOLEAN DEFAULT false NOT NULL,
            permite_reenvio BOOLEAN DEFAULT false NOT NULL,
            -- Auditoría obligatoria
            activado BOOLEAN DEFAULT true NOT NULL,
            fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
            usuario_creacion VARCHAR(50) DEFAULT 'sistema' NOT NULL,
            fecha_modificacion TIMESTAMP WITH TIME ZONE,
            usuario_modificacion VARCHAR(50)
        );

        INSERT INTO sunat.cat_estado_cpe (id_estado, descripcion, es_final, permite_reenvio) VALUES
        ('PENDIENTE', 'Pendiente de envío a SUNAT', false, true),
        ('ENVIADO', 'Enviado a SUNAT, esperando respuesta (Ticket)', false, false),
        ('ACEPTADO', 'Aceptado por SUNAT sin observaciones', true, false),
        ('ACEPTADO_OBS', 'Aceptado por SUNAT con observaciones', true, false),
        ('RECHAZADO', 'Rechazado por SUNAT (Error concurrente)', true, true),
        ('ANULADO', 'Comunicación de baja aceptada', true, false),
        ('ERROR', 'Error interno o de comunicación', false, true);
    END IF;

    -- 3. CREAR TABLA LOG_ENVIO_CPE
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'sunat' AND table_name = 'log_envio_cpe') THEN
        CREATE TABLE sunat.log_envio_cpe (
            id_log BIGSERIAL PRIMARY KEY,
            id_venta BIGINT REFERENCES ventas.ventas(id_venta),
            id_nota_credito BIGINT REFERENCES ventas.nota_credito(id_nota),
            id_nota_debito BIGINT REFERENCES ventas.nota_debito(id_nota),
            tipo_documento VARCHAR(10) NOT NULL,
            fecha_envio TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
            xml_enviado TEXT,
            xml_respuesta TEXT,
            codigo_respuesta VARCHAR(50),
            mensaje_respuesta TEXT,
            ticket VARCHAR(100),
            id_estado_cpe VARCHAR(20) REFERENCES sunat.cat_estado_cpe(id_estado),
            exito BOOLEAN DEFAULT false NOT NULL,
            -- Auditoría obligatoria
            activado BOOLEAN DEFAULT true NOT NULL,
            fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
            usuario_creacion VARCHAR(50) DEFAULT 'sistema' NOT NULL,
            fecha_modificacion TIMESTAMP WITH TIME ZONE,
            usuario_modificacion VARCHAR(50),
            
            CONSTRAINT chk_log_envio_unico_doc CHECK (
                (id_venta IS NOT NULL AND id_nota_credito IS NULL AND id_nota_debito IS NULL) OR
                (id_venta IS NULL AND id_nota_credito IS NOT NULL AND id_nota_debito IS NULL) OR
                (id_venta IS NULL AND id_nota_credito IS NULL AND id_nota_debito IS NOT NULL)
            ),
            CONSTRAINT chk_tipo_doc_log CHECK (tipo_documento IN ('VENTA','NC','ND'))
        );
    END IF;

    -- 4. CREAR TABLA VENTA_CUOTA_PAGO
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'ventas' AND table_name = 'venta_cuota_pago') THEN
        CREATE TABLE ventas.venta_cuota_pago (
            id_cuota BIGSERIAL PRIMARY KEY,
            id_venta BIGINT NOT NULL REFERENCES ventas.ventas(id_venta),
            numero_cuota INT NOT NULL,
            monto_cuota NUMERIC(18,2) NOT NULL,
            fecha_vencimiento DATE NOT NULL,
            fecha_pago DATE,
            pagado BOOLEAN DEFAULT false NOT NULL,
            -- Auditoría obligatoria
            activado BOOLEAN DEFAULT true NOT NULL,
            fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc', now()) NOT NULL,
            usuario_creacion VARCHAR(50) DEFAULT 'sistema' NOT NULL,
            fecha_modificacion TIMESTAMP WITH TIME ZONE,
            usuario_modificacion VARCHAR(50)
        );
    END IF;

    -- 5. INSERT REGIStros faltantes en CONFIGURACION.IMPUESTOS
    IF NOT EXISTS (SELECT 1 FROM configuracion.impuestos WHERE codigo_sunat = '9995') THEN
        INSERT INTO configuracion.impuestos (id_impuesto, codigo_sunat, nombre, porcentaje, es_porcentaje, usuario_creacion) 
        VALUES ((SELECT COALESCE(MAX(id_impuesto), 0) + 1 FROM configuracion.impuestos), '9995', 'EXPORTACION', 0.00, true, 'sistema');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM configuracion.impuestos WHERE codigo_sunat = '9999') THEN
        INSERT INTO configuracion.impuestos (id_impuesto, codigo_sunat, nombre, porcentaje, es_porcentaje, usuario_creacion) 
        VALUES ((SELECT COALESCE(MAX(id_impuesto), 0) + 1 FROM configuracion.impuestos), '9999', 'GRATUITA', 0.00, true, 'sistema');
    END IF;

    -- 6. INSERT registros faltantes en CATALOGO.UNIDADES_MEDIDA
    IF NOT EXISTS (SELECT 1 FROM catalogo.unidades_medida WHERE codigo_sunat = 'ZZ') THEN
        INSERT INTO catalogo.unidades_medida (nombre_unidad, simbolo, codigo_sunat, usuario_creacion) VALUES ('Servicio', 'SRV', 'ZZ', 'sistema');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM catalogo.unidades_medida WHERE codigo_sunat = 'MTQ') THEN
        INSERT INTO catalogo.unidades_medida (nombre_unidad, simbolo, codigo_sunat, usuario_creacion) VALUES ('Metro Cúbico', 'm3', 'MTQ', 'sistema');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM catalogo.unidades_medida WHERE codigo_sunat = 'DZN') THEN
        INSERT INTO catalogo.unidades_medida (nombre_unidad, simbolo, codigo_sunat, usuario_creacion) VALUES ('Docena', 'DOC', 'DZN', 'sistema');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM catalogo.unidades_medida WHERE codigo_sunat = 'SET') THEN
        INSERT INTO catalogo.unidades_medida (nombre_unidad, simbolo, codigo_sunat, usuario_creacion) VALUES ('Juego', 'JGO', 'SET', 'sistema');
    END IF;

    -- 7. ALTER TABLAS - VENTAS
    -- Ventas
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS id_tipo_operacion BIGINT; -- References configuracion.tipo_operacion_sunat
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS forma_pago VARCHAR(20) DEFAULT 'Contado';
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS total_descuento_item NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS total_gratuito NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS subtotal_exonerado NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS subtotal_inafecto NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS hash_cpe TEXT;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS hash_cdr TEXT;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS descripcion_cdr TEXT;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS fecha_envio_sunat TIMESTAMP WITH TIME ZONE;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS numero_ticket_sunat VARCHAR(100);
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS orden_compra_referencia VARCHAR(50);
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS xml_generado TEXT;
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS id_estado_cpe VARCHAR(20) REFERENCES sunat.cat_estado_cpe(id_estado);
    ALTER TABLE ventas.ventas ADD COLUMN IF NOT EXISTS id_empresa BIGINT; -- Placeholder para futura multiempresa
    
    -- FK for tipo operacion (using block so if constraint exists it ignores it)
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_ventas_tipo_operacion') THEN
        ALTER TABLE ventas.ventas ADD CONSTRAINT fk_ventas_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);
    END IF;

    -- Detalle Ventas
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS id_unidad_medida BIGINT;
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS numero_linea INT;
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS codigo_producto_sunat VARCHAR(20);
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS codigo_producto_vendedor VARCHAR(50);
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS id_afectacion_igv BIGINT;
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS id_tributo BIGINT;
    ALTER TABLE ventas.detalle_venta ADD COLUMN IF NOT EXISTS descuento_item NUMERIC(18,2) DEFAULT 0;

    -- FKs para Detalle Ventas
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_detalle_venta_unidad_medida') THEN
        ALTER TABLE ventas.detalle_venta ADD CONSTRAINT fk_detalle_venta_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_detalle_venta_afectacion_igv') THEN
        ALTER TABLE ventas.detalle_venta ADD CONSTRAINT fk_detalle_venta_afectacion_igv FOREIGN KEY (id_afectacion_igv) REFERENCES configuracion.tipo_afectacion_igv(id_afectacion);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_detalle_venta_tributo') THEN
        ALTER TABLE ventas.detalle_venta ADD CONSTRAINT fk_detalle_venta_tributo FOREIGN KEY (id_tributo) REFERENCES configuracion.impuestos(id_impuesto);
    END IF;

    -- 8. CONFIGURACION - FK en afectacion IGV e identificadores en operacion sunat
    ALTER TABLE configuracion.tipo_afectacion_igv ADD COLUMN IF NOT EXISTS id_impuesto BIGINT;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_afectacion_igv_impuesto') THEN
        ALTER TABLE configuracion.tipo_afectacion_igv ADD CONSTRAINT fk_afectacion_igv_impuesto FOREIGN KEY (id_impuesto) REFERENCES configuracion.impuestos(id_impuesto);
    END IF;

    ALTER TABLE configuracion.tipo_operacion_sunat ADD COLUMN IF NOT EXISTS aplica_factura BOOLEAN DEFAULT true;
    ALTER TABLE configuracion.tipo_operacion_sunat ADD COLUMN IF NOT EXISTS aplica_boleta BOOLEAN DEFAULT true;
    ALTER TABLE configuracion.tipo_operacion_sunat ADD COLUMN IF NOT EXISTS aplica_nota_credito BOOLEAN DEFAULT false;
    ALTER TABLE configuracion.tipo_operacion_sunat ADD COLUMN IF NOT EXISTS aplica_nota_debito BOOLEAN DEFAULT false;

    -- 9. NOTAS DE CREDITO Y DEBITO
    -- NC
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS id_tipo_operacion BIGINT;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS hash_cpe TEXT;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS subtotal_gravado NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS subtotal_exonerado NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS subtotal_inafecto NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS id_empresa BIGINT;
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS numero_ticket_sunat VARCHAR(100);
    ALTER TABLE ventas.nota_credito ADD COLUMN IF NOT EXISTS id_estado_cpe VARCHAR(20) REFERENCES sunat.cat_estado_cpe(id_estado);
    
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nc_tipo_operacion') THEN
        ALTER TABLE ventas.nota_credito ADD CONSTRAINT fk_nc_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nc_tipo_nota') THEN
        ALTER TABLE ventas.nota_credito ADD CONSTRAINT fk_nc_tipo_nota FOREIGN KEY (id_tipo_nota) REFERENCES configuracion.motivo_nota_credito(id_motivo);
    END IF;

    -- NC Detalle
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS id_afectacion_igv BIGINT;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS id_tributo BIGINT;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS precio_unitario_base NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS valor_item NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS descuento_item NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS porcentaje_impuesto NUMERIC(5,2) DEFAULT 18.00;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS numero_linea INT;
    ALTER TABLE ventas.nota_credito_detalle ADD COLUMN IF NOT EXISTS id_unidad_medida BIGINT;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nc_detalle_unidad_medida') THEN
        ALTER TABLE ventas.nota_credito_detalle ADD CONSTRAINT fk_nc_detalle_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);
    END IF;

    -- ND
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS id_tipo_operacion BIGINT;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS hash_cpe TEXT;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS subtotal_gravado NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS subtotal_exonerado NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS subtotal_inafecto NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS id_empresa BIGINT;
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS numero_ticket_sunat VARCHAR(100);
    ALTER TABLE ventas.nota_debito ADD COLUMN IF NOT EXISTS id_estado_cpe VARCHAR(20) REFERENCES sunat.cat_estado_cpe(id_estado);

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nd_tipo_operacion') THEN
        ALTER TABLE ventas.nota_debito ADD CONSTRAINT fk_nd_tipo_operacion FOREIGN KEY (id_tipo_operacion) REFERENCES configuracion.tipo_operacion_sunat(id_tipo_operacion);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nd_tipo_nota') THEN
        ALTER TABLE ventas.nota_debito ADD CONSTRAINT fk_nd_tipo_nota FOREIGN KEY (id_tipo_nota) REFERENCES configuracion.motivo_nota_debito(id_motivo);
    END IF;

    -- ND Detalle
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS id_afectacion_igv BIGINT;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS id_tributo BIGINT;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS precio_unitario_base NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS valor_item NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS descuento_item NUMERIC(18,2) DEFAULT 0;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS porcentaje_impuesto NUMERIC(5,2) DEFAULT 18.00;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS numero_linea INT;
    ALTER TABLE ventas.nota_debito_detalle ADD COLUMN IF NOT EXISTS id_unidad_medida BIGINT;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_nd_detalle_unidad_medida') THEN
        ALTER TABLE ventas.nota_debito_detalle ADD CONSTRAINT fk_nd_detalle_unidad_medida FOREIGN KEY (id_unidad_medida) REFERENCES catalogo.unidades_medida(id_unidad);
    END IF;

    -- Migrar subtotal a subtotal_gravado asumiendo que historicamente todo ha sido gravado
    UPDATE ventas.nota_credito SET subtotal_gravado = subtotal WHERE subtotal_gravado = 0 AND subtotal > 0;
    UPDATE ventas.nota_debito SET subtotal_gravado = subtotal WHERE subtotal_gravado = 0 AND subtotal > 0;

    -- Estandarización de hash_cdr (borrar el actual y recrear si alguien creo codigo_hash_cdr)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'ventas' AND column_name = 'codigo_hash_cdr') THEN
        ALTER TABLE ventas.ventas RENAME COLUMN codigo_hash_cdr TO hash_cdr;
    END IF;

END $$;
