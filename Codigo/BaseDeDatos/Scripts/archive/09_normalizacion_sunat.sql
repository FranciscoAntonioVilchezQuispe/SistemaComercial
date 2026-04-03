/*
==============================================================================
08_NORMALIZACION_SUNAT.SQL
Descripción: Agrega campos obligatorios UBL 2.1 a Clientes y Proveedores.
Fecha: 2026-03-27
==============================================================================
*/

-- 1. TABLA: compras.proveedores
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS ubigeo VARCHAR(6);
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS condicion_sunat VARCHAR(50);
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS estado_sunat VARCHAR(50);
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS es_agente_retencion BOOLEAN DEFAULT FALSE;
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS es_buen_contribuyente BOOLEAN DEFAULT FALSE;
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS es_agente_percepcion BOOLEAN DEFAULT FALSE;
ALTER TABLE compras.proveedores ADD COLUMN IF NOT EXISTS fecha_ultima_consulta_sunat TIMESTAMP;

-- 2. TABLA: ventas.clientes
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS ubigeo VARCHAR(6);
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS condicion_sunat VARCHAR(50);
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS estado_sunat VARCHAR(50);
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS es_agente_retencion BOOLEAN DEFAULT FALSE;
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS es_buen_contribuyente BOOLEAN DEFAULT FALSE;
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS es_agente_percepcion BOOLEAN DEFAULT FALSE;
ALTER TABLE ventas.clientes ADD COLUMN IF NOT EXISTS fecha_ultima_consulta_sunat TIMESTAMP;

-- 3. REGISTRO DE MIGRACION PARA EF CORE (Evita errores de desincronización)
-- Sincronización para Compras.API
INSERT INTO compras."__ef_migrations_history" (migration_id, product_version) 
VALUES ('20260327220128_AddSunatFieldsAndResetSequence', '8.0.8') 
ON CONFLICT DO NOTHING;

-- Sincronización para Clientes.API
INSERT INTO ventas."__ef_migrations_history" (migration_id, product_version) 
VALUES ('20260327223412_AddSunatFieldsToCliente', '8.0.8') 
ON CONFLICT DO NOTHING;
