# Sesión: Corrección de Mapeo SUNAT en Ventas
**Fecha:** 2026-04-12
**Proyecto(s) involucrado(s):** Ventas.API
**Modelo de IA usado:** Gemini 3 Flash

## Objetivo de la sesión
Corregir el error `42703 (no existe la columna t.id)` que impedía la creación de ventas debido a una desincronización entre el mapeo de la entidad de referencia `TipoAfectacionIgvRef` y el esquema real de la base de datos PostgreSQL.

## Tareas completadas
- [x] Investigar causa raíz del error 42703 en logs de ventas — archivo: `Codigo/LogErrores/ventas-20260412.log`
- [x] Corregir mapeo de `TipoAfectacionIgvRef` (id -> id_afectacion) — archivo: `src/Ventas.API/Ventas.API.Domain/Entidades/Referencias/TipoAfectacionIgvRef.cs`
- [x] Crear entidad de referencia `TipoTributoRef` — archivo: `src/Ventas.API/Ventas.API.Domain/Entidades/Referencias/TipoTributoRef.cs`
- [x] Actualizar `VentasDbContext` con nuevas referencias — archivo: `src/Ventas.API/Ventas.API.Infrastructure/Datos/VentasDbContext.cs`
- [x] Verificar compilación de la solución — ejecutado `dotnet build` exitosamente.

## Cambios realizados
| Archivo | Tipo | Descripción |
|---------|------|-------------|
| `TipoAfectacionIgvRef.cs` | MODIFY | Se cambió el atributo de columna de `id` a `id_afectacion`. |
| `TipoTributoRef.cs` | NEW | Se creó la entidad de referencia para el Catálogo 05 de SUNAT. |
| `VentasDbContext.cs` | MODIFY | Se registró `TipoTributoRef` y se configuró su mapeo cross-schema. |

## Lecciones aprendidas
- Las entidades de referencia en microservicios ajenos deben ser auditadas contra la "fuente de verdad" (el microservicio dueño del esquema) para evitar errores de mapeo silenciosos que solo explotan en tiempo de ejecución.
- Errores de compilación tipo `MSB3021` en este entorno suelen deberse a bloqueos de `netcoredbg.exe`, requiriendo un `taskkill` forzado para liberar archivos.
