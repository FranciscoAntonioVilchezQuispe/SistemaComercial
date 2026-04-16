# Sesión: Secuencialidad y Formateo de Kardex
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Inventario.API
**Modelo de IA usado:** Antigravity

---

## Objetivo de la sesión
Refinar el ordenamiento de las ventas en el Kardex para que sigan su secuencia correlativa exacta (mediante el uso de segundos como desfase) y estandarizar el formato de 8 dígitos con relleno de ceros para todos los documentos, con especial énfasis en Notas de Crédito y Débito.

## Tareas completadas
- [x] Implementar desfase de segundos (`Numero % 60`) en la sincronización de ventas para garantizar orden correlativo dentro del bloque de las 10:00 AM.
- [x] Aplicar `PadLeft(8, '0')` a los números de documento en `CrearMovimientoInventarioManejador` (Entidad + DTO Kardex).
- [x] Actualizar `ProcesarNota` en `SincronizarComprasHistManejador` para asegurar el formato de 8 dígitos en documentos de ajuste.
- [x] Compilación y verificación de sincronización histórica con los nuevos formatos y secuencia.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `CrearMovimientoInventarioManejador.cs` | UPDATE | Estandarización global de formato de 8 dígitos para `NumeroDocumento`. |
| `SincronizarComprasHistManejador.cs` | UPDATE | Inyección de secuencialidad en ventas y relleno de ceros en notas sincronizadas. |

## Notas y observaciones
El Kardex ahora muestra las ventas en el orden exacto de su numeración (Factura 1 antes que Factura 2) y todos los números de documento presentan la estética estándar de 8 caracteres (ej. `00000123`).
