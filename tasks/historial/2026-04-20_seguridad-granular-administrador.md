# Seguridad Granular para Administrador (2026-04-20)

Se identificó que el sistema de seguridad (permisos granulares) tenía bypasses explícitos para el rol `ADMINISTRADOR` tanto en el backend (Gateway) como en el frontend (Sidebar, usePermiso, RutaProtegida). Esto impedía que se pudieran restringir menús o acciones a un usuario administrador incluso si se configuraba en la matriz de permisos.

## Cambios Realizados (Planificados)

### Backend (Gateway.API)
- Modificación de `Program.cs` para eliminar la exclusión de administradores en la validación de permisos granulares. Esto obliga al sistema a consultar los permisos del token JWT incluso para admins.

### Frontend
- Eliminación de atajos de administrador en:
    - `Sidebar.tsx`: Para filtrar los menús dinámicamente.
    - `usePermiso.ts`: Para validar acciones dentro de componentes.
    - `RutaProtegida.tsx`: Para bloquear el acceso a rutas según el código de permiso.

## Impacto
- El rol `ADMINISTRADOR` ahora se comporta de forma "granular", permitiendo una delegación de responsabilidades más fina.
- El acceso al módulo de **Seguridad** se mantiene garantizado para administradores mediante el flag `soloAdmin`.

## Estado
- [x] Investigación completa.
- [x] Plan de implementación creado.
- [ ] Ejecución pendiente de aprobación.
