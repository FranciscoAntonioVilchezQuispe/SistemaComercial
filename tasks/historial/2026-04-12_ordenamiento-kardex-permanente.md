# Sesión: Ordenamiento Cronológico Permanente
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Inventario.API
**Modelo de IA usado:** Antigravity

---

## Objetivo de la sesión
Institucionalizar una regla de negocio global para el ordenamiento cronológico del Kardex, asegurando que ingresos y salidas mantengan una secuencia lógica (Compras -> NC Compra -> Ventas -> NC Venta) independientemente del momento de registro.

## Tareas completadas
- [x] Agregar `ObtenerHoraComercial` a `IValidacionReglaSunatService`.
- [x] Implementar matriz de horas: Compras (08:00), NC Compras (09:00), Ventas (10:00), NC Ventas (11:00).
- [x] Refactorizar `CrearMovimientoInventarioManejador` para aplicar normalización de horas en tiempo real.
- [x] Refactorizar `SincronizarComprasHistManejador` para delegar el cálculo de horas al servicio centralizado.
- [x] Resolver bloqueo de archivos por debugger (`netcoredbg`) mediante `taskkill`.
- [x] Compilación y sincronización histórica exitosa.

## Cambios realizados
| Archivo | Tipo de cambio | Descripción |
|---------|---------------|-------------|
| `IValidacionReglaSunatService.cs` | UPDATE | Definición del nuevo contrato para horas comerciales. |
| `ValidacionReglaSunatService.cs` | UPDATE | Implementación de la matriz de ordenamiento por tipo de comprobante SUNAT. |
| `CrearMovimientoInventarioManejador.cs` | UPDATE | Aplicación automática de horas comerciales a movimientos nuevos. |
| `SincronizarComprasHistManejador.cs` | UPDATE | Uso del servicio centralizado y actualización de prioridades (1 a 4). |

## Notas y observaciones
Se verificó que el proceso de sincronización histórica aplica correctamente las nuevas prioridades, consolidando un Kardex que siempre presenta primero las entradas de mercancía antes que las salidas del mismo día.
