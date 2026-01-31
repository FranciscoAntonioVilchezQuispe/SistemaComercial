-- Script para eliminar tablas del sistema de permisos granulares
-- Ejecutar antes de recrear las tablas

DROP TABLE IF EXISTS identidad.usuarios_roles CASCADE;
DROP TABLE IF EXISTS identidad.roles_menus_permisos CASCADE;
DROP TABLE IF EXISTS identidad.roles_menus CASCADE;
DROP TABLE IF EXISTS identidad.tipos_permiso CASCADE;
DROP TABLE IF EXISTS identidad.menus CASCADE;

SELECT 'Tablas eliminadas exitosamente' as resultado;
