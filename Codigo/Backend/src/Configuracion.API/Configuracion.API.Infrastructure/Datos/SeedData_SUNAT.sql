-- SEED DATA: CATÁLOGOS SUNAT
-- Catálogo 05: Tipos de Tributos
-- Catálogo 07: Tipos de Afectación del IGV

DO $$
BEGIN
    -- 0. Asegurar restricciones de unicidad para ON CONFLICT
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_tipo_tributo_codigo') THEN
        ALTER TABLE configuracion.tipo_tributo ADD CONSTRAINT uq_tipo_tributo_codigo UNIQUE (codigo_sunat);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uq_tipo_afectacion_codigo') THEN
        -- Nota: La migración previo rename pudo haber dejado el nombre 'tipo_afectacion_igv_codigo_key'
        IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'tipo_afectacion_igv_codigo_key') THEN
            ALTER TABLE configuracion.tipo_afectacion_igv ADD CONSTRAINT uq_tipo_afectacion_codigo UNIQUE (codigo_sunat);
        END IF;
    END IF;

    -- 1. Poblar Tipos de Tributos (Catálogo 05)
    INSERT INTO configuracion.tipo_tributo (codigo_sunat, nombre, codigo_internacional, descripcion)
    VALUES 
    ('1000', 'IGV', 'VAT', 'Impuesto General a las Ventas'),
    ('2000', 'ISC', 'EXC', 'Impuesto Selectivo al Consumo'),
    ('9995', 'EXP', 'FRE', 'Exportación'),
    ('9996', 'GRA', 'FRE', 'Gratuito'),
    ('9997', 'EXO', 'VAT', 'Exonerado'),
    ('9998', 'INA', 'FRE', 'Inafecto'),
    ('1016', 'IVAP', 'VAT', 'Impuesto a la Venta de Arroz Pilado')
    ON CONFLICT (codigo_sunat) DO UPDATE SET 
        nombre = EXCLUDED.nombre,
        codigo_internacional = EXCLUDED.codigo_internacional,
        descripcion = EXCLUDED.descripcion;

    -- 2. Poblar Tipos de Afectación IGV (Catálogo 07)
    INSERT INTO configuracion.tipo_afectacion_igv (codigo_sunat, descripcion, es_gravado, es_exonerado, es_inafecto, es_gratuito, codigo_tributo_default, nombre_tributo_default)
    VALUES 
    ('10', 'Gravado - Operación Onerosa', true, false, false, false, '1000', 'IGV'),
    ('11', 'Gravado - Retiro por Premio', true, false, false, true, '1000', 'IGV'),
    ('12', 'Gravado - Retiro por Donación', true, false, false, true, '1000', 'IGV'),
    ('13', 'Gravado - Retiro', true, false, false, true, '1000', 'IGV'),
    ('14', 'Gravado - Retiro por Publicidad', true, false, false, true, '1000', 'IGV'),
    ('15', 'Gravado - Bonificaciones', true, false, false, true, '1000', 'IGV'),
    ('16', 'Gravado - Retiro por Entrega a Trabajadores', true, false, false, true, '1000', 'IGV'),
    ('17', 'Gravado - IVAP', true, false, false, false, '1016', 'IVAP'),
    ('20', 'Exonerado - Operación Onerosa', false, true, false, false, '9997', 'EXO'),
    ('21', 'Exonerado - Transferencia Gratuita', false, true, false, true, '9997', 'EXO'),
    ('30', 'Inafecto - Operación Onerosa', false, false, true, false, '9998', 'INA'),
    ('31', 'Inafecto - Retiro por Bonificación', false, false, true, true, '9998', 'INA'),
    ('32', 'Inafecto - Retiro', false, false, true, true, '9998', 'INA'),
    ('33', 'Inafecto - Retiro por Muestras Médicas', false, false, true, true, '9998', 'INA'),
    ('34', 'Inafecto - Transferencia Gratuita', false, false, true, true, '9998', 'INA'),
    ('35', 'Inafecto - Retiro por Publicidad', false, false, true, true, '9998', 'INA'),
    ('36', 'Inafecto - Bonificaciones', false, false, true, true, '9998', 'INA'),
    ('37', 'Inafecto - Retiro por Entrega a Trabajadores', false, false, true, true, '9998', 'INA'),
    ('40', 'Exportación de Bienes o Servicios', false, false, false, false, '9995', 'EXP')
    ON CONFLICT (codigo_sunat) DO UPDATE SET 
        descripcion = EXCLUDED.descripcion,
        es_gravado = EXCLUDED.es_gravado,
        es_exonerado = EXCLUDED.es_exonerado,
        es_inafecto = EXCLUDED.es_inafecto,
        es_gratuito = EXCLUDED.es_gratuito,
        codigo_tributo_default = EXCLUDED.codigo_tributo_default,
        nombre_tributo_default = EXCLUDED.nombre_tributo_default;

END $$;
