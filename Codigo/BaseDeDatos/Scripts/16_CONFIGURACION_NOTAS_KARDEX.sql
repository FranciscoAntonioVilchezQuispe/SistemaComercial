-- SCRIPT: CONFIGURACIÓN DE NOTAS DE CRÉDITO Y DÉBITO PARA KARDEX
-- FECHA: 2026-04-07
-- DESCRIPCIÓN: Asegura que las notas muevan stock correctamente según el módulo.

-- Actualizar configuración para Nota de Crédito (07)
UPDATE configuracion.tipo_comprobante
SET mueve_stock = true,
    tipo_movimiento_stock = 'DEPENDIENTE',
    movimiento_stock_venta = 'ENTRADA', -- NC Venta es una devolución del cliente (Ingreso)
    movimiento_stock_compra = 'SALIDA',  -- NC Compra es una devolución al proveedor (Salida)
    fecha_modificacion = CURRENT_TIMESTAMP,
    usuario_modificacion = 'SISTEMA_KARDEX'
WHERE codigo = '07';

-- Actualizar configuración para Nota de Débito (08)
UPDATE configuracion.tipo_comprobante
SET mueve_stock = true,
    tipo_movimiento_stock = 'DEPENDIENTE',
    movimiento_stock_venta = 'SALIDA',  -- ND Venta aumenta la deuda/cantidad vendida (Salida)
    movimiento_stock_compra = 'ENTRADA', -- ND Compra aumenta la deuda/cantidad comprada (Entrada)
    fecha_modificacion = CURRENT_TIMESTAMP,
    usuario_modificacion = 'SISTEMA_KARDEX'
WHERE codigo = '08';

-- Verificar resultados (Para logs)
DO $$
BEGIN
    RAISE NOTICE 'Configuración de Notas (07, 08) actualizada correctamente.';
END $$;
