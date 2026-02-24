-- Fecha de vencimiento para control de cuentas por pagar
ALTER TABLE compras.compras
  ADD COLUMN fecha_vencimiento date
    COLLATE pg_catalog."default";
COMMENT ON COLUMN compras.compras.fecha_vencimiento IS 'Fecha de vencimiento para pago. Requerida para control de CxP.';

-- Desglose de bases imponibles para Registro de Compras SUNAT
ALTER TABLE compras.compras
  ADD COLUMN base_gravada numeric(12,2) NOT NULL DEFAULT 0.00;
COMMENT ON COLUMN compras.compras.base_gravada IS 'Suma de subtotales de items con afectacion G (gravados)';

ALTER TABLE compras.compras
  ADD COLUMN base_exonerada numeric(12,2) NOT NULL DEFAULT 0.00;
COMMENT ON COLUMN compras.compras.base_exonerada IS 'Suma de subtotales de items con afectacion E (exonerados)';

ALTER TABLE compras.compras
  ADD COLUMN base_inafecta numeric(12,2) NOT NULL DEFAULT 0.00;
COMMENT ON COLUMN compras.compras.base_inafecta IS 'Suma de subtotales de items con afectacion I (inafectos)';


-- Tipo de afectacion IGV por item, requerido para Registro de Compras SUNAT
-- G = Gravado con IGV
-- E = Exonerado de IGV
-- I = Inafecto al IGV
ALTER TABLE compras.detalle_compra
  ADD COLUMN afectacion_igv character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'G';
COMMENT ON COLUMN compras.detalle_compra.afectacion_igv IS 'Afectacion IGV del item: G=Gravado, E=Exonerado, I=Inafecto. SUNAT PLE 8.1';

-- Constraint de validacion
ALTER TABLE compras.detalle_compra
  ADD CONSTRAINT chk_afectacion_igv CHECK (afectacion_igv::text = ANY (ARRAY['G'::character varying, 'E'::character varying, 'I'::character varying]::text[]));
