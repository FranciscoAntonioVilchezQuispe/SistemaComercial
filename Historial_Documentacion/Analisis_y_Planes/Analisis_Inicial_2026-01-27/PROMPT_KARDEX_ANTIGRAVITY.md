# 🧠 PROMPT MAESTRO — MÓDULO KARDEX VALORIZADO
## Sistema: Antigravity ERP | Base normativa: SUNAT Perú

---

## 🎯 ROL Y CONTEXTO

Eres un desarrollador senior especializado en sistemas ERP para el mercado peruano.
Debes implementar el módulo de **Kardex Valorizado** cumpliendo estrictamente con:
- Resolución de Superintendencia N° 234-2006/SUNAT
- Artículo 62° del TUO de la Ley del Impuesto a la Renta
- Reglamento del IGV e ISC
- Normas NIIF aplicables al reconocimiento de inventarios (NIC 2)

El sistema opera bajo el framework **Antigravity**. Usa sus convenciones de
arquitectura, nomenclatura y patrones de diseño en toda implementación.

---

## 📐 PARTE 1 — ESTRUCTURA DE DATOS

### 1.1 Tabla Principal: `inv_kardex_movimiento`

```sql
CREATE TABLE inv_kardex_movimiento (
  -- Identificación
  id                      BIGINT         PRIMARY KEY AUTO_INCREMENT,
  uuid                    CHAR(36)       NOT NULL UNIQUE,           -- Para APIs externas
  periodo                 CHAR(7)        NOT NULL,                  -- 'YYYY-MM'
  correlativo_kardex      BIGINT         NOT NULL,                  -- Correlativo interno por periodo+almacen+producto

  -- Fecha y hora (crítico para ordenamiento y recálculo)
  fecha_movimiento        DATE           NOT NULL,
  hora_movimiento         TIME(3)        NOT NULL DEFAULT CURRENT_TIME,
  fecha_hora_compuesta    DATETIME(3)    GENERATED ALWAYS AS        -- Campo calculado para ordenar
                          (CONCAT(fecha_movimiento,' ',hora_movimiento)) STORED,

  -- Documento fuente
  modulo_origen           VARCHAR(30)    NOT NULL,                  -- Ver Parte 3
  tipo_documento          CHAR(2)        NOT NULL,                  -- Tabla SUNAT (01=FAC, 03=BOL, etc.)
  serie_documento         VARCHAR(10)    NOT NULL,
  numero_documento        VARCHAR(20)    NOT NULL,
  anulado                 TINYINT(1)     NOT NULL DEFAULT 0,
  fecha_anulacion         DATE           NULL,
  motivo_anulacion        TEXT           NULL,

  -- Tipo de operación
  tipo_operacion          CHAR(1)        NOT NULL,                  -- 'E'=Entrada / 'S'=Salida
  motivo_traslado_sunat   CHAR(2)        NOT NULL,                  -- Tabla 12 SUNAT
  descripcion_movimiento  VARCHAR(255)   NOT NULL,

  -- Almacén
  almacen_id              INT            NOT NULL,
  almacen_origen_id       INT            NULL,                      -- Solo en traslados
  almacen_destino_id      INT            NULL,                      -- Solo en traslados

  -- Producto
  producto_id             INT            NOT NULL,
  unidad_medida_codigo    VARCHAR(10)    NOT NULL,                  -- Código SUNAT (KG, UND, LT...)
  factor_conversion       DECIMAL(18,6)  NOT NULL DEFAULT 1,        -- Si la UM difiere de la base

  -- Movimiento (columna ENTRADA)
  entrada_cantidad        DECIMAL(18,6)  NULL DEFAULT 0,
  entrada_costo_unitario  DECIMAL(18,6)  NULL DEFAULT 0,
  entrada_costo_total     DECIMAL(18,6)  NULL DEFAULT 0,            -- = entrada_cantidad * entrada_costo_unitario

  -- Movimiento (columna SALIDA)
  salida_cantidad         DECIMAL(18,6)  NULL DEFAULT 0,
  salida_costo_unitario   DECIMAL(18,6)  NULL DEFAULT 0,            -- Según método: promedio, PEPS, UEPS
  salida_costo_total      DECIMAL(18,6)  NULL DEFAULT 0,            -- = salida_cantidad * salida_costo_unitario

  -- Saldo resultante (se recalcula con cada movimiento)
  saldo_cantidad          DECIMAL(18,6)  NOT NULL DEFAULT 0,
  saldo_costo_unitario    DECIMAL(18,6)  NOT NULL DEFAULT 0,        -- Costo promedio del saldo
  saldo_costo_total       DECIMAL(18,6)  NOT NULL DEFAULT 0,        -- = saldo_cantidad * saldo_costo_unitario

  -- Trazabilidad
  referencia_id           BIGINT         NULL,                      -- ID de PO, OV, traslado...
  referencia_tipo         VARCHAR(30)    NULL,                      -- 'orden_compra','orden_venta'...
  lote_id                 BIGINT         NULL,                      -- Si aplica PEPS/UEPS
  proveedor_cliente_id    INT            NULL,
  observaciones           TEXT           NULL,

  -- Auditoría
  usuario_registro_id     INT            NOT NULL,
  usuario_anulacion_id    INT            NULL,
  created_at              DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at              DATETIME       NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  recalculado_at          DATETIME       NULL,                      -- Última vez que fue parte de un recálculo

  -- Índices críticos para rendimiento del recálculo
  INDEX idx_periodo_almacen_prod  (periodo, almacen_id, producto_id),
  INDEX idx_fecha_hora            (fecha_movimiento, hora_movimiento),
  INDEX idx_documento             (tipo_documento, serie_documento, numero_documento),
  INDEX idx_referencia            (referencia_id, referencia_tipo)
);
```

