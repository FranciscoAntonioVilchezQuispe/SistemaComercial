-- ==============================================================================
-- SCRIPT MAESTRO DE DESPLIEGUE: SISTEMA COMERCIAL
-- Descripción: Orquesta la ejecución de esquemas, tablas y datos iniciales.
-- ==============================================================================

-- 1. ESQUEMAS Y TABLAS (Estructura base)
\i 01_esquema_completo.sql

-- 2. VISTAS DEL SISTEMA
\i 03_vistas_sistema.sql

-- 3. DATOS MAESTROS (Identidad, Catálogos SUNAT)
-- NOTA: Estos scripts deben ser idempotentes (usar ON CONFLICT)
\i 02_datos_maestros.sql

-- 4. CONFIGURACIÓN ESPECÍFICA (Series y Comprobantes)
\i 05_datos_series.sql
\i 06_tipo_orden_compra.sql

-- 5. MANTENIMIENTO Y FIXES (Correcciones de estado)
\i 07_actualizar_estados_oc.sql
\i fix_kardex_tables.sql

-- ==============================================================================
-- FIN DEL DESPLIEGUE
-- ==============================================================================
