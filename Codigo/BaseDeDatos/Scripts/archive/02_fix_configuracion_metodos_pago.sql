-- SCRIPT DE CORRECIÓN PARA MÉTODOS DE PAGO (FASE 9)
-- Crea la tabla faltante en el esquema de configuración para el microservicio Configuracion.API

-- 1. Crear la tabla configuracion.metodos_pago
CREATE TABLE IF NOT EXISTS configuracion.metodos_pago (
    id_metodo_pago BIGSERIAL PRIMARY KEY,
    codigo CHARACTER VARYING(20) NOT NULL,
    nombre CHARACTER VARYING(100) NOT NULL,
    es_efectivo BOOLEAN DEFAULT FALSE NOT NULL,
    id_tipo_documento_pago BIGINT, -- Relación opcional con tipo de documento
    activado BOOLEAN DEFAULT TRUE NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    usuario_creacion CHARACTER VARYING(50) NOT NULL,
    fecha_modificacion TIMESTAMP WITH TIME ZONE,
    usuario_modificacion CHARACTER VARYING(50)
);

-- 2. Índices básicos
CREATE INDEX IF NOT EXISTS idx_metodos_pago_codigo ON configuracion.metodos_pago(codigo);

-- 3. Carga de Datos Iniciales (Seed Data)
INSERT INTO configuracion.metodos_pago (codigo, nombre, es_efectivo, usuario_creacion)
VALUES 
('EFECTIVO', 'Pago en Efectivo', TRUE, 'SISTEMA'),
('TARJETA', 'Tarjeta de Débito/Crédito', FALSE, 'SISTEMA'),
('TRANSFERENCIA', 'Transferencia Bancaria', FALSE, 'SISTEMA'),
('YAPE_PLIN', 'Billetera Digital (Yape/Plin)', FALSE, 'SISTEMA')
ON CONFLICT (id_metodo_pago) DO NOTHING;

-- Nota: Si ya existe la tabla ventas.metodos_pago, esta se mantiene para compatibilidad legacy 
-- pero Configuracion.API usará exclusivamente esta nueva tabla centralizada.
