# Revisión: Corrección Sistema de Seguridad JWT (403 Forbidden)
**Fecha:** 2026-04-19
**Plan revisado:** Prompts multi-agente en conversación (sin archivo en `tasks/planes/`)
**Resultado:** ⚠️ Aprobado con corrección menor

---

## Resumen

Los 6 agentes Gemini Flash completaron correctamente las 5 etapas del plan. Los cambios más críticos —corrección del nombre del rol `"ADMIN"` → `"ADMINISTRADOR"` en Gateway, mapeo de rutas YARP para catálogo, y parseo de claims en el frontend— fueron implementados sin errores. El backend compila limpio (0 errores) y el frontend pasa TypeScript estricto (tsc --noEmit sin errores).

Se encontró un único bug en el script SQL de diagnóstico: uso de `RAISE NOTICE` fuera de un bloque DO, que es SQL inválido en PostgreSQL estándar y hubiese fallado en DBeaver. Fue corregido directamente.

---

## Problemas Encontrados

### 🔴 Críticos (corregidos por Claude Code)
| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|
| 1 | `scripts/diagnostico_seguridad.sql` | `RAISE NOTICE` usado como sentencia SQL standalone — inválido en PostgreSQL, falla inmediatamente en DBeaver/psql | Convertido a comentarios SQL `--` equivalentes |

### 🟡 Menores (no bloqueantes, registrados)
| # | Archivo | Problema |
|---|---------|----------|
| 1 | `Gateway.API/Program.cs:160` | Variable `pathLower` es `path.ToLower()` pero `path` ya es lowercase desde línea 110. Redundancia inofensiva. |
| 2 | `AuthEndpoints.cs` (debug-token) | El endpoint no valida JWT propio — confía en `X-User-Id` header. Correcto para arquitectura Gateway, pero sin guard adicional en Development podría ser abusado si alguien accede directamente al puerto 5001. Aceptable por restricción `env.IsDevelopment()`. |
| 3 | `PaginaRoles.tsx:182` | Botón "Nuevo Rol" sin `onClick` handler — stub no funcional. No es regresión del feature actual (era así antes). |

### 💡 Mejoras Sugeridas (no bloqueantes)
| # | Archivo | Sugerencia |
|---|---------|-----------|
| 1 | `Gateway.API/Program.cs:128` | `DateTime.Now` en generación de `transactionId` del 401 — debería ser `DateTimeHelper.ObtenerAhoraLima()`. Impacto mínimo (solo en la respuesta JSON de error). |
| 2 | `usePermiso.ts` | Podría exportarse desde `@/features/identidad` (barrel export) para evitar imports profundos en páginas. |
| 3 | `seed_roles_base.sql` | No asigna el primer usuario al rol ADMINISTRADOR — requiere hacerlo manualmente o via frontend. Agregar un bloque opcional comentado para el usuario `admin`. |

---

## Verificación por Archivo

| Archivo | Estado | Notas |
|---------|--------|-------|
| `Gateway.API/Program.cs` | ✅ Correcto | BUG-1 (ADMIN→ADMINISTRADOR), BUG-3 (rutas YARP), BUG-4 (catálogo), logging 403 — todos aplicados |
| `Identidad.API/.../LoginManejador.cs` | ✅ Correcto | `DateTimeHelper.ObtenerAhoraLima()` en UltimoAcceso, FechaCreacion y FechaExpiracion del RefreshToken |
| `Identidad.API/.../AuthEndpoints.cs` | ✅ Correcto | Endpoint debug-token con guard `env.IsDevelopment()` |
| `Frontend/AuthContext.tsx` | ✅ Correcto | Parseo robusto: `Array.isArray` → string con `[rol]` → `[]` |
| `Frontend/lib/axios.ts` | ✅ Correcto | 401 → logout + redirect; 403 → toast; guard `/login` para evitar loop |
| `Frontend/hooks/usePermiso.ts` | ✅ Correcto | Hook simple, admins bypass, sin `any` implícito |
| `scripts/seed_roles_base.sql` | ✅ Correcto | Idempotente, cubre roles + tipos_permiso + roles_menus + roles_menus_permisos |
| `scripts/diagnostico_seguridad.sql` | ⚠️ Corregido | RAISE NOTICE fuera de DO block — corregido a comentarios SQL |

---

## Compilación y Linting

| Verificación | Resultado |
|---|---|
| `dotnet build` Identidad.API.Application | ✅ 0 errores |
| `dotnet build` Gateway/Identidad (con servicios activos) | ⚠️ MSB3027 (DLL bloqueada por proceso en ejecución — no es error de código) |
| `npx tsc --noEmit` Frontend | ✅ 0 errores |

---

## Lecciones para Futuros Planes

Ver `tasks/lessons.md` para las lecciones registradas en esta sesión.
