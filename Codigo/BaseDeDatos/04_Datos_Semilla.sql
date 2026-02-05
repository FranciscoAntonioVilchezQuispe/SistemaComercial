-- =====================================================
-- Script de Datos Semilla (Datos de Prueba)
-- Base de Datos: sistema_comercial
-- =====================================================

-- 1. CATALOGO BASE
-- =====================================================
INSERT INTO catalogo.categorias (nombre_categoria, descripcion, usuario_creacion)
VALUES ('General', 'Categoría por defecto', 'SEEDER')
ON CONFLICT DO NOTHING;

INSERT INTO catalogo.marcas (nombre_marca, pais_origen, usuario_creacion)
VALUES ('Generica', 'Peru', 'SEEDER')
ON CONFLICT DO NOTHING;

INSERT INTO catalogo.unidades_medida (codigo_sunat, nombre_unidad, simbolo, usuario_creacion)
VALUES ('NIU', 'Unidad', 'UND', 'SEEDER')
ON CONFLICT DO NOTHING;

-- 2. PRODUCTO DE PRUEBA
-- =====================================================
DO $$
DECLARE
    v_id_categoria bigint;
    v_id_marca bigint;
    v_id_unidad bigint;
BEGIN
    SELECT id_categoria INTO v_id_categoria FROM catalogo.categorias WHERE nombre_categoria = 'General' LIMIT 1;
    SELECT id_marca INTO v_id_marca FROM catalogo.marcas WHERE nombre_marca = 'Generica' LIMIT 1;
    SELECT id_unidad INTO v_id_unidad FROM catalogo.unidades_medida WHERE simbolo = 'UND' LIMIT 1;

    INSERT INTO catalogo.productos (
        codigo_producto, nombre_producto, descripcion, 
        id_categoria, id_marca, id_unidad, 
        precio_venta_publico, stock_minimo, usuario_creacion
    )
    VALUES (
        'PROD-001', 'Producto de Prueba', 'Este es un producto generado automáticamente',
        v_id_categoria, v_id_marca, v_id_unidad,
        100.00, 10, 'SEEDER'
    )
    ON CONFLICT DO NOTHING;
END $$;

-- 3. CLIENTE DE PRUEBA
-- =====================================================
INSERT INTO clientes.clientes (
    numero_documento, razon_social, direccion, 
    email, usuario_creacion
)
VALUES (
    '12345678', 'Cliente Mostrador', 'Av. Principal 123',
    'cliente@ejemplo.com', 'SEEDER'
)
ON CONFLICT DO NOTHING;

-- 4. CONFIGURACION BASICA (EMPRESA)
-- =====================================================
-- Asumimos que la tabla empresa existe en esquema configuracion
INSERT INTO configuracion.empresa (
    razon_social, ruc, direccion, usuario_creacion
)
VALUES (
    'Mi Empresa S.A.C.', '20123456789', 'Calle Las Flores 456', 'SEEDER'
)
ON CONFLICT DO NOTHING;

SELECT 'Categorias' as tabla, count(*)::bigint FROM catalogo.categorias UNION ALL SELECT 'Marcas', count(*)::bigint FROM catalogo.marcas;
