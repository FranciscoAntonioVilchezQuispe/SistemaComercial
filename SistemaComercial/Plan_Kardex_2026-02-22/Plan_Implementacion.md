# Plan de Implementación: Módulo Kardex Valorizado (SUNAT)

**Fecha:** 22 de Febrero de 2026
**Proyecto:** Sistema Comercial

Este plan de implementación está diseñado para adoptar el Kardex Valorizado de forma progresiva, garantizando que el sistema actual no colapse mientras se introducen los estrictos requerimientos de la SUNAT y la NIC 2. El enfoque recomendado es **"Bottom-Up"** (de Base de Datos hacia Frontend).

---

## FASE 1: Fundación y Modelo de Datos (Base de Datos)

**Objetivo:** Extender las entidades actuales y crear las nuevas tablas necesarias para soportar el Kardex, sin romper las consultas de stock actuales.

1.  **Modificar Catálogo (`Producto.cs`):**
    - Agregar propiedad `MetodoValuacion` (PP, PE, UE) - por defecto "PP" (Promedio Ponderado).
    - Generar migración inicial en `Catalogo.API`.

2.  **Crear entidad nueva `KardexMovimiento.cs` (en `Inventario.API/Domain/Entities/Kardex/`):**
    - `MovimientoInventario.cs` **NO se toca** para el Kardex. Debe quedar intacta para no romper el CRUD actual de stock.
    - Es independiente de `MovimientoInventario.cs`.
    - Se vincula opcionalmente vía `ReferenciaId` + `ReferenciaTipo` (ej. `movimiento_inventario`).
    - Contiene todos los campos fiscales, de costo y de saldo del Kardex.
    - Ver especificación completa de campos en `PROMPT_KARDEX_ANTIGRAVITY.md` (Fase 1).

3.  **Crear Nuevas Entidades (Kardex Avanzado):**
    - `KardexLote.cs`: Para manejar los saldos específicos por lote de entrada (exigido por PEPS/UEPS).
    - `KardexPeriodoControl.cs`: Para controlar la apertura y cierre de meses contables (`Periodo`, `Estado`, `FechaCierre`).
    - `KardexRecalculoLog.cs`: Bitácora obligatoria para registrar quién y cuándo disparó un recálculo masivo del pasado. Tabla PostgreSQL `inv_kardex_recalculo_log`. **Campos obligatorios:**
      - `Id` (long, PK, autoincrement)
      - `AlmacenId` (int, not null)
      - `ProductoId` (int, not null)
      - `DesdeFecha` (DateOnly, not null) -- punto de quiebre del recálculo
      - `Motivo` (string(30), not null) -- ENUM de texto: 'ANULACION', 'INSERCION_RETROACTIVA', 'AJUSTE_COSTO_FACTURA', 'NOTA_DEBITO_PROVEEDOR', 'CORRECCION_CANTIDAD', 'CAMBIO_METODO_VALUACION', 'REAPERTURA_PERIODO'
      - `RegistrosAfect` (int, not null) -- cuántos registros fueron reescritos
      - `UsuarioId` (int, not null)
      - `DuracionMs` (int, nullable) -- para monitoreo de performance
      - `CreatedAt` (DateTime, not null, default UTC now)
    - Generar migración en `Inventario.API`.

4.  **Generación de Scripts SQL (.sql):**
    - Acompañar cada migración de Entity Framework Core con la generación de su respectivo script SQL puro.
    - Definir los índices críticos de base de datos en los scripts (`idx_periodo_almacen_prod`, `idx_fecha_hora`, `idx_documento`).
    - Almacenar los scripts generados en una carpeta designada (ej. `ScriptsBD/Kardex`) para revisión y fácil ejecución en los despliegues a producción.

---

## FASE 2: Motor Base (Lógica de Negocio y Recálculo)

**Objetivo:** Desarrollar el corazón del Kardex, capaz de determinar costos promedios y recalcular el pasado frente a movimientos retroactivos.