### 1.2 Tabla de Lotes PEPS/UEPS: `inv_kardex_lote`
> Solo necesaria si el método de valuación del producto es PEPS o UEPS.

```sql
CREATE TABLE inv_kardex_lote (
  id                    BIGINT        PRIMARY KEY AUTO_INCREMENT,
  producto_id           INT           NOT NULL,
  almacen_id            INT           NOT NULL,
  fecha_entrada         DATE          NOT NULL,
  hora_entrada          TIME(3)       NOT NULL,
  movimiento_origen_id  BIGINT        NOT NULL,                     -- FK a inv_kardex_movimiento
  costo_unitario        DECIMAL(18,6) NOT NULL,
  cantidad_original     DECIMAL(18,6) NOT NULL,
  cantidad_disponible   DECIMAL(18,6) NOT NULL,
  estado                CHAR(1)       NOT NULL DEFAULT 'A',         -- A=Activo, C=Consumido
  created_at            DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME      NOT NULL ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_prod_alm_fecha (producto_id, almacen_id, fecha_entrada, hora_entrada)
);
```

### 1.3 Tabla Producto: `inv_producto` (campos clave para el kardex)

```sql
-- Solo los campos relevantes al kardex:
metodo_valuacion        CHAR(2)  NOT NULL DEFAULT 'PP',  -- PP=Promedio, PE=PEPS, UE=UEPS
stock_minimo            DECIMAL(18,6),
stock_maximo            DECIMAL(18,6),
permite_stock_negativo  TINYINT(1) NOT NULL DEFAULT 0,   -- SUNAT: NO debe permitirse
unidad_medida_base      VARCHAR(10) NOT NULL,
```

---

## 🔢 PARTE 2 — FÓRMULAS Y MÉTODOS DE VALUACIÓN

> ⚠️ **Regla SUNAT**: El método elegido debe aplicarse **consistentemente** para todo
> el ejercicio y tipo de existencia. El cambio requiere autorización SUNAT.

---

### 2.1 MÉTODO PROMEDIO PONDERADO MÓVIL (el más común en Perú)

