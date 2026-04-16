-- Seed de Tipos de Afectación IGV (Catálogo No. 07 SUNAT)
INSERT INTO configuracion.tipo_afectacion_igv 
(codigo_sunat, descripcion, es_gravado, es_exonerado, es_inafecto, es_gratuito, codigo_tributo_default, nombre_tributo_default, activado, fecha_creacion, usuario_creacion)
VALUES 
('10', 'Gravado - Operación Onerosa', true, false, false, false, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('11', 'Gravado - Retiro por Premio', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('12', 'Gravado - Retiro por Donación', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('13', 'Gravado - Retiro', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('14', 'Gravado - Retiro por Publicidad', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('15', 'Gravado - Bonificaciones', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('16', 'Gravado - Retiro por Entrega a Trabajadores', true, false, false, true, '1000', 'IGV', true, NOW(), 'SISTEMA'),
('20', 'Exonerado - Operación Onerosa', false, true, false, false, '9997', 'EXO', true, NOW(), 'SISTEMA'),
('21', 'Exonerado - Transferencia Gratuita', false, true, false, true, '9997', 'EXO', true, NOW(), 'SISTEMA'),
('30', 'Inafecto - Operación Onerosa', false, false, true, false, '9998', 'INA', true, NOW(), 'SISTEMA'),
('31', 'Inafecto - Retiro por Bonificación', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('32', 'Inafecto - Retiro', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('33', 'Inafecto - Retiro por Muestras Médicas', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('34', 'Inafecto - Retiro por Convenio Colectivo', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('35', 'Inafecto - Retiro por Premio', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('36', 'Inafecto - Retiro por Publicidad', false, false, true, true, '9998', 'INA', true, NOW(), 'SISTEMA'),
('40', 'Exportación de Bienes o Servicios', false, false, false, false, '9995', 'EXP', true, NOW(), 'SISTEMA')
ON CONFLICT (codigo_sunat) DO NOTHING;
