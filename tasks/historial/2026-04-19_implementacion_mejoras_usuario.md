# Sesión 2026-04-19 — Implementación de Funcionalidades de Perfil y Sesión

## Contexto
El usuario solicitó que las opciones del menú desplegable de "Mi Cuenta" (Perfil, Configuración y Cerrar Sesión) sean funcionales. Actualmente son componentes visuales sin lógica asociada.

## Cambios Propuestos
1.  **Cerrar Sesión**: Integrar con `AuthContext` para limpiar el estado y redirigir al login.
2.  **Página de Perfil**: Crear una nueva vista para visualizar los datos del usuario autenticado.
3.  **Página de Configuración**: Crear una vista base para ajustes personales.
4.  **Enrutamiento**: Registrar las nuevas rutas en el ruteador principal de React.
5.  **Navegación**: Configurar los eventos `onClick` en el componente `Header`.

## Estado Actual
- [x] Investigación de AuthContext y rutas.
- [x] Plan de Implementación generado.
- [x] Páginas de Perfil y Configuración creadas.
- [x] Rutas registradas y funcionalidad de Logout activada en Header.
- [x] Verificado y finalizado.
