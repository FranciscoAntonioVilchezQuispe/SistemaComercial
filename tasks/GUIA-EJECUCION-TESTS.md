# 🧪 Guía de Ejecución de Pruebas Automatizadas

Esta guía detalla cómo ejecutar la infraestructura de pruebas (Frontend y Backend) implementada para el **Sistema Comercial**.

---

## 1. Pruebas de Frontend (React + Vitest)

Las pruebas del frontend utilizan **Vitest** como motor de ejecución y **MSW (Mock Service Worker)** para simular las respuestas de la API, por lo que no requieren que el backend esté encendido.

### Requisitos
- Node.js instalado.
- Haber ejecutado `npm install` en la carpeta del frontend.

### Comandos de ejecución
Ubicación: `Codigo/Frontend`

| Comando | Descripción |
|---------|-------------|
| `npm run test:run` | Ejecuta todos los tests una sola vez y muestra el resumen. |
| `npm run test` | Ejecuta los tests en modo **Watch** (se re-ejecutan al cambiar el código). |
| `npm run test:ui` | Abre una interfaz gráfica en el navegador para explorar los tests. |
| `npm run test:coverage` | Genera un reporte de cobertura de código en la carpeta `/coverage`. |

---

## 2. Pruebas de Backend (.NET + xUnit)

Las pruebas del backend están divididas en **Unitarias** e **Integración**. Las de integración utilizan **Testcontainers**, lo que significa que levantan una base de datos temporal en Docker.

### Requisitos
- **.NET 8 SDK** instalado.
- **Docker Desktop** iniciado (necesario para las pruebas de integración que usan PostgreSQL).

### Comandos de ejecución
Ubicación: `Codigo/Backend`

| Comando | Descripción |
|---------|-------------|
| `dotnet test` | Ejecuta **todos** los proyectos de prueba de la solución. |
| `dotnet test tests/Nucleo.Tests` | Ejecuta solo los tests del núcleo (paginación, validadores). |
| `dotnet test tests/Identidad.API.Tests` | Ejecuta los tests de autenticación y roles. |
| `dotnet test tests/Ventas.API.Tests` | Ejecuta los tests de ventas, cajas y turnos. |

> [!TIP]
> Si deseas ejecutar solo las pruebas unitarias y omitir las de integración (que requieren Docker), puedes usar:
> `dotnet test --filter Category=Unit` (si están categorizadas).

---

## 3. Estructura de Proyectos de Test

### Frontend (`src/__tests__`)
- `setup/`: Configuración global y servidor MSW.
- `utilidades/`: Tests de lógica fiscal y cálculos SUNAT.
- `features/`: Tests de hooks y servicios por módulo de negocio.

### Backend (`tests/`)
- `Nucleo.Tests.Shared/`: Infraestructura base, fixtures de BD y generadores de tokens.
- `*.API.Tests/`: Suites de pruebas específicas para cada microservicio.

---

## 4. Resolución de Problemas

**Error en Backend: "Docker is not running"**
- Asegúrate de que Docker Desktop esté abierto y funcionando. Las pruebas de integración necesitan crear un contenedor de PostgreSQL temporal.

**Error en Frontend: "MSW: Failed to register Service Worker"**
- Esto suele ocurrir en el navegador, pero en los tests (Vitest/JSDOM) se maneja mediante el servidor MSW. Asegúrate de que `src/__tests__/setup/setup.ts` esté cargado en el `vitest.config.ts`.

---
*Guía generada el 2026-04-23 por Antigravity.*
