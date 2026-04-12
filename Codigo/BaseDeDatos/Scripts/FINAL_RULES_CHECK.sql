SELECT r.id_rule, r.motivo_sunat, t.codigo, r.nivel_relacion 
FROM configuracion.matriz_regla_sunat r
JOIN configuracion.tipo_comprobante t ON r.id_tipo_comprobante = t.id_tipo_comprobante
WHERE t.codigo IN ('01', '07', '08');
