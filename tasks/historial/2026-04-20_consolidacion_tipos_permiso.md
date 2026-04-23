# Sesión Historial — Consolidación de Tipos de Permiso (Inglés/Español)
**Fecha:** 2026-04-20
**ID de Sesión:** `consolidation-permissions-20260420`

## Descripción
Se ha corregido una redundancia en la tabla `identidad.tipos_permiso` donde coexistían códigos en inglés (`CREATE`, `READ`, etc.) y español (`CREAR`, `VER`, etc.). Esta duplicidad causaba que el módulo de "Roles y Permisos" en el frontend mostrara columnas repetidas para la misma acción.

## Cambios Realizados

### Base de Datos
- **[NUEVO]** `Codigo/BaseDeDatos/Scripts/mantenimiento/2026-04-21_consolidar_tipos_permiso.sql`: Script de migración idempotente que reasigna permisos de roles de códigos ingleses a españoles y elimina los registros obsoletos.
- **[MODIFICADO]** `01_BASE_SISTEMA_COMERCIAL.sql`: Se eliminó el bloque de inserción de tipos de permiso en inglés (L3171-3179) y se centralizó el catálogo unificado en la sección inicial de Identidad.

### Control de Tareas
- Actualizado `tasks/todo.md` con el progreso de la sesión.
- Actualizado `tasks/task.md` (Artifact) con los pasos de ejecución.

## Verificación
- Se confirmó mediante análisis de código que el **Gateway.API** ya utiliza los códigos en español (`VER`, `CREAR`, `EDITAR`, `ELIMINAR`) para la validación de rutas.
- Se verificó que el hook **usePermiso** del Frontend también utiliza los códigos en español.
- El script de migración asegura la integridad de los datos existentes mediante `INSERT ... ON CONFLICT DO NOTHING`.

## Notas Técnicas
- El mapeo realizado fue:
    - `CREATE` → `CREAR`
    - `READ` → `VER`
    - `UPDATE` → `EDITAR`
    - `DELETE` → `ELIMINAR`
    - `EXPORT` → `EXPORTAR`
    - `APPROVE` → `APROBAR`
    - `PRINT` → `IMPRIMIR`
    - `CANCEL` → `ANULAR`
    - `IMPORT` → `IMPORTAR`
