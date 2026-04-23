# Implementación de Tests Frontend — Fase 0 (Setup y Utilidades)

Este plan detalla la ejecución del **AGENTE-FE-0** según el [Plan-Tests-Frontend.md](file:///d:/Personal/Proyectos/SistemaComercial/tasks/Plan%20de%20IMplementacion%20Claude/Plan-Tests-Frontend.md).

## Objetivos
- Establecer la infraestructura de testing en el proyecto Frontend.
- Garantizar que las utilidades core (cálculos IGV, formatos, validaciones) estén testeadas antes de avanzar a los hooks de negocio.

## Cambios Propuestos

### Frontend

#### [MODIFY] [package.json](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/package.json)
- Agregar dependencias: `vitest`, `@vitest/coverage-v8`, `@testing-library/react`, `@testing-library/user-event`, `@testing-library/jest-dom`, `msw`, `jsdom`.
- Agregar scripts: `test`, `test:run`, `test:coverage`, `test:ui`.

#### [NEW] [vitest.config.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/vitest.config.ts)
- Configuración de Vitest con entorno `jsdom`, aliases de path y configuración de cobertura.

#### [NEW] [setup.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/__tests__/setup/setup.ts)
- Configuración global de MSW y mocks de `localStorage` y `matchMedia`.

#### [NEW] [mswServer.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/__tests__/setup/mswServer.ts)
- Servidor MSW con handlers base para los microservicios.

#### [NEW] [renderWithProviders.tsx](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/__tests__/setup/renderWithProviders.tsx)
- Helpers para renderizar componentes y hooks con `QueryClientProvider` y `MemoryRouter`.

#### [NEW] [calculos.test.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/compartido/utilidades/__tests__/calculos.test.ts)
- Tests para lógica de IGV, subtotales y totales.

#### [NEW] [moneda.test.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/compartido/utilidades/__tests__/moneda.test.ts)
- Tests para formateo y parseo de moneda peruana (S/).

#### [NEW] [fecha.test.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/compartido/utilidades/__tests__/fecha.test.ts)
- Tests para manipulación y formateo de fechas.

#### [NEW] [validacion.test.ts](file:///d:/Personal/Proyectos/SistemaComercial/Codigo/Frontend/src/compartido/utilidades/__tests__/validacion.test.ts)
- Tests para validación de RUC, DNI, Email y Teléfono.

## Verificación Plan
- Ejecutar `npm run test:run` para asegurar que todos los tests pasen.
- Verificar que la cobertura inicial cubra las utilidades mencionadas.

> [!IMPORTANT]
> Se requiere aprobación para instalar los nuevos paquetes de desarrollo en el Frontend.
