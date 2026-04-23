# Revisión: Fix Definitivo Error 403 en PaginaRoles

**Fecha:** 2026-04-19
**Plan revisado:** `tasks/planes/2026-04-19_Fix-definitivo-403-PaginaRoles.md`
**Resultado:** ⚠️ Aprobado con correcciones menores

---

## Resumen

Los tres agentes aplicaron correctamente los cambios estructurales del plan: Gateway con `IsInRole` + `OrdinalIgnoreCase`, RefreshTokenManejador con el repositorio granular, y PaginaRoles con el guard de admin. Se detectó un problema de **doble toast** porque Flash no consultó el interceptor Axios global antes de agregar manejo de 403 al componente — el interceptor ya muestra "No tienes permisos para realizar esta acción" globalmente para cualquier 403, por lo que el toast adicional en el componente resultaba en 2-3 notificaciones simultáneas.

Un bonus positivo: el agente de Tarea B detectó y corrigió el uso de `DateTime.UtcNow` en `RefreshTokenManejador`, reemplazándolo con `DateTimeHelper.ObtenerAhoraLima()` — correcto por las reglas de CLAUDE.md.

---

## Problemas Encontrados

### 🔴 Críticos (corregidos por Claude Code)
_Ninguno._

### 🟡 Menores (corregidos por Claude Code)

| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|
| 1 | `PaginaRoles.tsx` | Doble toast en 403: el componente mostraba su propio toast ADEMÁS del que ya dispara el interceptor Axios global para todo 403 | Eliminado el toast del componente para 403; el `catch` ahora solo muestra toast para errores NON-403 (el interceptor en `axios.ts:73` cubre el 403 globalmente) |
| 2 | `PaginaRoles.tsx` | Flash omitió el `title` prop del botón Guardar (estaba en el plan como UX hint para usuarios no-admin) | Agregado `title={!esAdmin ? "Se requiere rol Administrador" : undefined}` |

### 💡 Mejoras Sugeridas (no bloqueantes)

| # | Archivo | Sugerencia |
|---|---------|-----------|
| 1 | `axios.ts` | El toast de 403 en el interceptor (línea 73) está FUERA del bloque `!skipToast`, lo que significa que no puede ser suprimido per-request. En futuras iteraciones, moverlo dentro del bloque `if (!skipToast)` daría más control granular. |
| 2 | Múltiples `catch (error)` | 23 archivos usan `catch (error)` sin tipar. Para non-admin users, los errores 403 ya están cubiertos por el interceptor global — no es urgente pero sería ideal tipar los catch como `error: any` en los formularios de escritura. |

---

## Verificación de Criterios del Plan

### Tarea A — Gateway ✅
- [x] `esAdmin` usa `IsInRole("ADMINISTRADOR") == true || roles.Any(OrdinalIgnoreCase)`
- [x] Bloque 403-admin tiene `Console.WriteLine` con `RolesEnToken` e `IsInRole`
- [x] `authRutaAdmin` incluye `/api/menus`, `/api/tipos-permiso`, `/api/roles-menus`
- [x] Posición del middleware inalterada (después de `UseAuthorization`, antes de `MapReverseProxy`)

### Tarea B — RefreshTokenManejador ✅ + Bonus
- [x] Constructor con 5 parámetros, `_rolMenuPermisoRepositorio` inyectado y asignado
- [x] `Handle` usa `ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id)` — idéntico a LoginManejador
- [x] NO usa `ObtenerCodigosPorRolIdsAsync` ni `rolIds`
- [x] `_permisoRepositorio` conservado (no eliminado)
- [x] **BONUS**: `DateTime.UtcNow` → `DateTimeHelper.ObtenerAhoraLima()` en las fechas del refresh token (corrige violación de CLAUDE.md preexistente)

### Tarea C — PaginaRoles Frontend ⚠️ (corregida)
- [x] `useAuth` importado
- [x] `rolesUsuario` y `esAdmin` como primeras líneas del componente
- [x] No hay conflicto de nombres con estado local `roles: RolDto[]`
- [x] Botón con `disabled={saving || loadingAccesos || !esAdmin}`
- [x] `title` prop agregado (corregido por Claude Code)
- [x] Double toast eliminado (corregido por Claude Code)

---

## Lecciones para Futuros Planes

1. **Siempre incluir en el contexto el interceptor Axios** cuando se pida agregar manejo de errores en componentes frontend. Flash no sabe que existe `src/lib/axios.ts` con manejo global de 401/403 si no se le indica explícitamente. Agregarlo como referencia obligatoria evita el doble toast.

2. **Especificar en el plan**: "Antes de agregar toast para un código HTTP específico, verificar si el interceptor `src/lib/axios.ts` ya lo maneja globalmente."
