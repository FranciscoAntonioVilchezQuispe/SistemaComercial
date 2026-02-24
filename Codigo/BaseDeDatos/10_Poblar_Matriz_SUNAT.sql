-- =====================================================
-- DATOS SEMILLA: Matriz de Reglas SUNAT (Cruce Dinámico)
-- =====================================================

-- 1. Limpiar y poblar Tipos de Operación
TRUNCATE TABLE configuracion.tipo_operacion_sunat CASCADE;
INSERT INTO configuracion.tipo_operacion_sunat (codigo, nombre) VALUES 
('01', 'VENTA'),
('02', 'COMPRA'),
('03', 'CONSIGNACION RECIBIDA'),
('04', 'CONSIGNACION ENTREGADA'),
('05', 'DEVOLUCION RECIBIDA'),
('06', 'DEVOLUCION ENTREGADA'),
('10', 'SALIDA A PRODUCCION'),
('11', 'TRANSFERENCIA ENTRE ALMACENES'),
('13', 'MERMAS'),
('16', 'SALDO INICIAL');

-- 2. Limpiar Matriz
TRUNCATE TABLE configuracion.matriz_regla_sunat RESTART IDENTITY;

-- Función auxiliar para insertar reglas por códigos
DO $$
DECLARE
    v_op_01 INT; v_op_02 INT; v_op_03 INT; v_op_04 INT; v_op_05 INT; v_op_06 INT;
    v_op_10 INT; v_op_11 INT; v_op_13 INT; v_op_16 INT;
BEGIN
    SELECT id_tipo_operacion INTO v_op_01 FROM configuracion.tipo_operacion_sunat WHERE codigo = '01';
    SELECT id_tipo_operacion INTO v_op_02 FROM configuracion.tipo_operacion_sunat WHERE codigo = '02';
    SELECT id_tipo_operacion INTO v_op_03 FROM configuracion.tipo_operacion_sunat WHERE codigo = '03';
    SELECT id_tipo_operacion INTO v_op_04 FROM configuracion.tipo_operacion_sunat WHERE codigo = '04';
    SELECT id_tipo_operacion INTO v_op_05 FROM configuracion.tipo_operacion_sunat WHERE codigo = '05';
    SELECT id_tipo_operacion INTO v_op_06 FROM configuracion.tipo_operacion_sunat WHERE codigo = '06';
    SELECT id_tipo_operacion INTO v_op_10 FROM configuracion.tipo_operacion_sunat WHERE codigo = '10';
    SELECT id_tipo_operacion INTO v_op_11 FROM configuracion.tipo_operacion_sunat WHERE codigo = '11';
    SELECT id_tipo_operacion INTO v_op_13 FROM configuracion.tipo_operacion_sunat WHERE codigo = '13';
    SELECT id_tipo_operacion INTO v_op_16 FROM configuracion.tipo_operacion_sunat WHERE codigo = '16';

    -- VENTA (01) -> Factura(01), Boleta(03), Ticket(12)
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_01, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo IN ('01', '03', '12');

    -- COMPRA (02) -> Factura(01), Liq.Comp(04), DAM(50) son Prin; GR(09) Comp
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_02, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo IN ('01', '04', '50');
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_02, id_tipo_comprobante, 2 FROM configuracion.tipo_comprobante WHERE codigo = '09';

    -- CONSIGNACION (03/04) -> GR(09)
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_03, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = '09';
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_04, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = '09';

    -- DEVOLUCION (05/06) -> NC(07), ND(08)
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_05, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = '07';
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_06, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = '08';

    -- TRANSFERENCIA (11) -> GR(09)
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_11, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = '09';

    -- SALDO INICIAL (16) -> Cargo (AI - Ajuste Inventario se suele mapear a un código interno si no hay SUNAT)
    INSERT INTO configuracion.matriz_regla_sunat (id_tipo_operacion, id_tipo_comprobante, nivel_obligatoriedad)
    SELECT v_op_16, id_tipo_comprobante, 1 FROM configuracion.tipo_comprobante WHERE codigo = 'AI';
END $$;
