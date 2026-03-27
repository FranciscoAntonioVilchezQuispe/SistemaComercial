-- Script para agregar el estado 'Facturada' a las Órdenes de Compra
-- Grupo: ESTADO_ORDEN_COMPRA (ID 11)

INSERT INTO configuracion.tablas_generales_detalle 
    (id_detalle, id_tabla, codigo, nombre, valor, orden, activado, fecha_creacion, usuario_creacion)
VALUES 
    (43, 11, 'FAC', 'Facturada', NULL, 5, true, NOW(), 'SYSTEM')
ON CONFLICT (id_detalle) DO UPDATE SET nombre = 'Facturada', codigo = 'FAC';

-- Verificar inserción
SELECT * FROM configuracion.tablas_generales_detalle WHERE id_tabla = 11;