#### Al registrar una **ENTRADA**:
```
nuevo_saldo_cantidad    = saldo_anterior.cantidad    + entrada.cantidad
nuevo_saldo_costo_total = saldo_anterior.costo_total + (entrada.cantidad × entrada.costo_unitario)

SI nuevo_saldo_cantidad > 0:
    nuevo_costo_promedio = nuevo_saldo_costo_total / nuevo_saldo_cantidad
SINO:
    nuevo_costo_promedio = 0   ← reinicio de promedio

-- Guardar en el registro:
entrada_costo_total     = entrada.cantidad × entrada.costo_unitario
saldo_cantidad          = nuevo_saldo_cantidad
saldo_costo_unitario    = nuevo_costo_promedio
saldo_costo_total       = nuevo_saldo_costo_total
```

#### Al registrar una **SALIDA**:
```
-- El costo promedio NO cambia, se usa el vigente del saldo anterior
salida_costo_unitario   = saldo_anterior.costo_unitario   ← promedio vigente
salida_costo_total      = salida.cantidad × salida_costo_unitario

nuevo_saldo_cantidad    = saldo_anterior.cantidad    - salida.cantidad
nuevo_saldo_costo_total = saldo_anterior.costo_total - salida_costo_total

-- Guardar en el registro:
saldo_cantidad          = nuevo_saldo_cantidad
saldo_costo_unitario    = saldo_anterior.costo_unitario  ← no cambia
saldo_costo_total       = nuevo_saldo_costo_total
```

---

### 2.2 MÉTODO PEPS — Primeras Entradas, Primeras Salidas (FIFO)

#### Al registrar una **ENTRADA**:
```
-- Insertar nuevo lote en inv_kardex_lote:
INSERT lote(
    producto_id, almacen_id, fecha_entrada, hora_entrada,
    costo_unitario  = entrada.costo_unitario,
    cantidad_original  = entrada.cantidad,
    cantidad_disponible = entrada.cantidad,
    estado = 'A'
)

-- Saldo en kardex:
saldo_cantidad    = saldo_anterior.cantidad + entrada.cantidad
saldo_costo_total = saldo_anterior.costo_total + (entrada.cantidad × entrada.costo_unitario)
SI saldo_cantidad > 0:
    saldo_costo_unitario = saldo_costo_total / saldo_cantidad
```

#### Al registrar una **SALIDA**:
```
pendiente = salida.cantidad
costo_total_salida = 0

-- Consumir lotes ordenados por fecha_entrada ASC, hora_entrada ASC
PARA CADA lote EN lotes_disponibles (orden: más antiguo primero):
    SI lote.cantidad_disponible >= pendiente:
        consumido = pendiente
    SINO:
        consumido = lote.cantidad_disponible

    costo_total_salida += consumido × lote.costo_unitario
    lote.cantidad_disponible -= consumido
    SI lote.cantidad_disponible = 0: lote.estado = 'C'
    pendiente -= consumido
    SI pendiente = 0: SALIR

SI pendiente > 0:
    ERROR: 'Stock insuficiente en lotes PEPS'

salida_costo_unitario = costo_total_salida / salida.cantidad
salida_costo_total    = costo_total_salida
saldo_cantidad        = saldo_anterior.cantidad - salida.cantidad
saldo_costo_total     = saldo_anterior.costo_total - salida_costo_total
saldo_costo_unitario  = SI saldo_cantidad > 0: saldo_costo_total / saldo_cantidad SINO: 0
```

---

### 2.3 MÉTODO UEPS — Últimas Entradas, Primeras Salidas (LIFO)
> Igual que PEPS pero invirtiendo el orden de consumo de lotes.
```
-- Consumir lotes ordenados por fecha_entrada DESC, hora_entrada DESC
```

---

