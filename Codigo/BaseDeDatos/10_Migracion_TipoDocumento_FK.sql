/*
==============================================================================
MIGRACIÓN: ACTUALIZAR FOREIGN KEYS DE TIPO DOCUMENTO
==============================================================================
Este script actualiza las tablas proveedores, clientes y trabajadores para
que apunten a configuracion.tipo_documento en lugar de tablas_generales_detalle.

IMPORTANTE: Ejecutar después de 09_Migracion_Fase1.sql
==============================================================================
*/

-- ============================================================================
-- 1. MAPEO DE IDs: tablas_generales_detalle -> tipo_documento
-- ============================================================================
-- Primero necesitamos crear una tabla temporal para mapear los IDs antiguos
-- a los nuevos IDs de tipo_documento

DO $$
DECLARE
    v_dni_old_id BIGINT;
    v_ruc_old_id BIGINT;
    v_carnet_old_id BIGINT;
    v_pasaporte_old_id BIGINT;
    v_dni_new_id BIGINT;
    v_ruc_new_id BIGINT;
    v_carnet_new_id BIGINT;
    v_pasaporte_new_id BIGINT;
BEGIN
    -- Obtener IDs antiguos de tablas_generales_detalle (asumiendo códigos estándar)
    SELECT id_detalle INTO v_dni_old_id 
    FROM configuracion.tablas_generales_detalle 
    WHERE codigo = '1' AND id_tabla_general = (
        SELECT id_tabla_general FROM configuracion.tablas_generales WHERE codigo = 'TIPO_DOCUMENTO'
    ) LIMIT 1;
    
    SELECT id_detalle INTO v_ruc_old_id 
    FROM configuracion.tablas_generales_detalle 
    WHERE codigo = '6' AND id_tabla_general = (
        SELECT id_tabla_general FROM configuracion.tablas_generales WHERE codigo = 'TIPO_DOCUMENTO'
    ) LIMIT 1;
    
    SELECT id_detalle INTO v_carnet_old_id 
    FROM configuracion.tablas_generales_detalle 
    WHERE codigo = '4' AND id_tabla_general = (
        SELECT id_tabla_general FROM configuracion.tablas_generales WHERE codigo = 'TIPO_DOCUMENTO'
    ) LIMIT 1;
    
    SELECT id_detalle INTO v_pasaporte_old_id 
    FROM configuracion.tablas_generales_detalle 
    WHERE codigo = '7' AND id_tabla_general = (
        SELECT id_tabla_general FROM configuracion.tablas_generales WHERE codigo = 'TIPO_DOCUMENTO'
    ) LIMIT 1;
    
    -- Obtener IDs nuevos de tipo_documento
    SELECT id_regla INTO v_dni_new_id FROM configuracion.tipo_documento WHERE codigo = '1' LIMIT 1;
    SELECT id_regla INTO v_ruc_new_id FROM configuracion.tipo_documento WHERE codigo = '6' LIMIT 1;
    SELECT id_regla INTO v_carnet_new_id FROM configuracion.tipo_documento WHERE codigo = '4' LIMIT 1;
    SELECT id_regla INTO v_pasaporte_new_id FROM configuracion.tipo_documento WHERE codigo = '7' LIMIT 1;
    
    RAISE NOTICE 'Mapeo de IDs:';
    RAISE NOTICE 'DNI: % -> %', v_dni_old_id, v_dni_new_id;
    RAISE NOTICE 'RUC: % -> %', v_ruc_old_id, v_ruc_new_id;
    RAISE NOTICE 'Carnet: % -> %', v_carnet_old_id, v_carnet_new_id;
    RAISE NOTICE 'Pasaporte: % -> %', v_pasaporte_old_id, v_pasaporte_new_id;
END $$;

-- ============================================================================
-- 2. ACTUALIZAR TABLA PROVEEDORES
-- ============================================================================

-- 2.1 Eliminar constraint existente
ALTER TABLE compras.proveedores 
DROP CONSTRAINT IF EXISTS fk_proveedor_tipo_documento;

-- 2.2 Actualizar los IDs de tipo documento en proveedores
UPDATE compras.proveedores p
SET id_tipo_documento = td.id_regla
FROM configuracion.tipo_documento td
INNER JOIN configuracion.tablas_generales_detalle tgd 
    ON td.codigo = tgd.codigo
WHERE p.id_tipo_documento = tgd.id_detalle
    AND tgd.id_tabla_general = (
        SELECT id_tabla_general 
        FROM configuracion.tablas_generales 
        WHERE codigo = 'TIPO_DOCUMENTO'
    );

-- 2.3 Crear nuevo constraint apuntando a tipo_documento
ALTER TABLE compras.proveedores
ADD CONSTRAINT fk_proveedor_tipo_documento 
FOREIGN KEY (id_tipo_documento) 
REFERENCES configuracion.tipo_documento(id_regla);

