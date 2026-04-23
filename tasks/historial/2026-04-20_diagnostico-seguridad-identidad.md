# Historial de Cambios — 2026-04-20

## Contexto
Se realizaron correcciones críticas en el microservicio `Identidad.API` para cumplir con las normas de estandarización de fechas del proyecto y para proporcionar herramientas de diagnóstico de seguridad (JWT y permisos) en el entorno de desarrollo.

## Cambios Realizados

### Backend (.NET 8)
- **LoginManejador.cs**: 
  - Se sustituyó el uso de `DateTime.UtcNow` por `DateTimeHelper.ObtenerAhoraLima()` conforme a la regla global del proyecto.
  - Esto asegura que los registros de auditoría y expiración sigan la zona horaria de Lima (UTC-5).
- **AuthEndpoints.cs**:
  - Se implementó el endpoint `GET /api/auth/debug-token`.
  - Este endpoint solo está activo en modo `Development`.
  - Permite visualizar el `userId`, `username`, `roles` y `permisos` aplanados del usuario, facilitando el diagnóstico de problemas de autorización sin decodificar el JWT manualmente.

### Base de Datos (PostgreSQL)
- **diagnostico_seguridad.sql**: Script de utilidad para verificar la matriz de permisos y roles directamente en la base de datos.
- **seed_roles_base.sql**: Script para asegurar la existencia del rol `ADMINISTRADOR` y los tipos de permiso base (`VER`, `CREAR`, `EDITAR`, `ELIMINAR`), vinculándolos automáticamente al administrador.

## Verificación
- **Compilación**: Se ejecutó `dotnet build` en el proyecto `Identidad.API` con resultado exitoso (0 errores).
- **SQL**: Los scripts fueron diseñados con lógica de `ON CONFLICT` para ejecución segura y repetible.

## Próximos Pasos
- Verificar en el frontend que el nuevo endpoint sea accesible desde el Gateway en modo desarrollo.
- Probar la autenticación con un usuario que tenga el rol `ADMINISTRADOR` recién sincronizado.
