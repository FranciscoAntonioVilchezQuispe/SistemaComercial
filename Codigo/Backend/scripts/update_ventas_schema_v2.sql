-- SCRIPT DE ACTUALIZACIÓN: ventas.detalle_venta
-- Objetivo: Añadir columnas de auditoría y campos SUNAT para sincronizar con DetalleVenta.cs

DO $$ 
BEGIN
    -- 1. Columnas de Auditoría (EntidadBase)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'activado') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN activado boolean DEFAULT true NOT NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'fecha_creacion') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN fecha_creacion timestamp without time zone DEFAULT now() NOT NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'usuario_creacion') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN usuario_creacion character varying(100) DEFAULT 'SYSTEM'::character varying NOT NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'fecha_modificacion') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN fecha_modificacion timestamp without time zone;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'usuario_modificacion') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN usuario_modificacion character varying(100);
    END IF;

    -- 2. Columnas Especializadas (Impuestos / SUNAT)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'codigo_afectacion_igv') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN codigo_afectacion_igv character varying(2);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'codigo_tributo') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN codigo_tributo character varying(4);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'precio_unitario_base') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN precio_unitario_base numeric(12,4);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'descuento_item') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN descuento_item numeric(12,4) DEFAULT 0 NOT NULL;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'ventas' AND table_name = 'detalle_venta' AND column_name = 'valor_item') THEN
        ALTER TABLE ventas.detalle_venta ADD COLUMN valor_item numeric(12,4);
    END IF;

END $$;

COMMENT ON COLUMN ventas.detalle_venta.codigo_afectacion_igv IS 'Código SUNAT de afectación (10, 20, 30, etc)';
COMMENT ON COLUMN ventas.detalle_venta.codigo_tributo IS 'Código SUNAT del tributo (1000 IGV, 9997 EXONERADO, etc)';
