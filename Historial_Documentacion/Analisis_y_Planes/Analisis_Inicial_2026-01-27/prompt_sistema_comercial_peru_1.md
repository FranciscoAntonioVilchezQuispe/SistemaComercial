# PROMPT PARA IDE — SISTEMA COMERCIAL (PERÚ)
## Stack: React + .NET (C#) + PostgreSQL

---

## CONTEXTO DEL PROYECTO

Estoy desarrollando un **sistema comercial para una empresa en Perú**, cumpliendo con las normativas tributarias de la **SUNAT**. El proyecto ya tiene avance en algunas tablas y páginas que deben **respetarse y adaptarse**, no reemplazarse. Solo agrega o modifica lo que sea necesario para cumplir con los requerimientos que describo a continuación.

**Stack tecnológico:**
- Frontend: React (con componentes ya existentes)
- Backend: .NET (C# Web API)
- Base de datos: PostgreSQL
- Normativa: SUNAT – Perú

---

## MÓDULOS REQUERIDOS

### 1. MÓDULO DE COMPRAS

#### Lógica de negocio
- Registrar **órdenes de compra** a proveedores.
- Registrar la **recepción de mercadería** contra la orden de compra.
- Asociar el comprobante recibido del proveedor: puede ser **Factura**, **Liquidación de Compra** o **Recibo por Honorarios**.
- El comprobante de compra debe capturar:
  - `tipo_comprobante` (ENUM: FACTURA, LIQUIDACION_COMPRA, RECIBO_HONORARIOS)
  - `serie` (ej: F001, LC01)
  - `numero_correlativo`
  - `fecha_emision`
  - `fecha_vencimiento` (opcional)
  - `ruc_proveedor` / `nombre_proveedor`
  - `valor_compra` (base imponible SIN IGV)
  - `igv` (18% del valor_compra, solo si aplica)
  - `total_compra` (valor_compra + igv)
  - `afecto_igv` (boolean — las compras con Liquidación de Compra generan IGV propio)
  - `estado` (PENDIENTE, RECIBIDO, ANULADO)

#### Reglas SUNAT para Compras
- Solo las **Facturas** con RUC de la empresa generan **crédito fiscal** de IGV.
- Las **Boletas de Venta** recibidas NO generan crédito fiscal (no incluirlas en el Registro de Compras como sustento de crédito).
- El costo del inventario se registra **sin IGV** (el IGV va al crédito fiscal, no al costo).
- Si se recibe una **Nota de Crédito** del proveedor: reduce el valor de la compra y genera una entrada inversa en el kardex.
- Si se recibe una **Nota de Débito** del proveedor: aumenta el valor y genera ajuste en el kardex.

#### Tablas sugeridas (crear si no existen, adaptar si ya existen)

```sql
-- Proveedores
CREATE TABLE proveedores (
  id SERIAL PRIMARY KEY,
  ruc VARCHAR(11) UNIQUE NOT NULL,
  razon_social VARCHAR(200) NOT NULL,
  direccion TEXT,
  telefono VARCHAR(20),
  email VARCHAR(100),
  tipo_proveedor VARCHAR(50), -- PERSONA_NATURAL, PERSONA_JURIDICA
  estado BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Orden de Compra
CREATE TABLE ordenes_compra (
  id SERIAL PRIMARY KEY,
  proveedor_id INT REFERENCES proveedores(id),
  fecha_orden DATE NOT NULL,
  fecha_entrega_esperada DATE,
  estado VARCHAR(20) DEFAULT 'PENDIENTE', -- PENDIENTE, PARCIAL, COMPLETADO, ANULADO
  observaciones TEXT,
  usuario_id INT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Detalle de Orden de Compra
CREATE TABLE detalle_ordenes_compra (
  id SERIAL PRIMARY KEY,
  orden_compra_id INT REFERENCES ordenes_compra(id),
  producto_id INT REFERENCES productos(id),
  cantidad NUMERIC(12,4) NOT NULL,
  costo_unitario NUMERIC(12,4) NOT NULL, -- SIN IGV
  subtotal NUMERIC(12,4) NOT NULL
);

-- Comprobantes de Compra (facturas, liquidaciones recibidas)
CREATE TABLE comprobantes_compra (
  id SERIAL PRIMARY KEY,
  proveedor_id INT REFERENCES proveedores(id),
  orden_compra_id INT REFERENCES ordenes_compra(id),
  tipo_comprobante VARCHAR(30) NOT NULL, -- FACTURA, LIQUIDACION_COMPRA, RECIBO_HONORARIOS
  serie VARCHAR(10),
  numero VARCHAR(20),
  fecha_emision DATE NOT NULL,
  fecha_vencimiento DATE,
  valor_compra NUMERIC(14,2) NOT NULL,  -- Base imponible sin IGV
  igv NUMERIC(14,2) DEFAULT 0,          -- 18% solo si afecto
  total_compra NUMERIC(14,2) NOT NULL,  -- valor_compra + igv
  afecto_igv BOOLEAN DEFAULT TRUE,
  tiene_credito_fiscal BOOLEAN DEFAULT TRUE, -- FALSE para boletas
  estado VARCHAR(20) DEFAULT 'ACTIVO',  -- ACTIVO, ANULADO
  observaciones TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Detalle de Comprobante de Compra
CREATE TABLE detalle_comprobantes_compra (
  id SERIAL PRIMARY KEY,
  comprobante_compra_id INT REFERENCES comprobantes_compra(id),
  producto_id INT REFERENCES productos(id),
  descripcion TEXT,
  cantidad NUMERIC(12,4) NOT NULL,
  costo_unitario NUMERIC(12,4) NOT NULL, -- SIN IGV
  subtotal NUMERIC(12,4) NOT NULL
);

-- Notas de Crédito / Débito de Compras
CREATE TABLE notas_compra (
  id SERIAL PRIMARY KEY,
  comprobante_compra_id INT REFERENCES comprobantes_compra(id),
  tipo_nota VARCHAR(10) NOT NULL, -- CREDITO, DEBITO
  serie VARCHAR(10),
  numero VARCHAR(20),
  fecha_emision DATE NOT NULL,
  motivo VARCHAR(100), -- DEVOLUCION, DESCUENTO, BONIFICACION, ERROR, AJUSTE
  valor_afectado NUMERIC(14,2),
  igv_afectado NUMERIC(14,2),
  total_afectado NUMERIC(14,2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

### 2. MÓDULO DE VENTAS

#### Lógica de negocio
- Registrar ventas a clientes con comprobante: **Factura**, **Boleta de Venta** o **Ticket**.
- El tipo de comprobante depende del cliente:
  - Cliente con RUC → **Factura**
  - Consumidor final sin RUC → **Boleta de Venta**
- Campos obligatorios del comprobante de venta:
  - `tipo_comprobante` (ENUM: FACTURA, BOLETA, TICKET)
  - `serie` (F001 para facturas, B001 para boletas)
  - `numero_correlativo` (autonumérico por serie)
  - `fecha_emision`
  - `ruc_cliente` / `dni_cliente` / `nombre_cliente`
  - `valor_venta` (base imponible SIN IGV)
  - `igv` (18% si es afecto)
  - `total_venta` (valor_venta + igv)
  - `afecto_igv` (boolean)
  - `estado` (EMITIDO, ANULADO)

#### Reglas SUNAT para Ventas
- Las **Facturas** deben ir a nombre del cliente con su RUC obligatoriamente.
- Las **Boletas** pueden emitirse sin datos del comprador si el monto es menor a 700 soles.
- El número correlativo es **independiente por cada serie** y **no se puede repetir**.
- Toda anulación se hace con una **Nota de Crédito**, nunca eliminando el registro.
- El **precio de venta incluye IGV** (precio de vitrina), pero el comprobante debe desglosar: valor_venta + IGV = total.
- Fórmula: `valor_venta = total / 1.18` — `igv = total - valor_venta`

#### Tablas sugeridas

```sql
-- Clientes
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  tipo_documento VARCHAR(10) NOT NULL, -- RUC, DNI, CE, PASAPORTE
  numero_documento VARCHAR(15) UNIQUE NOT NULL,
  nombre_razon_social VARCHAR(200) NOT NULL,
  direccion TEXT,
  telefono VARCHAR(20),
  email VARCHAR(100),
  es_empresa BOOLEAN DEFAULT FALSE,
  estado BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Series de Comprobantes
CREATE TABLE series_comprobante (
  id SERIAL PRIMARY KEY,
  tipo_comprobante VARCHAR(20) NOT NULL, -- FACTURA, BOLETA, NOTA_CREDITO, NOTA_DEBITO
  serie VARCHAR(10) NOT NULL UNIQUE,     -- F001, B001, FC01, BC01
  correlativo_actual INT DEFAULT 0,
  estado BOOLEAN DEFAULT TRUE
);

-- Comprobantes de Venta
CREATE TABLE comprobantes_venta (
  id SERIAL PRIMARY KEY,
  cliente_id INT REFERENCES clientes(id),
  tipo_comprobante VARCHAR(20) NOT NULL,  -- FACTURA, BOLETA, TICKET
  serie VARCHAR(10) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  fecha_emision DATE NOT NULL,
  fecha_vencimiento DATE,
  valor_venta NUMERIC(14,2) NOT NULL,     -- Base imponible sin IGV
  igv NUMERIC(14,2) DEFAULT 0,            -- 18% si afecto
  total_venta NUMERIC(14,2) NOT NULL,     -- valor_venta + igv
  afecto_igv BOOLEAN DEFAULT TRUE,
  estado VARCHAR(20) DEFAULT 'EMITIDO',   -- EMITIDO, ANULADO
  observaciones TEXT,
  usuario_id INT,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(tipo_comprobante, serie, numero)
);

-- Detalle de Comprobante de Venta
CREATE TABLE detalle_comprobantes_venta (
  id SERIAL PRIMARY KEY,
  comprobante_venta_id INT REFERENCES comprobantes_venta(id),
  producto_id INT REFERENCES productos(id),
  descripcion TEXT,
  cantidad NUMERIC(12,4) NOT NULL,
  precio_unitario NUMERIC(12,4) NOT NULL,  -- Con IGV (precio de venta al público)
  valor_unitario NUMERIC(12,4) NOT NULL,   -- Sin IGV
  subtotal_valor NUMERIC(14,2) NOT NULL,   -- Sin IGV
  subtotal_igv NUMERIC(14,2) NOT NULL,     -- IGV del ítem
  subtotal_total NUMERIC(14,2) NOT NULL    -- Con IGV
);

-- Notas de Crédito / Débito de Ventas
CREATE TABLE notas_venta (
  id SERIAL PRIMARY KEY,
  comprobante_venta_id INT REFERENCES comprobantes_venta(id),
  tipo_nota VARCHAR(10) NOT NULL, -- CREDITO, DEBITO
  serie VARCHAR(10),
  numero VARCHAR(20),
  fecha_emision DATE NOT NULL,
  motivo VARCHAR(100), -- DEVOLUCION, DESCUENTO, BONIFICACION, ERROR_EN_RUC
  valor_afectado NUMERIC(14,2),
  igv_afectado NUMERIC(14,2),
  total_afectado NUMERIC(14,2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

### 3. MÓDULO DE STOCK / KARDEX

#### Lógica de negocio
- El kardex registra **cada movimiento** que afecta el stock de un producto.
- Todo movimiento tiene: tipo, cantidad, costo unitario (al momento del movimiento), saldo resultante.
- **Método de valuación:** Promedio Ponderado (por defecto) o PEPS/FIFO (configurable).
- El costo en el kardex es **siempre sin IGV**.
- El sistema debe actualizar el kardex **automáticamente** al registrar o anular un comprobante.

#### Tipos de movimiento y su origen

| Tipo Movimiento | Origen | Efecto Stock |
|---|---|---|
| COMPRA | Comprobante de compra | ENTRADA |
| VENTA | Comprobante de venta | SALIDA |
| DEVOLUCION_COMPRA | Nota de crédito del proveedor | SALIDA |
| DEVOLUCION_VENTA | Nota de crédito emitida al cliente | ENTRADA |
| AJUSTE_POSITIVO | Inventario físico / corrección | ENTRADA |
| AJUSTE_NEGATIVO | Merma, desmedro, robo sustentado | SALIDA |
| TRANSFERENCIA_ENTRADA | Traslado entre almacenes | ENTRADA |
| TRANSFERENCIA_SALIDA | Traslado entre almacenes | SALIDA |

#### Tablas sugeridas

```sql
-- Productos (adaptar si ya existe)
CREATE TABLE productos (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50) UNIQUE NOT NULL,
  descripcion VARCHAR(300) NOT NULL,
  unidad_medida VARCHAR(20) DEFAULT 'UND', -- UND, KG, LT, MT, CAJA, etc.
  categoria_id INT,
  precio_compra NUMERIC(12,4) DEFAULT 0,  -- Costo promedio actual SIN IGV
  precio_venta NUMERIC(12,4) DEFAULT 0,   -- Precio de venta CON IGV
  stock_actual NUMERIC(12,4) DEFAULT 0,
  stock_minimo NUMERIC(12,4) DEFAULT 0,
  afecto_igv BOOLEAN DEFAULT TRUE,
  estado BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Almacenes (opcional si manejan múltiples)
CREATE TABLE almacenes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  es_principal BOOLEAN DEFAULT FALSE,
  estado BOOLEAN DEFAULT TRUE
);

-- Kardex de movimientos
CREATE TABLE kardex (
  id SERIAL PRIMARY KEY,
  producto_id INT REFERENCES productos(id) NOT NULL,
  almacen_id INT REFERENCES almacenes(id),
  fecha DATE NOT NULL,
  tipo_movimiento VARCHAR(30) NOT NULL,      -- Ver tabla arriba
  referencia_tipo VARCHAR(30),               -- COMPROBANTE_COMPRA, COMPROBANTE_VENTA, NOTA, AJUSTE
  referencia_id INT,                         -- ID del comprobante o documento origen
  referencia_numero VARCHAR(50),             -- Número legible del comprobante
  cantidad_entrada NUMERIC(12,4) DEFAULT 0,
  cantidad_salida NUMERIC(12,4) DEFAULT 0,
  costo_unitario NUMERIC(12,4) NOT NULL,     -- SIN IGV
  costo_total_movimiento NUMERIC(14,4),      -- cantidad * costo_unitario
  saldo_cantidad NUMERIC(12,4) NOT NULL,     -- Stock después del movimiento
  saldo_valorizado NUMERIC(14,4) NOT NULL,   -- saldo_cantidad * costo_unitario promedio
  costo_promedio_vigente NUMERIC(12,4),      -- Costo promedio después del movimiento
  observaciones TEXT,
  usuario_id INT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Stock por almacén (si aplica multi-almacén)
CREATE TABLE stock_por_almacen (
  id SERIAL PRIMARY KEY,
  producto_id INT REFERENCES productos(id),
  almacen_id INT REFERENCES almacenes(id),
  stock_actual NUMERIC(12,4) DEFAULT 0,
  costo_promedio NUMERIC(12,4) DEFAULT 0,
  UNIQUE(producto_id, almacen_id)
);
```

#### Lógica del Costo Promedio (Promedio Ponderado)

```
Al registrar una ENTRADA (compra):
  nuevo_costo_promedio = (stock_actual * costo_promedio_anterior + cantidad_entrada * costo_nuevo)
                         / (stock_actual + cantidad_entrada)
  
  saldo_cantidad = stock_anterior + cantidad_entrada
  saldo_valorizado = saldo_cantidad * nuevo_costo_promedio

Al registrar una SALIDA (venta):
  costo_unitario_salida = costo_promedio_actual (no cambia el promedio)
  saldo_cantidad = stock_anterior - cantidad_salida
  saldo_valorizado = saldo_cantidad * costo_promedio_actual
```

---

## REGLAS GENERALES DEL SISTEMA

1. **Nunca borrar registros** de comprobantes ni kardex. Todo se anula con estado `ANULADO` y se genera el movimiento inverso.
2. **Correlativo automático por serie**: al crear un comprobante, obtener el siguiente número de la tabla `series_comprobante` con bloqueo de concurrencia (`SELECT FOR UPDATE`).
3. **El IGV siempre es 18%** (16% IGV + 2% IPM). Manejar como constante configurable.
4. **Los decimales**: usar mínimo 2 decimales en montos, 4 decimales en cantidades y costos unitarios.
5. **Validaciones obligatorias:**
   - Factura → cliente debe tener RUC (11 dígitos)
   - Boleta → cliente puede tener DNI (8 dígitos) o ser anónimo si total < 700 soles
   - No permitir venta si stock_actual < cantidad a vender (salvo configuración especial)
   - Al anular un comprobante de venta, revertir el kardex automáticamente

---

## LO QUE YA EXISTE (RESPETAR Y ADAPTAR)

El proyecto ya tiene tablas y páginas avanzadas en React y .NET. **No reemplaces lo que ya existe**, solo:
- Agrega las tablas que falten.
- Adapta las tablas existentes si les falta alguna columna de las mencionadas.
- Conecta la lógica de kardex al flujo de compras y ventas existente.
- Mantén la estructura de carpetas y convenciones de código ya usadas.

Antes de generar cualquier código, **analiza los archivos existentes** del proyecto y pregunta qué tablas ya están creadas para evitar duplicados.

---

## ENTREGABLES ESPERADOS

1. Migraciones/scripts SQL para las tablas faltantes o modificadas.
2. Endpoints .NET (Controllers + Services + Repositories) para:
   - CRUD de comprobantes de compra y venta
   - Registro automático de kardex al guardar/anular comprobante
   - Consulta de kardex por producto y rango de fechas
   - Cálculo de costo promedio en tiempo real
3. Componentes React para:
   - Formulario de comprobante de compra (con detalle de productos)
   - Formulario de comprobante de venta (con cálculo automático de IGV)
   - Vista de kardex por producto (tabla con entradas, salidas y saldo)
4. Validaciones tanto en frontend (React) como en backend (.NET).