### 2.4 VALIDACIONES OBLIGATORIAS (todos los métodos)
```
-- 1. Nunca permitir saldo negativo (salvo configuración especial)
SI (saldo_anterior.cantidad - salida.cantidad) < 0 Y NOT producto.permite_stock_negativo:
    LANZAR ERROR 'Stock insuficiente. Saldo: X, Solicitado: Y'

-- 2. Cuadre del saldo monetario
ASSERT: saldo_costo_total = saldo_anterior.costo_total
                           + entrada_costo_total
                           - salida_costo_total
TOLERANCIA: ± 0.01 soles (diferencia por redondeo)

-- 3. Costo unitario nunca negativo
ASSERT: entrada_costo_unitario >= 0
ASSERT: salida_costo_unitario  >= 0
```

---

## 🔄 PARTE 3 — CÁLCULO Y RECÁLCULO DEL KARDEX

### 3.1 CÁLCULO INICIAL (proceso normal)

El cálculo se ejecuta **secuencialmente** al registrar cada movimiento:

```
1. Obtener el último registro del kardex para (almacen_id, producto_id)
   → saldo_anterior = SELECT ... ORDER BY fecha_hora_compuesta DESC, id DESC LIMIT 1

2. Aplicar fórmula según método de valuación del producto

3. Guardar el nuevo registro con saldos calculados

4. Si PEPS/UEPS: actualizar tabla inv_kardex_lote
```

---

### 3.2 RECÁLCULO DEL KARDEX

El recálculo es necesario cuando se altera el **orden cronológico** de los movimientos
ya registrados. Implica **recorrer y reescribir** todos los saldos desde el punto
de quiebre hasta el final del periodo.

#### 🚨 EVENTOS QUE DISPARAN EL RECÁLCULO:

| Evento | Descripción | Alcance del recálculo |
|--------|-------------|----------------------|
| **Inserción con fecha pasada** | Se ingresa un movimiento con fecha anterior al último registrado | Desde la fecha del nuevo registro hasta fin del periodo |
| **Anulación de movimiento** | Se anula un documento ya registrado en el kardex | Desde la fecha del movimiento anulado hasta fin del periodo |
| **Modificación de costo** | Se modifica el costo de una factura de compra ya contabilizada (ej: llega la factura definitiva) | Desde la fecha del movimiento modificado |
| **Nota de débito/crédito al proveedor** | Ajuste de precio que modifica el costo original de la entrada | Desde la fecha de la entrada original |
| **Corrección de cantidad** | Ajuste de inventario físico aprobado con fecha retroactiva | Desde la fecha del ajuste |
| **Cambio de método de valuación** | Solo autorizado por SUNAT, reemplaza todo el kardex del ejercicio | Todo el periodo fiscal |
| **Cierre y reapertura de periodo** | Correcciones contables aprobadas en periodo cerrado | Desde la fecha de la corrección |

---

#### 🛠️ ALGORITMO DE RECÁLCULO:

