# Historial: Creación de Scripts de Utilidad para Seguridad
**Fecha:** 2026-04-20
**Autor:** Antigravity (IA)

## Descripción
Se han creado dos scripts SQL para facilitar el diagnóstico y la inicialización de permisos en el sistema de seguridad (esquema `identidad`). Estos scripts permiten verificar la integridad de la matriz de permisos y asegurar que el rol `ADMINISTRADOR` tenga acceso completo a todos los menús del sistema.

## Cambios Realizados

### Scripts SQL
- **[diagnostico_seguridad.sql](file:///d:/Personal/Proyectos\SistemaComercial\Codigo\Backend\scripts\diagnostico_seguridad.sql)**:
    - Listado de roles y tipos de permiso activos.
    - Identificación de menús root.
    - Consulta de permisos aplanados para usuarios específicos (ej. admin).
    - Verificación cruzada para asegurar que el rol ADMINISTRADOR tenga los 4 permisos básicos en módulos core.
- **[seed_roles_base.sql](file:///d:/Personal/Proyectos\SistemaComercial\Codigo\Backend\scripts\seed_roles_base.sql)**:
    - Inserción idempotente del rol `ADMINISTRADOR`.
    - Inserción idempotente de los tipos de permiso: `VER`, `CREAR`, `EDITAR`, `ELIMINAR`.
    - Bloque procedural que recorre todos los menús y los vincula al rol administrador, asignándole todos los tipos de permiso de forma automática.

## Impacto
Estos scripts reducen el tiempo de configuración inicial y depuración de errores de autorización (403 Forbidden) al garantizar una base de datos limpia y correctamente poblada para el rol de administración.

## Verificación
- Se verificó la estructura de las tablas `menus`, `roles`, `tipos_permiso`, `roles_menus` y `roles_menus_permisos` mediante inspección de entidades en `Identidad.API`.
- Los scripts han sido diseñados para ser ejecutados múltiples veces sin producir duplicados o errores (`ON CONFLICT` / `WHERE NOT EXISTS`).
