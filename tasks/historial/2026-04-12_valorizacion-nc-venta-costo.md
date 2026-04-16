# Sesión: Valorización de Notas de Crédito al Costo Promedio
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Inventario.API
**Modelo de IA usado:** Antigravity

---

## Objetivo de la sesión
Asegurar que las Notas de Crédito de Ventas (devoluciones de clientes) se valoricen al Costo Promedio Ponderado (CPP) y no al precio de venta facturado, cumpliendo con los principios de valorización de inventarios (SUNAT 13.1) y evitando la inflación artificial del valor del stock.

## Tareas completadas
- [x] Modificar la firma de `ProcesarDocumento` en `SincronizarComprasHistManejador.cs` para soportar costos unitarios opcionales (`decimal?`).
- [x] Ajustar la lógica de `ProcesarNota` para pasar `null` como costo en el caso de `NC_VENTA` y `ND_VENTA`.
- [x] Validar que el motor de inventario (`CrearMovimientoInventarioManejador`) utilice automáticamente el `costoPromedioActual` cuando el costo del movimiento es nulo en operaciones de entrada.
- [x] Re-ejecución total de la sincronización histórica para recalcular los saldos valorizados del Kardex.
- [x] Verificación: La NC de venta ahora reingresa al almacén al costo del saldo anterior, manteniendo el CPP estable.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `SincronizarComprasHistManejador.cs` | UPDATE | Omitir precio en devoluciones de ventas para forzar uso de CPP. |

## Notas y observaciones
Se observó que al ingresar una devolución al precio de venta (ej: S/ 4,000) superior al costo (ej: S/ 2,857), el valor total del inventario subía incorrectamente. Con este cambio, el reingreso es neutro respecto al costo promedio, reflejando fielmente el valor patrimonial de la mercadería.
