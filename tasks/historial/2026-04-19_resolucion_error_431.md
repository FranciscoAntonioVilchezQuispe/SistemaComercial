# Sesión 2026-04-19 — Resolución de Error 431 (Header Too Large)

## Contexto
Se reportaron múltiples errores `Request failed with status code 431` en el frontend al intentar cargar datos de roles, permisos y trabajadores. Este error indica que los encabezados de la solicitud HTTP son demasiado grandes para ser procesados por el servidor web (Kestrel en ASP.NET Core).

## Causa Raíz
La reciente implementación de **Autorización Granular** introdujo permisos aplanados en el token JWT. Con más de 30 menús y múltiples permisos por cada uno, el tamaño del JWT y los encabezados personalizados del Gateway (`X-User-Permisos`) superaron el límite por defecto de Kestrel (32KB).

## Cambios Propuestos
1.  **Nucleo.Comun.API**: Crear extensión `HostExtensions` para configurar límites de Kestrel de forma centralizada.
2.  **Microservicios**: Aplicar `ConfigureKestrelLimits()` en todos los archivos `Program.cs`.
3.  **Gateway.API**: Aumentar el límite para soportar la propagación de encabezados hacia los microservicios destino.

## Estado Actual
- [x] Investigación completa.
- [x] Plan de Implementación generado.
- [x] Aplicación de límites de Kestrel (64KB) en los 9 microservicios.
- [x] Verificación de compilación exitosa (0 errores).
- [x] Documentación y historial finalizados.
