# Sesión 2026-04-20 — Filtrado Dinámico de Menús por Permisos JWT

## Contexto
El Sidebar actualmente muestra todos los menús definidos en `menu.tsx` independientemente de los permisos del usuario. Se requiere filtrar estos menús basándose en los roles (ej. ADMINISTRADOR) y los permisos granulares (`CODIGO:VER`) contenidos en el JWT decodificado en `AuthContext`.

## Cambios Realizados

### [Frontend] Configuración y Tipado
- Modificación de `src/config/menu.tsx` para incluir `codigoPermiso` y `soloAdmin` en la interfaz `ItemMenu`.
- Asignación de códigos a módulos críticos (Seguridad, Configuración).

### [Frontend] Componentes
- Refactorización de `Sidebar.tsx` para implementar la lógica de visibilidad.
- Uso de `useAuth()` una sola vez para cumplir con las reglas de hooks de React.
- Implementación de función recursiva `puedeVerItem` para manejar sub-menús y grupos vacíos.

## Verificación
- `npx tsc --noEmit` -> 0 errores.
- Pruebas manuales con distintos roles.