```
FUNCIÓN recalcular_kardex(almacen_id, producto_id, desde_fecha, desde_hora):

    -- PASO 1: Obtener saldo ANTERIOR al punto de quiebre
    saldo_base = SELECT saldo_cantidad, saldo_costo_unitario, saldo_costo_total
                 FROM inv_kardex_movimiento
                 WHERE almacen_id = ? AND producto_id = ?
                   AND (fecha_movimiento < desde_fecha
                     OR (fecha_movimiento = desde_fecha AND hora_movimiento < desde_hora))
                   AND anulado = 0
                 ORDER BY fecha_hora_compuesta DESC, id DESC
                 LIMIT 1

    SI NO saldo_base: saldo_base = {cantidad: 0, costo_unitario: 0, costo_total: 0}

    -- PASO 2: Obtener TODOS los movimientos desde el punto de quiebre, en orden
    movimientos = SELECT *
                  FROM inv_kardex_movimiento
                  WHERE almacen_id = ? AND producto_id = ?
                    AND (fecha_movimiento > desde_fecha
                      OR (fecha_movimiento = desde_fecha AND hora_movimiento >= desde_hora))
                  ORDER BY fecha_hora_compuesta ASC, id ASC
                  FOR UPDATE  ← bloquear filas

    -- PASO 3: Recalcular secuencialmente
    saldo_actual = saldo_base

    PARA CADA movimiento EN movimientos:
        SI movimiento.anulado = 1:
            CONTINUAR  ← los anulados no afectan saldo pero mantienen registro

        SI movimiento.tipo_operacion = 'E':
            [aplicar fórmula de ENTRADA según método]
        SINO SI movimiento.tipo_operacion = 'S':
            [aplicar fórmula de SALIDA según método]

        -- Actualizar el registro en BD
        UPDATE inv_kardex_movimiento SET
            salida_costo_unitario = ...,
            salida_costo_total    = ...,
            saldo_cantidad        = saldo_actual.cantidad,
            saldo_costo_unitario  = saldo_actual.costo_unitario,
            saldo_costo_total     = saldo_actual.costo_total,
            recalculado_at        = NOW()
        WHERE id = movimiento.id

    -- PASO 4: Si PEPS/UEPS, reconstruir tabla de lotes desde el punto de quiebre
    SI producto.metodo_valuacion IN ('PE','UE'):
        reconstruir_lotes(almacen_id, producto_id, desde_fecha)

    -- PASO 5: Registrar en bitácora
    INSERT INTO inv_kardex_recalculo_log(...)

FIN FUNCIÓN
```

---

#### 📋 Tabla de Bitácora: `inv_kardex_recalculo_log`

```sql
CREATE TABLE inv_kardex_recalculo_log (
  id               BIGINT      PRIMARY KEY AUTO_INCREMENT,
  almacen_id       INT         NOT NULL,
  producto_id      INT         NOT NULL,
  desde_fecha      DATE        NOT NULL,
  motivo           VARCHAR(100) NOT NULL,  -- 'ANULACION','INSERCION_RETROACTIVA','AJUSTE_COSTO'...
  registros_afect  INT         NOT NULL,
  usuario_id       INT         NOT NULL,
  duracion_ms      INT,
  created_at       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📦 PARTE 4 — CLASIFICACIÓN DE COMPROBANTES Y MÓDULOS

### 4.1 Tipos de Comprobante SUNAT y su efecto en el kardex

| Código SUNAT | Nombre | Módulo | Tipo Op. Kardex | Motivo SUNAT |
|:---:|---|---|:---:|:---:|
| **01** | Factura | Compras / Ventas | E o S | 02 / 01 |
| **03** | Boleta de Venta | Ventas | S | 01 |
| **04** | Liquidación de compra | Compras | E | 02 |
| **07** | Nota de Crédito | Dev. Compras / Dev. Ventas | S o E | 02 / 01 |
| **08** | Nota de Débito | Compras / Ventas | E o S | 02 / 01 |
| **09** | Guía de Remisión Remitente | Traslados | E y S | 04 |
| **12** | Ticket de Máquina Registradora | Ventas | S | 01 |
| **20** | Comprobante de Retención | — | Sin efecto | — |
| **31** | Guía de Remisión Transportista | Traslados | Referencial | 04 |
| **50** | Declaración Única de Aduanas | Importaciones | E | 08 |
| **52** | Despacho Simplificado | Importaciones | E | 08 |
| **XX** | Orden de Producción (interno) | Producción | E o S | 13 |
| **XX** | Ajuste de Inventario (interno) | Inventarios | E o S | 13 |

---

### 4.2 Módulos del Sistema y su comportamiento en el Kardex

---

#### 🛒 MÓDULO: COMPRAS
```
Comprobantes: Factura (01), Boleta (03), Liquidación de Compra (04), DUA (50)
Tipo Operación Kardex: ENTRADA (E)
Motivo SUNAT: 02 (Compra)

Flujo:
  Orden de Compra → Recepción en Almacén → [GENERA KARDEX ENTRADA]
                                          ↘ Registro de Factura vinculada

