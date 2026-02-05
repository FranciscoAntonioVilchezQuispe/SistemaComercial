-- =====================================================
-- Script de Datos - Configuracion (Tablas Faltantes)
-- =====================================================

-- 1. TIPOS DE COMPROBANTE
INSERT INTO configuracion.tipos_comprobantes (codigo, nombre, mueve_stock, tipo_movimiento_stock)
VALUES 
    ('01', 'FACTURA', false, 'NEUTRO'),
    ('03', 'BOLETA DE VENTA', false, 'NEUTRO'),
    ('07', 'NOTA DE CREDITO', true, 'ENTRADA'),
    ('08', 'NOTA DE DEBITO', false, 'NEUTRO'),
    ('09', 'GUIA DE REMISION', true, 'SALIDA'),
    ('00', 'COTIZACION', false, 'NEUTRO')
ON CONFLICT DO NOTHING;

-- 2. IMPUESTOS
INSERT INTO configuracion.impuestos (codigo_sunat, nombre, porcentaje)
VALUES 
    ('1000', 'IGV', 18.00),
    ('2000', 'ISC', 0.00),
    ('9997', 'EXONERADO', 0.00),
    ('9998', 'INAFECTO', 0.00)
ON CONFLICT DO NOTHING;

-- 3. PARAMETROS
INSERT INTO configuracion.parametros_configuracion (codigo, valor, descripcion, grupo)
VALUES 
    ('MONEDA_DEFECTO', 'PEN', 'Moneda por defecto del sistema', 'GENERAL'),
    ('IGV_DEFECTO', '18.00', 'Porcentaje de IGV actual', 'FISCAL')
ON CONFLICT DO NOTHING;

-- 4. SUCURSAL (Requiere Empresa existente, ID=1 asumiendo seed)
-- Nota: Si no hay empresa con ID 1, esto puede fallar si no se inserta antes. 
-- El script 04_Datos_Semilla.sql inserta Empresa.
INSERT INTO configuracion.sucursales (id_empresa, codigo, nombre, direccion, es_principal)
SELECT id_empresa, '001', 'Sucursal Principal', 'Av. Principal 123', true
FROM configuracion.empresa WHERE ruc = '20123456789' LIMIT 1;
