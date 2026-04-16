# Sesión: Normalización Horaria Estricta y Eliminación de Saldos Negativos
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Inventario.API
**Modelo de IA usado:** Antigravity

---

## Objetivo de la sesión
Eliminar los saldos negativos ficticios en el reporte de Kardex forzando el uso de ventanas horarias comerciales (08:00 compras, 10:00 ventas) de forma incondicional, incluso si el documento original del ERP ya tiene una hora diferente.

## Tareas completadas
- [x] Modificar `EventoSync` en `SincronizarComprasHistManejador` para ignorar la hora real y forzar la ventana horaria correspondiente.
- [x] Ajustar `CrearMovimientoInventarioManejador` para aplicar la misma normalización estricta en el registro de movimientos nuevos.
- [x] Restaurar y consolidar la secuencialidad por segundos para ventas dentro del bloque de las 10:00 AM.
- [x] Actualizar `KardexMovimientoRepositorio` para incluir `hora_movimiento` en el ordenamiento de listados y reportes.
- [x] Ejecución de sincronización histórica con validación de integridad de saldos.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `SincronizarComprasHistManejador.cs` | UPDATE | Normalización incondicional de horas y desfase de segundos. |
| `CrearMovimientoInventarioManejador.cs` | UPDATE | Normalización estricta en tiempo real (08:00/10:00). |
| `KardexMovimientoRepositorio.cs` | UPDATE | Soporte para ordenamiento por hora en consultas Dapper. |

## Notas y observaciones
Se identificó que el reporte mostraba ventas antes que compras en el mismo día debido a que algunos documentos traían horas reales (ej. 15:00) posteriores al bloque normalizado de ventas (10:00). Al forzar la normalización estricta, se garantiza que los ingresos siempre precedan a las salidas, estabilizando los cálculos de costos y saldos.