Costo unitario = (Precio compra + Flete + Seguros + Gastos aduaneros) / Cantidad
                 ← costo de adquisición según NIC 2

¿Cuándo genera kardex?
  → Al confirmar la RECEPCIÓN física en almacén (no al registrar la factura)
  → La factura puede llegar después; en ese caso disparar RECÁLCULO si el costo difiere
```

---

#### 💳 MÓDULO: DEVOLUCIÓN DE COMPRAS
```
Comprobantes: Nota de Crédito al proveedor (07)
Tipo Operación Kardex: SALIDA (S)
Motivo SUNAT: 02

Flujo:
  Solicitud devolución → Guía de Remisión → Nota de Crédito → [GENERA KARDEX SALIDA]

Costo unitario de la salida = costo de la entrada original que se devuelve
  → Buscar en kardex la entrada original por referencia_id = recepcion_original_id
  → Usar ese costo_unitario exacto (no el promedio actual)
  → Esto DISPARA RECÁLCULO si ya hay movimientos posteriores con ese producto
```

---

#### 🛍️ MÓDULO: VENTAS
```
Comprobantes: Factura (01), Boleta (03), Ticket (12)
Tipo Operación Kardex: SALIDA (S)
Motivo SUNAT: 01 (Venta)

Flujo:
  Pedido → Picking → Despacho → [GENERA KARDEX SALIDA] → Emisión comprobante

Costo unitario de la salida:
  → Promedio Ponderado: usar saldo_costo_unitario actual
  → PEPS: consumir lotes más antiguos
  → UEPS: consumir lotes más recientes
```

---

#### 🔄 MÓDULO: DEVOLUCIÓN DE VENTAS
```
Comprobantes: Nota de Crédito al cliente (07)
Tipo Operación Kardex: ENTRADA (E)
Motivo SUNAT: 01

REGLA IMPORTANTE:
  El costo de reingreso = costo al que fue despachado originalmente
  → NO es el costo de compra, es el costo de salida de la venta original
  → Buscar en kardex la salida original: referencia_id = venta_original_id

¿Qué hacer si el bien devuelto está deteriorado?
  → Registrar entrada al costo original y luego un AJUSTE DE INVENTARIO
    con baja de valor al precio neto realizable (NIC 2)
```

---

#### 🔁 MÓDULO: TRASLADOS ENTRE ALMACENES
```
Comprobantes: Guía de Remisión (09)
Tipo Operación Kardex:
  → Almacén ORIGEN: SALIDA (S) | Motivo: 04
  → Almacén DESTINO: ENTRADA (E) | Motivo: 04

Costo de la entrada en destino = costo de la salida en origen
  (el traslado no genera ganancia ni pérdida)

Se generan DOS registros de kardex atómicamente (transacción).
```

---

#### 🏭 MÓDULO: PRODUCCIÓN / MANUFACTURA
```
Comprobantes: Orden de Producción (interno), Hoja de Costos
Tipo Operación Kardex:
  → Materias Primas/Insumos:   SALIDA (S) | Motivo: 13
  → Producto Terminado:        ENTRADA (E) | Motivo: 13

Costo del producto terminado:
  Costo_PT = Σ(costo_materia_prima) + Mano_de_Obra_Directa + Costos_Indirectos_Fab
```

---

#### 📋 MÓDULO: INVENTARIO FÍSICO / AJUSTES
```
Comprobantes: Acta de Inventario (interno), aprobada por Gerencia
Tipo Operación Kardex:
  → Sobrante (físico > kardex): ENTRADA (E) | Motivo: 13
  → Faltante (físico < kardex): SALIDA (S)  | Motivo: 13

Costo del ajuste:
  → Usar costo promedio vigente del kardex
  → El ajuste DISPARA RECÁLCULO de todos los movimientos posteriores en el periodo

REQUERIMIENTO:
  → Requiere aprobación de usuario con rol 'APROBADOR_INVENTARIO'
  → Genera asiento contable automático de pérdida/ganancia en inventario
