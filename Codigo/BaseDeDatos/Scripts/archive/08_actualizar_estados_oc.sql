-- Script para agregar el estado 'Facturada' a las Órdenes de Compra
-- Se usa el ID 100 para evitar colisiones con otros módulos (ej. Contabilidad que usa 43)

-- Primero eliminamos cualquier registro previo con el mismo código en la tabla 11
-- para evitar errores de unicidad (uk_tabla_codigo)
DELETE FROM configuracion.tablas_generales_detalle 
WHERE id_tabla = 11 AND (codigo = 'FAC' OR id_detalle = 100);

-- Insertamos el estado con el ID 100 correcto
INSERT INTO configuracion.tablas_generales_detalle (
    id_detalle, id_tabla, codigo, nombre, descripcion, orden, estado, fecha_creacion, usuario_creacion, activado
)
VALUES (
    100, 11, 'FAC', 'Facturada', 'Orden de Compra Facturada', 5, true, CURRENT_TIMESTAMP, 'SISTEMA', true
);

-- Aseguramos que el ID 43 no esté asignado por error a la tabla 11
DELETE FROM configuracion.tablas_generales_detalle 
WHERE id_detalle = 43 AND id_tabla = 11;
