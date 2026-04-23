# Revisión: Filtrado Dinámico de Menús por Permisos JWT

**Fecha:** 2026-04-20
**Plan revisado:** `tasks/planes/2026-04-20_Filtrado-dinamico-menus-por-permisos-JWT.md`
**Resultado:** ⚠️ Aprobado con correcciones menores

---

## Resumen

Los cuatro agentes completaron la estructura principal correctamente: `usePermiso.ts` creado exactamente como el plan, `menu.tsx` con la interfaz extendida y todos los códigos correctos, `Sidebar.tsx` respetando las reglas de hooks (función `puedeVerItem` como closure, sin llamar `useAuth` dentro de `.filter()`), `PaginaNoAutorizado.tsx` con un diseño más pulido que el plan, y el Gateway con `/api/reglasdocumentos` y `/api/operaciones-sunat` mapeados a `CONFIGURACION`.

Se detectaron 3 bugs en `rutas.tsx` y 1 en `RutaProtegida.tsx`. El más crítico fue el uso de `codigoPermiso="PROVEEDORES"` para las rutas de proveedores — ese código no existe en el JWT, lo que habría bloqueado a todos los usuarios no-admin en `/proveedores` y `/proveedores/ordenes`. También faltaba el patrón de submenú en `RutaProtegida` (inconsistente con Gateway/Sidebar/usePermiso).

---

## Problemas Encontrados

### 🔴 Críticos (corregidos por Claude Code)

| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|
| 1 | `rutas.tsx:442,452` | `codigoPermiso="PROVEEDORES"` en rutas `proveedores/*` — ese código NO existe en el JWT (el Gateway mapea `/api/proveedores` → `COMPRAS`). Usuarios con `COMPRAS:VER` habrían recibido `PaginaNoAutorizado` al navegar a esas rutas. | Cambiado a `codigoPermiso="COMPRAS"` en ambas rutas |
| 2 | `RutaProtegida.tsx:37` | Check de `codigoPermiso` solo usaba `permisos.includes(...)` sin el patrón de submenú `tieneSubMenu`. Inconsistente con `usePermiso.ts`, `Sidebar.tsx` y el Gateway — un usuario con `VENTAS_POS:VER` pero sin `VENTAS:VER` sería bloqueado. | Agregado `|| permisos.some(p => p.startsWith(...) && p.endsWith(":VER"))` |

### 🟡 Menores (corregidos por Claude Code)

| # | Archivo | Problema | Corrección Aplicada |
|---|---------|----------|-------------------|
| 1 | `rutas.tsx:194` | `React.ReactNode` usado en `RutaConPermiso` sin `React` importado como default. TypeScript error 6133. | Agregado `ReactNode` al import de `"react"` y cambiado `React.ReactNode` → `ReactNode` |
| 2 | `rutas.tsx:192` | `import { RutaProtegida }` colocado en medio del archivo (después de los lazy imports), violando la regla de imports al tope. Causaba error TS2300 duplicado al mover el import. | Movido al tope del archivo (línea 4), eliminado el duplicado |

### 💡 Mejoras Sugeridas (no bloqueantes)

| # | Archivo | Sugerencia |
|---|---------|-----------|
| 1 | `Sidebar.tsx:43` | `i.codigoPermiso.toUpperCase()` es redundante — los códigos ya son `MAYÚSCULAS` por convención. No causa error pero genera procesamiento innecesario por cada render. |
| 2 | `rutas.tsx` | `<Suspense>` está dentro de `<RutaConPermiso>` en lugar de fuera. El plan decía Suspense afuera. Funciona igual porque `RutaProtegida` ya maneja el spinner de `cargando`, pero el spinner de fallback lazy no aparecería si se navega directamente a la ruta antes de que el chunk cargue. |

---

## Verificación de Criterios del Plan

### Tarea A — usePermiso + menu.tsx ✅
- [x] `usePermiso.ts` creado en `src/compartido/hooks/`
- [x] Exporta `usePermiso`, `usePermisoMenu` y `useEsAdmin`
- [x] Interfaz `ItemMenu` tiene `codigoPermiso?` y `soloAdmin?`
- [x] Todos los ítems padre tienen `codigoPermiso` o `soloAdmin` asignado
- [x] Códigos en MAYÚSCULAS: CATALOGO, VENTAS, COMPRAS, INVENTARIO, CLIENTES, CONFIGURACION
- [x] Dashboard y Reportes sin `codigoPermiso`
- [x] Seguridad usa `soloAdmin: true`

### Tarea B — Sidebar ✅
- [x] `useAuth` llamado UNA VEZ al inicio del componente `ItemMenuSidebar`
- [x] `puedeVerItem` es closure pura (no hook) — no viola reglas de hooks
- [x] Items `soloAdmin` ocultos para no-admin
- [x] Items con `codigoPermiso` filtrados por permisos JWT
- [x] Si todos los subItems de un grupo están ocultos, el padre se oculta también
- [x] `npx tsc --noEmit` → 0 errores

### Tarea C — RutaProtegida + rutas.tsx ⚠️ (corregida)
- [x] `PaginaNoAutorizado.tsx` creado y exportado
- [x] `RutaProtegida.tsx` acepta `codigoPermiso?`
- [x] Patrón submenú agregado en `RutaProtegida` (corregido por Claude Code)
- [x] `rutas.tsx` tiene `RutaConPermiso` aplicado a todos los módulos
- [x] `codigoPermiso="COMPRAS"` en proveedores/* (corregido por Claude Code)
- [x] Rutas de seguridad usan `RutaProtegida rolesRequeridos={["ADMINISTRADOR"]}`
- [x] TypeScript limpio (import fix corregido)

### Tarea D — Gateway ✅
- [x] `/api/reglasdocumentos` → `CONFIGURACION`
- [x] `/api/operaciones-sunat` → `CONFIGURACION`
- [x] `/api/ubigeo` y `/api/catalogos` sin mapeo (acceso libre)
- [x] `dotnet build` → 0 errores

---

## Lecciones para Futuros Planes

1. **Especificar en el plan qué código usar para cada grupo de rutas frontend**, incluyendo casos no obvios como `proveedores/*` → `"COMPRAS"`. Flash inventó `"PROVEEDORES"` porque el nombre de la ruta URL lo sugería, pero el código correcto viene del Gateway.

2. **Cuando se crea una función de validación de permisos**, incluir en el plan la nota: "Esta función DEBE ser idéntica en lógica a `usePermiso.ts` y a `RutaProtegida.tsx`. Si una tiene `tieneSubMenu`, TODAS deben tenerlo." Flash copió el check exacto en Sidebar pero omitió el patrón en RutaProtegida.

3. **Especificar explícitamente** que los imports deben ir al tope del archivo. Flash colocó el import de `RutaProtegida` en medio del archivo después de los lazy imports — es válido en JS pero viola convenciones y ESLint.