-- Verificar actualización
SELECT 
    'PROVEEDORES' as tabla,
    COUNT(*) as total_registros,
    COUNT(DISTINCT id_tipo_documento) as tipos_documento_distintos
FROM compras.proveedores;

-- ============================================================================
-- 3. ACTUALIZAR TABLA CLIENTES
-- ============================================================================

-- 3.1 Eliminar constraint existente
ALTER TABLE ventas.clientes 
DROP CONSTRAINT IF EXISTS fk_cliente_tipo_documento;

-- 3.2 Actualizar los IDs de tipo documento en clientes
UPDATE ventas.clientes c
SET id_tipo_documento = td.id_regla
FROM configuracion.tipo_documento td
INNER JOIN configuracion.tablas_generales_detalle tgd 
    ON td.codigo = tgd.codigo
WHERE c.id_tipo_documento = tgd.id_detalle
    AND tgd.id_tabla_general = (
        SELECT id_tabla_general 
        FROM configuracion.tablas_generales 
        WHERE codigo = 'TIPO_DOCUMENTO'
    );

-- 3.3 Crear nuevo constraint apuntando a tipo_documento
ALTER TABLE ventas.clientes
ADD CONSTRAINT fk_cliente_tipo_documento 
FOREIGN KEY (id_tipo_documento) 
REFERENCES configuracion.tipo_documento(id_regla);

-- Verificar actualización
SELECT 
    'CLIENTES' as tabla,
    COUNT(*) as total_registros,
    COUNT(DISTINCT id_tipo_documento) as tipos_documento_distintos
FROM ventas.clientes;

-- ============================================================================
-- 4. ACTUALIZAR TABLA TRABAJADORES
-- ============================================================================

-- 4.1 Eliminar constraint existente
ALTER TABLE rrhh.trabajadores 
DROP CONSTRAINT IF EXISTS fk_trabajador_tipo_documento;

-- 4.2 Actualizar los IDs de tipo documento en trabajadores
UPDATE rrhh.trabajadores t
SET id_tipo_documento = td.id_regla
FROM configuracion.tipo_documento td
INNER JOIN configuracion.tablas_generales_detalle tgd 
    ON td.codigo = tgd.codigo
WHERE t.id_tipo_documento = tgd.id_detalle
    AND tgd.id_tabla_general = (
        SELECT id_tabla_general 
        FROM configuracion.tablas_generales 
        WHERE codigo = 'TIPO_DOCUMENTO'
    );

-- 4.3 Crear nuevo constraint apuntando a tipo_documento
ALTER TABLE rrhh.trabajadores
ADD CONSTRAINT fk_trabajador_tipo_documento 
FOREIGN KEY (id_tipo_documento) 
REFERENCES configuracion.tipo_documento(id_regla);

-- Verificar actualización
SELECT 
    'TRABAJADORES' as tabla,
    COUNT(*) as total_registros,
    COUNT(DISTINCT id_tipo_documento) as tipos_documento_distintos
FROM rrhh.trabajadores;

-- ============================================================================
-- 5. VERIFICACIÓN FINAL
-- ============================================================================

-- Mostrar resumen de tipos de documento en uso
SELECT 
    td.codigo,
    td.nombre,
    COUNT(DISTINCT p.id_proveedor) as proveedores,
    COUNT(DISTINCT c.id_cliente) as clientes,
    COUNT(DISTINCT t.id_trabajador) as trabajadores
FROM configuracion.tipo_documento td
LEFT JOIN compras.proveedores p ON p.id_tipo_documento = td.id_regla
LEFT JOIN ventas.clientes c ON c.id_tipo_documento = td.id_regla
LEFT JOIN rrhh.trabajadores t ON t.id_tipo_documento = td.id_regla
GROUP BY td.id_regla, td.codigo, td.nombre
ORDER BY td.codigo;

-- ============================================================================
-- NOTAS IMPORTANTES
-- ============================================================================
/*
1. Este script asume que los códigos en tipo_documento coinciden con los de
   tablas_generales_detalle (1=DNI, 6=RUC, 4=Carnet, 7=Pasaporte, etc.)

2. Si hay registros con id_tipo_documento que no tienen correspondencia en
   tipo_documento, esos registros NO se actualizarán y causarán error al
   crear el foreign key.

3. Para verificar si hay IDs huérfanos antes de ejecutar, usar:
   
   SELECT DISTINCT p.id_tipo_documento, tgd.codigo, tgd.valor
   FROM compras.proveedores p
   LEFT JOIN configuracion.tablas_generales_detalle tgd 
       ON p.id_tipo_documento = tgd.id_detalle
   WHERE tgd.id_detalle IS NULL;

4. Después de ejecutar este script, las aplicaciones que usen estas tablas
   deben actualizar sus referencias para usar configuracion.tipo_documento.
*/
