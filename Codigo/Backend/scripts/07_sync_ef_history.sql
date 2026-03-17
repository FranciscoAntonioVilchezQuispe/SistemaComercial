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
