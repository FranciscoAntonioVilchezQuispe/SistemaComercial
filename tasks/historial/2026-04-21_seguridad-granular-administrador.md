# Historial de Sesión — 2026-04-21

**Descripción:** Implementación de Seguridad Granular para el rol ADMINISTRADOR.

## Cambios Realizados

### Frontend
- **menu.tsx**: Se actualizaron los `codigoPermiso` de todos los sub-menús para usar códigos granulares (ej: `CAT_PRODUCTOS`, `VEN_POS`) en lugar de códigos genéricos de módulo.
- **rutas.tsx**: Se sincronizaron las protecciones de rutas (`RutaConPermiso`) con los nuevos códigos granulares.
- **Seguridad**: Se migró el acceso a los menús de seguridad a un sistema basado en permisos (`SEG_USUARIOS`, `SEG_ROLES`) en lugar de solo por nombre de rol.

### Backend (Gateway)
- **Program.cs**: Se refinó el middleware de autorización para mapear rutas de API a códigos de menú específicos y se hizo estricta la verificación de permisos (eliminando el bypass por código de módulo padre).

## Verificación
- Compilación de Gateway.API (`dotnet build`) exitosa.
- Verificación de tipos frontend (`npx tsc --noEmit`) exitosa.

## Archivos Afectados
- `Codigo/Frontend/src/config/menu.tsx`
- `Codigo/Frontend/src/configuracion/rutas.tsx`
- `Codigo/Backend/src/Gateway.API/Program.cs`
- `tasks/todo.md`
