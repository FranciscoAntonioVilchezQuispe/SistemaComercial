-- Añadir campo 'activado' a tabla 'sucursales'
ALTER TABLE configuracion.sucursal
    ADD COLUMN activado boolean NOT NULL DEFAULT true;

COMMENT ON COLUMN configuracion.sucursal.activado IS 'Indica si la sucursal está activa para su uso en operaciones del sistema. Agregado durante unificación del backend con Patrón B del Frontend.';
