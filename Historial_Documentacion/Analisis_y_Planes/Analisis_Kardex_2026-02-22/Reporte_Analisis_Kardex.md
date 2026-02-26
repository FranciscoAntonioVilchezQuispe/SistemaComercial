# Informe de Viabilidad: Módulo Kardex Valorizado

**Fecha de Análisis:** 22 de Febrero de 2026
**Proyecto:** Sistema Comercial

A continuación, se presenta el análisis del documento `PROMPT_KARDEX_ANTIGRAVITY.md` en comparación con la estructura actual del proyecto (`Inventario.API`, `Catalogo.API`).

## 1. ¿Es posible realizar la implementación adaptando lo ya implementado?

**Sí, es totalmente viable.** La arquitectura actual del proyecto proporciona una base sólida para extender las funcionalidades e integrar el Kardex Valorizado normado por la SUNAT.

Actualmente, el backend ya posee entidades clave como `Stock.cs`, `MovimientoInventario.cs` y `Producto.cs`, las cuales fueron diseñadas contemplando cantidades, costos promedios y valorizaciones. La adaptación no requiere destruir lo existente, sino **extender las columnas** de las tablas actuales e **introducir nuevos servicios** de lógica de negocio (como el mecanismo de recálculo retroactivo y el manejo de lotes si aplicara).

---

## 2. Porcentaje de Implementación Actual

Estimación global de avance respecto a lo solicitado por el prompt: **~30% implementado / 70% faltante.**

### Desglose del Porcentaje:

- **Estructura de Producto (80%):** Ya contamos con el catálogo, unidades de medida, configuración de impuestos y un flag de `PermiteInventarioNegativo`.
- **Estructura Base de Movimientos (40%):** La tabla `MovimientoInventario` ya gestiona referencias (ID documento, módulo), saldos de cantidad, costo unitario del movimiento y el valorizado del saldo (`CostoPromedioActual`, `SaldoValorizado`).
- **Método Promedio Ponderado (35%):** El sistema actual parece estar diseñado implícitamente para calcular un costo promedio móvil en base a la entidad `Stock` y sus movimientos, pero carece de las estrictas reglas del algoritmo propuesto en el prompt.
- **Lógica de Recálculo Retroactivo (0%):** El backend no posee un motor para recalcular costos y saldos de forma recursiva cuando se inserta o anula un movimiento con fecha pasada.
- **Métodos PEPS / UEPS y Lotes (0%):** No existe la tabla de `inv_kardex_lote` ni lógica para gestionar consumos de lotes FIFO/LIFO.
- **Manejo Documentario Fiscal SUNAT (0%):** En `MovimientoInventario` faltan los campos específicos (Tipo Documento SUNAT, Serie, Número, Motivo de Traslado Tabla 12).
- **Control de Periodos (0%):** Carece de una tabla o lógica de cierres de periodo mensual para evitar modificaciones.

---

## 3. ¿Qué estaría faltando implementar?

Para cumplir con el **100%** del Prompt Maestro, se debe desarrollar lo siguiente:

### A. Modificaciones en Base de Datos (Migraciones Entity Framework)

1.  **En `MovimientoInventario.cs` (Kardex):**
    - Renombrar conceptualmente o adaptar para que funcione como Kardex.
    - Agregar campos SUNAT: `Periodo` (YYYY-MM), `TipoDocumento` (01, 03, etc.), `SerieDocumento`, `NumeroDocumento`.
    - Agregar campos de auditoría contable: `MotivoTrasladoSunat`, `TipoOperacion` (E/S).
    - Agregar columnas separadas de Entrada/Salida (opcional si se maneja por tipo de operación, pero el prompt lo exige: `entrada_cantidad`, `entrada_costo_unitario`, `salida_cantidad`, etc.).
    - Cálculo de `FechaHoraCompuesta` para el orden estricto, o separar `Fecha` y `Hora` del movimiento.
2.  **En `Producto.cs`:**
    - Añadir el campo `MetodoValuacion` (PP, PE, UE).
3.  **Nuevas Tablas:**
    - Crear `KardexLote` (para soportar PEPS/UEPS si el negocio lo requiere).
    - Crear `KardexPeriodoControl` (para abrir/cerrar meses).
    - Crear `KardexRecalculoLog` (bitácora de auditoría para operaciones retroactivas).

### B. Lógica de Negocio (Backend)

1.  **Servicio de Recálculo (Crucial):**
    - Implementar el algoritmo `recalcular_kardex()` que se detalla en el prompt. Deberá recorrer, mediante bloqueos de base de datos (`FOR UPDATE` equivalentes en EF Core usando transacciones), los movimientos afectados por una inserción o anulación retroactiva y ajustar los costos de ahí en adelante.
2.  **Gestión Transaccional Extrema:**
    - Garantizar que toda operación de inventario bloquee la combinación `(IdAlmacen, IdProducto)` momentáneamente para evitar condiciones de carrera en alta concurrencia.
3.  **Control de Periodos:**
    - Interceptor o validación que impida generar un movimiento si la variable `Periodo` aparece etiquetada como "Cerrado" en la tabla de control.

### C. Frontend

1.  **Reporte Formato SUNAT (Formato 13.1):**
    - Desarrollar la interfaz para consultar el Kardex Valorizado exportable a Excel/PDF conteniendo exactamente las columnas que pide SUNAT.
2.  **Pantallas de Ajuste e Inventario Físico:**
    - Módulos para ingresar ajustes manuales de sobra/falta y operaciones con motivos de traslado atípicos.
