# Historial de Cambios - 2026-04-20

## Descripción
Inicio del análisis y planificación para la eliminación de menús y submenús redundantes en el módulo de Seguridad (Roles y Permisos). Se detectó que el script de base de datos `01_BASE_SISTEMA_COMERCIAL.sql` contiene múltiples inserciones para los mismos códigos de menú, lo que genera duplicidad en la interfaz de usuario.

## Tareas Realizadas
- [x] Análisis de `01_BASE_SISTEMA_COMERCIAL.sql` identificando bloques de `INSERT` duplicados.
- [x] Comparativa de rutas entre Base de Datos (`/identidad/*`) y Frontend (`/seguridad/*`).
- [x] Actualización de `tasks/todo.md` con la nueva sesión.
- [x] Creación de `implementation_plan.md` para consolidación de menús.

## Hallazgos
- Los menús de seguridad están duplicados en el SQL: se insertan una vez con IDs fijos y otra vez con códigos descriptivos.
- Existe una discrepancia en las rutas: el frontend espera `/seguridad/roles` mientras que la base de datos tiene `/identidad/roles`.
- Códigos de menú como `IDENTIDAD_ROLES` y `IDENTIDAD_PERMISOS` aparecen repetidos en diferentes líneas del script base.

## Próximos Pasos (Pendiente de Aprobación)
1. Desarrollar script de consolidación `consolidar_menus.sql`.
2. Limpiar y unificar `01_BASE_SISTEMA_COMERCIAL.sql`.
3. Validar integridad de permisos tras la consolidación.