1.  **`KardexService` (Cálculo Lineal):**
    - Implementar método `RegistrarEntrada`: Toma el costo base + flete/impuestos (gastos aduaneros) y promedia con el saldo unitario existente.
    - Implementar método `RegistrarSalida`: Emite al costo promedio del último momento (o consume lotes si es PEPS/UEPS).
    - **Validaciones obligatorias (aplicar en RegistrarEntrada Y RegistrarSalida):**
      1. **CONTROL DE SALDO NEGATIVO:** Si `(saldo_anterior.cantidad - salida.cantidad) < 0` Y `producto.PermiteStockNegativo = false` → Lanzar excepción de dominio: "Stock insuficiente. Saldo disponible: {X}, Cantidad solicitada: {Y}".
      2. **CUADRE MONETARIO DEL SALDO:** Después de cada movimiento, verificar: `saldo_costo_total` debe ser ≈ `(saldo_anterior.costo_total + entrada_costo_total - salida_costo_total)`. Tolerancia máxima: ±0.01 soles (diferencia aceptable por redondeo). Si la diferencia supera ±0.01 → lanzar excepción de integridad contable.
      3. **COSTO UNITARIO NUNCA NEGATIVO:** Assert `entrada_costo_unitario >= 0` y `salida_costo_unitario >= 0`. Si alguno es negativo → rechazar la operación antes de persistir.

2.  **Implementar Control de Concurrencia:**
    - Aplicar bloqueos a nivel de transacciones SQL (`FOR UPDATE` en PostgreSQL/MySQL o `UPDLOCK` en SQL Server) por la llave `AlmacenId + ProductoId` para evitar carreras al actualizar el costo promedio en el Kardex.

3.  **El Motor de Recálculo (`KardexRecalculoService.cs`):**
    - Implementar el algoritmo secuencial: Recibe un `AlmacenId`, `ProductoId` y un `PuntoDeQuiebre` (fecha/hora).
    - Debe barrer todos los registros posteriores al quiebre, reescribiendo el saldo cantidad y el saldo costo unitario paso a paso, guardando en BD.
    - El servicio debe recibir el evento como parámetro enum (`Motivo`) y determinar automáticamente el alcance del recálculo **según esta tabla (los 7 eventos que obligan a recalcular)**:
      | # | Evento disparador | Alcance del recálculo |
      |---|---|---|
      | 1 | Inserción con fecha pasada | Desde fecha del nuevo registro hasta fin de periodo |
      | 2 | Anulación de un movimiento | Desde fecha del movimiento anulado hasta fin de periodo |
      | 3 | Modificación de costo de factura (llega factura definitiva con precio diferente) | Desde fecha de la recepción original |
      | 4 | Nota de Débito/Crédito al proveedor que ajusta costo original | Desde fecha de la entrada original |
      | 5 | Corrección de cantidad con fecha retroactiva (inventario físico) | Desde fecha del ajuste |
      | 6 | Cambio de método de valuación (autorizado SUNAT) | Todo el periodo fiscal completo |
      | 7 | Reapertura de periodo cerrado con corrección aprobada | Desde fecha de la corrección |
    - **Paso adicional del recálculo para métodos PEPS/UEPS:**
      Si el producto tiene `MetodoValuacion = 'PE'` o `'UE'`:
      → Además de reescribir `inv_kardex_movimiento`, se debe reconstruir `inv_kardex_lote` desde el punto de quiebre:
      1. Eliminar (o marcar como inválidos) los lotes creados desde `desde_fecha`
      2. Regenerar los lotes recorriendo los movimientos en orden cronológico
      3. Reconsumir las salidas contra los lotes regenerados (FIFO o LIFO según método)
         → Este paso corre dentro de la misma transacción del recálculo principal
         → Para la Fase 2 (solo PP) este paso no aplica, pero debe estar previsto en la arquitectura del servicio como método virtual o extensión.

---

## FASE 3: API, Seguridad y Cierres Contables

**Objetivo:** Exponer la funcionalidad de manera segura y bloquear periodos para evitar alteraciones contables ilegales.

1.  **Interceptor de Periodos Contables:**
    - Validación global (Action Filter o Domain Event) que rechace cualquier operación DML en el `KardexMovimiento` si el `Periodo` (ej. '2026-02') está en estado "Cerrado" (`C`).

