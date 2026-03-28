/*
==============================================================================
SCRIPT: SINCRONIZACIÓN DE HISTORIAL DE MIGRACIONES (BASELINE) - V2 (SNAKE_CASE)
==============================================================================
*/

-- Sincronización para Configuracion.API
INSERT INTO public."__EFMigrationsHistory" ("migration_id", "product_version")
VALUES ('20260316050725_UpdateSunatFields', '8.0.0')
ON CONFLICT DO NOTHING;

-- Sincronización para Ventas.API
INSERT INTO public."__EFMigrationsHistory" ("migration_id", "product_version")
VALUES ('20260316050735_UpdateSunatFieldsVentas', '8.0.0')
ON CONFLICT DO NOTHING;

-- Sincronización para Compras.API (Ya dio éxito, pero aseguramos)
INSERT INTO public."__EFMigrationsHistory" ("migration_id", "product_version")
VALUES ('20260316050748_UpdateSunatFieldsCompras', '8.0.0')
ON CONFLICT DO NOTHING;

-- Sincronización para Catalogo.API
CREATE TABLE IF NOT EXISTS catalogo.__ef_migrations (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL,
    CONSTRAINT pk___ef_migrations PRIMARY KEY (migration_id)
);

INSERT INTO catalogo.__ef_migrations (migration_id, product_version) VALUES ('20260127221140_Inicial', '8.0.8') ON CONFLICT DO NOTHING;
INSERT INTO catalogo.__ef_migrations (migration_id, product_version) VALUES ('20260127221706_AjusteEsquema', '8.0.8') ON CONFLICT DO NOTHING;
INSERT INTO catalogo.__ef_migrations (migration_id, product_version) VALUES ('20260128013043_RefactorTipoProducto', '8.0.8') ON CONFLICT DO NOTHING;
INSERT INTO catalogo.__ef_migrations (migration_id, product_version) VALUES ('20260222180939_AddMetodoValuacionToProducto', '8.0.8') ON CONFLICT DO NOTHING;
