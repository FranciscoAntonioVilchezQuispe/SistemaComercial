-- =============================================
-- CONSULTA: Kardex Valorizado SUNAT (Tabla 12)
-- Propósito: Generar el reporte con saldos acumulados en tiempo real.
-- =============================================

SELECT 
    m.fecha_movimiento AS fecha,
    m.tipo_documento AS tipo_doc_sunat,
    m.serie_documento AS serie,
    m.numero_documento AS numero,
    m.motivo_traslado_sunat AS tipo_operacion_cod,
    m.descripcion_movimiento AS operacion,

    -- ENTRADAS
    m.entrada_cantidad AS entrada_cant,
    m.entrada_costo_unitario AS entrada_costo_u,
    m.entrada_costo_total AS entrada_total,

    -- SALIDAS
    m.salida_cantidad AS salida_cant,
    m.salida_costo_unitario AS salida_costo_u,
    m.salida_costo_total AS salida_total,

    -- SALDOS (Basados en el cálculo al momento del registro)
    m.saldo_cantidad AS saldo_cant,
    m.saldo_costo_unitario AS saldo_costo_u,
    m.saldo_costo_total AS saldo_total

FROM inventario.inv_kardex_movimiento m
WHERE m.producto_id = :IdProducto 
  AND m.almacen_id = :IdAlmacen
  AND m.fecha_movimiento BETWEEN :FechaInicio AND :FechaFin
  AND m.anulado = false
ORDER BY m.fecha_movimiento ASC, m.hora_movimiento ASC, m.correlativo_kardex ASC;