2.  **Nuevos Endpoints (Inventario.API):**
    - `POST /api/kardex/ajuste`: Permite ingresos de sobrantes o salidas de faltantes directos.
    - `POST /api/kardex/recalcular`: (Solo admin/conta) Permite forzar un recálculo sobre un ítem.
    - `GET /api/kardex/reporte/{almacen}/{producto}?mes=YYYY-MM`: Genera la data cruda del Formato 13.1.
    - Endpoints CRUD para manejar apertura y cierre de periodos en `KardexPeriodoControl`.

---

## FASE 4: Refactorización de Integraciones (Compras, Ventas, Traslados)

**Objetivo:** Modificar los módulos operacionales existentes para que emitan los datos exactos que exige el Kardex.

1.  **Refactorizar Compras (`Compras.API`):**
    - Al recepcionar material, deberá enviar los datos del comprobante (Factura - 01) o de lo contrario crear el movimiento inicial y "actualizar_costo" (con recálculo) cuando ingrese la factura definitiva.
    - _Caso Crítico:_ En las Devoluciones al Proveedor, se debe obtener el costo original con el que entró.

2.  **Refactorizar Ventas:**
    - Asegurar que envíe el Motivo de Traslado 01 (Venta).
    - _Caso Crítico:_ En las Notas de Crédito (Devolución de cliente), la mercancía entra al mismo costo de venta histórico, NO al costo promedio actual.

3.  **Refactorizar Traslados entre Almacenes:**
    - Asegurar la creación "Atómica" (Transaccional) del movimiento Salida (Origen) y el movimiento Entrada (Destino) bajo el Motivo de Traslado 04.

4.  **Módulo Exportaciones:**
    - Comprobante: Declaración Aduanera de Mercancías (tipo 50 o 52)
    - Tipo Operación Kardex: SALIDA (S)
    - Motivo SUNAT: 09 (Exportación)
    - Costo de salida: igual que venta normal (costo promedio vigente o PEPS)
    - Diferencia con Ventas: el tipo de documento es 50/52, no 01/03

5.  **Módulo Producción / Manufactura:**
    - Comprobante: Orden de Producción (tipo interno XX)
    - Genera DOS tipos de movimiento kardex en la misma transacción:
      a) Materias Primas / Insumos → SALIDA (S) | Motivo: 13
      b) Producto Terminado → ENTRADA (E) | Motivo: 13
    - Costo del Producto Terminado (fórmula NIC 2):
      `Costo_PT = Σ(costo_materia_prima consumida) + Mano_de_Obra_Directa + Costos_Indirectos_Fabricación`
    - Este módulo requiere coordinación con el módulo de Costos si existe, o entrada manual de MOD y CIF si no está automatizado.

---

## FASE 5: Reporte SUNAT e Interfaz Frontend (UI)

**Objetivo:** Entregar las pantallas requeridas para la usabilidad comercial y contable.

1.  **Pantalla de Vista Kardex (Formato 13.1):**
    - Crear tabla en React mostrando el flujo de entradas (Cantidad, Costo Unit., Total) y salidas, junto a los saldos finales por día.
    - Implementar botón que exporte este grid exactamente al formato XLS normado por SUNAT.

2.  **Pantallas de Administración Contable:**
    - Interfaz para "Apertura / Cierre de Mes Contable".
    - **Pantalla de Ajustes de Inventario Físico**
      - El ajuste tiene un flujo de estados obligatorio: `[BORRADOR] → [PENDIENTE_APROBACION] → [APROBADO] → [RECHAZADO]`.
      - Reglas del flujo:
        - Usuario con rol `REGISTRADOR_INVENTARIO` puede crear y enviar a aprobación.
        - Usuario con rol `APROBADOR_INVENTARIO` puede aprobar o rechazar.
        - Un usuario NO puede aprobar su propio ajuste.
        - El recálculo del Kardex se dispara SOLO al pasar a estado `APROBADO`.
        - Un ajuste `RECHAZADO` no genera ningún movimiento en el Kardex.
        - Al aprobar → genera automáticamente el asiento contable de pérdida o ganancia en inventario (coordinar con módulo Contabilidad).
        - Los ajustes aprobados son inmutables: no se editan, se anulan y se crea uno nuevo si hay error.
