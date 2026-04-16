# Sesión: Sincronización y Normalización del Kardex
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Inventario.API, ERP Integración
**Modelo de IA usado:** Antigravity (Gemini 3.5 Sonnet equivalent)

---

## Objetivo de la sesión
Reparar la sincronización histórica del Kardex, resolviendo duplicados en notas de crédito de ventas y asegurando un orden cronológico coherente mediante la normalización de horas comerciales.

## Tareas completadas
- [x] Limpieza total de movimientos históricos ("Sincronización histórica") para garantizar idempotencia.
- [x] Unificación de Compras, Ventas y Notas en un solo flujo cronológico.
- [x] Normalización de horas: Compras (08:00 AM), Ventas (10:00 AM), Notas (12:00-02:00 PM).
- [x] Resolución de error `23503` (FK violation) mediante remapeo dinámico de almacenes.
- [x] Habilitación de stock negativo para permitir reconstrucción de historial con baches.
- [x] Verificación exitosa de saldos y orden en reporte de Kardex.

## Tareas pendientes
- [ ] Validar el recálculo retroactivo ante anulaciones manuales fuera del proceso de sincronización.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `SincronizarComprasHistManejador.cs` | UPDATE | Refactor total del flujo de sincronización, detección dinámica de almacenes y remapeo de integridad. |
| `CrearMovimientoInventarioManejador.cs` | UPDATE | Soporte para el flag `PermitirStockNegativo`. |
| `KardexSyncTool/Program.cs` | UPDATE | Herramienta de scratch mejorada con diagnósticos de integridad y listado de resultados. |
| `tasks/lessons.md` | UPDATE | Documentación de lecciones sobre Dapper mapping y remapeo de FKs. |
| `tasks/todo.md` | UPDATE | Registro de la Fase 12 como completada. |

## Correcciones recibidas del usuario
- El usuario recordó el cumplimiento de la gestión de la carpeta `tasks/` según `GEMINI.md`. Registrado preliminarmente en `lessons.md` (aunque fue una corrección de proceso, no técnica).

## Decisiones tomadas
- Se decidió forzar los movimientos a un **Almacén Principal** si el ID fuente es inválido, para priorizar la integridad física del inventario sobre errores de datos del ERP externo.

## Notas y observaciones
La sincronización ahora es robusta y puede ejecutarse múltiples veces de forma segura.
