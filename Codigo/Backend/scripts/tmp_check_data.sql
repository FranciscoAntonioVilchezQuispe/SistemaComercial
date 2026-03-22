-- Consulta para verificar los datos en tipo_documento y tipo_comprobante
SELECT 'TIPO_DOCUMENTO' as origen, id, codigo, nombre FROM configuracion.tipo_documento
UNION ALL
SELECT 'TIPO_COMPROBANTE' as origen, id, codigo, nombre FROM configuracion.tipo_comprobante
ORDER BY origen, codigo;
