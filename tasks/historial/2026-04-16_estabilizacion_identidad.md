# Estabilización del Módulo de Identidad y Autenticación — 2026-04-16

## Contexto
Durante el desarrollo del sistema de turnos de vendedores, se detectaron fallos críticos en el módulo de Identidad que impedían el acceso al sistema (errores 404, 500 y desincronización de credenciales).

## Cambios Realizados

### Backend (Identidad.API y Gateway.API)
- **Enrutamiento (YARP)**: Corregida la configuración en `Gateway.API` para incluir el cluster y la ruta hacia `/api/auth/`.
- **Estandarización de Respuestas**: Refactorización de `LoginManejador.cs`, `RefreshTokenManejador.cs` y `AuthEndpoints.cs` para utilizar el wrapper `IToReturn<T>`.
- **Manejo de Errores**: Se sustituyeron las excepciones genéricas por respuestas `401 Unauthorized` controladas ante credenciales inválidas.
- **Sincronización de Base de Datos**: Creación manual de la tabla `identidad.refresh_tokens` para igualar el estado del esquema con los modelos de EF Core.

### Frontend
- **Sincronización de API**: Se actualizó `authService.ts` para extraer datos del wrapper `ApiWrapper<T>` y se corrigió el nombre del campo de contraseña (`password`).

### Credenciales
- **Administrador**: Se restableció la contraseña del usuario `admin` a `Admin123!` mediante un script SQL con hash BCrypt.

## Verificación
- Prueba de login exitosa vía Gateway devolviendo JWT y Refresh Token válidos.
- Verificación de códigos de estado HTTP (200 en éxito, 401 en credenciales fallidas).

## Vínculos
- [todo.md](../todo.md)
- [Walkthrough](../../brain/2b6c2a7c-0f62-4260-9528-0760a970e11e/walkthrough.md)