```

---

#### 📤 MÓDULO: EXPORTACIONES
```
Comprobantes: Declaración Aduanera de Mercancías (50/52)
Tipo Operación Kardex: SALIDA (S) | Motivo: 09
Costo: igual que venta normal, al costo promedio o PEPS vigente
```

---

## 🔧 PARTE 5 — REGLAS DE IMPLEMENTACIÓN PARA ANTIGRAVITY

### 5.1 Patrón de Servicio recomendado

```
KardexService
  ├── registrarEntrada(dto: KardexEntradaDTO): KardexMovimiento
  ├── registrarSalida(dto: KardexSalidaDTO): KardexMovimiento
  ├── anularMovimiento(id, motivo, usuario): void        → dispara recálculo
  ├── recalcularDesde(almacenId, productoId, desde): RecalculoResult
  ├── obtenerSaldoActual(almacenId, productoId): Saldo
  └── generarReporteKardex(filtros): KardexReporte[]
```

### 5.2 Control de concurrencia (crítico)

```
Al calcular/recalcular el kardex de un producto:
  → Usar bloqueo pesimista (SELECT ... FOR UPDATE) sobre la combinación
    (almacen_id, producto_id) para evitar condiciones de carrera
  → Envolver TODO el proceso en una transacción de BD
  → En caso de error: ROLLBACK completo, sin estados intermedios
```

### 5.3 Campos de control de periodo

```sql
-- Tabla de control de periodos cerrados (no permite movimientos sin recálculo aprobado)
CREATE TABLE inv_kardex_periodo_control (
  periodo         CHAR(7)  PRIMARY KEY,  -- 'YYYY-MM'
  estado          CHAR(1)  NOT NULL,     -- 'A'=Abierto, 'C'=Cerrado, 'B'=Bloqueado
  fecha_cierre    DATE     NULL,
  usuario_cierre  INT      NULL
);
```

### 5.4 Precisión decimal

```
- Cantidades:       6 decimales (para mercancías con fraccionamiento)
- Costos unitarios: 6 decimales (evitar error de redondeo acumulado)
- Costos totales:   6 decimales, presentación con 2
- Tolerancia de cuadre: ±0.01 soles
```

### 5.5 Motivos de Traslado SUNAT (Tabla 12)

| Código | Descripción |
|:---:|---|
| 01 | Venta |
| 02 | Compra |
| 04 | Traslado entre establecimientos de la misma empresa |
| 08 | Importación |
| 09 | Exportación |
| 11 | Traslado a zona primaria aduanera |
| 13 | Otros (ajustes, producción, muestras, etc.) |

---

## ✅ PARTE 6 — CHECKLIST DE IMPLEMENTACIÓN

Antes de dar por terminado el módulo, verificar:

- [ ] El kardex se ordena siempre por `fecha_hora_compuesta ASC, id ASC`
- [ ] Las salidas usan el costo promedio o lote vigente **en el momento** de la salida
- [ ] El recálculo corre dentro de una transacción atómica con bloqueo pesimista
- [ ] Los movimientos anulados no afectan saldos pero permanecen en el historial
- [ ] El sistema **no permite** saldo negativo en cantidad (salvo config especial)
- [ ] Las devoluciones (compra/venta) usan el costo de la transacción original
- [ ] Los traslados generan dos registros atómicos (salida + entrada)
- [ ] Hay bitácora de todos los recálculos ejecutados
- [ ] El reporte cumple con los campos mínimos del Registro SUNAT:
      fecha, tipo/serie/número documento, tipo operación,
      entrada (cant+costo), salida (cant+costo), saldo (cant+costo)
- [ ] Los periodos cerrados están bloqueados para modificaciones no aprobadas
- [ ] La precisión de redondeo es consistente en toda la cadena de cálculo

---

*Documento generado para Antigravity ERP — Sistema de Inventarios y Almacenes*
*Normativa vigente: SUNAT Perú | NIC 2 | LIR Art. 62°*
