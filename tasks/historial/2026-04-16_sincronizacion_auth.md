# Sincronización de Autenticación y Corrección de Error 401 — 2026-04-16

## Contexto
Tras estabilizar el login, se detectó que las peticiones a endpoints protegidos (como `/api/usuarios`) devolvían error 401 debido a una desincronización en las claims del JWT. Además, el Gateway devolvía respuestas en texto plano, causando fallos de parsing en el frontend.

## Cambios Realizados

### Configuración del Sistema
- **JWT Alignment**: Se sincronizaron los valores de `Issuer` (`SistemaComercial`) y `Audience` (`SistemaComercialAPI`) en los archivos `appsettings.json` de `Identidad.API` y `Gateway.API`.
- **Secret Key**: Confirmada la coincidencia de llaves para la validación de firma.

### Gateway.API (Middleware)
- **JSON Responses**: Refactorización del middleware de seguridad manual para devolver respuestas 401 y 403 en formato JSON compatible con `ApiWrapper`.
- **Header Correction**: Se aseguró que `Content-Type: application/json` se envíe en todas las respuestas de error de seguridad.

## Verificación
- Login exitoso obteniendo un token con los nuevos claims.
- Uso del token para acceder a `GET /api/usuarios` a través del Gateway con resultado satisfactorio (`200 OK`).
- Verificación de que los errores controlados ahora viajan como JSON.

## Vínculos
- [todo.md](../todo.md)
- [Walkthrough](../../brain/2b6c2a7c-0f62-4260-9528-0760a970e11e/walkthrough.md)
