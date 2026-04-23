# Historial — 2026-04-21 — Limpieza de Logs y Mensajes

## Objetivo
Unificar los mensajes de error (especialmente 403), hacerlos más amigables, limpiar logs residuales y corregir advertencias de React Router y accesibilidad (Radix UI).

## Cambios Realizados

### Frontend

#### 1. React Router v7 Future Flags
- Ubicación: `src/configuracion/rutas.tsx`
- Se añadieron los flags necesarios para silenciar las advertencias de deprecación de la v6:
  - `v7_relativeSplatPath`
  - `v7_fetcherPersist`
  - `v7_normalizeFormMethod`
  - `v7_partialHydration`
  - `v7_skipActionErrorRevalidation`

#### 2. Unificación de Toasts y Mensajes (Axios)
- Ubicación: `src/lib/axios.ts`
- Se eliminó el toast redundante en el bloque 403.
- Se implementó un control de "throtthle" para mensajes 403 para evitar spam en carga de página.
- Se mejoró el lenguaje de los mensajes.

#### 3. Refactor de Capturador de Errores
- Ubicación: `src/compartido/utilidades/capturadorErrores.ts`
- Se optimizó la visualización en consola usando grupos colapsados y colores más discretos.

#### 4. Accesibilidad en Diálogos
- Ubicación: `src/features/catalogo/paginas/PaginaProductos.tsx`
- Se añadió `DialogDescription` para cumplir con los estándares de Radix UI / Shadcn.

#### 5. Limpieza de Logs
- Se eliminaron `console.log` en `servicioMarcas.ts` y otros servicios identificados.

### Backend

#### 1. Mensajes de Permisos (Gateway)
- Ubicación: `Gateway.API/Program.cs`
- Se suavizaron los mensajes de "Acceso denegado" por "Permiso insuficiente" o similares.

## Verificación
- [ ] `npm run build` (Frontend)
- [ ] `dotnet build` (Backend)
- [ ] Verificación visual de los toasts y consola.
