# Plan de Implementación de Tests — Frontend Sistema Comercial

**Fecha**: 2026-04-23
**Autor**: Claude Sonnet 4.6
**Versión**: 1.0
**Modo de ejecución**: Multi-agente (Gemini Flash)

---

## IMPORTANTE PARA AGENTES

Este plan está diseñado para ejecución **multi-agente independiente**. Cada sección marcada con `[AGENTE-FE-N]` es una unidad de trabajo autocontenida. Cada agente debe:

1. Leer **solo** su sección asignada.
2. Leer **todos los archivos fuente** indicados antes de escribir código.
3. Crear los archivos de test **exactamente** en las rutas indicadas.
4. No modificar archivos fuera de carpetas `__tests__/` (excepto FE-0 que crea `vitest.config.ts` y modifica `package.json`).
5. Usar **solo** los paquetes listados en la Sección 2 (sin agregar otros).
6. Seguir el patrón AAA (Arrange / Act / Assert) en todos los tests.
7. Nombrar tests con el formato: `[funcion/hook]_[condicion]_[resultadoEsperado]`
8. Ejecutar `npm run test:run` al final para verificar que todo compila y pasa.

---

## 1. Contexto: Estado Actual del Frontend

El frontend es una SPA en React 18 + TypeScript + Vite sin ninguna infraestructura de testing.

| Característica | Detalle |
|---------------|---------|
| Framework | React 18.3 |
| Lenguaje | TypeScript (strict) |
| Build tool | Vite 5.4 |
| Estado servidor | TanStack Query v5 |
| Estado local | Zustand v5 |
| HTTP | Axios con interceptores centralizados |
| Formularios | react-hook-form + zod |
| UI | Radix UI + Tailwind CSS |
| Routing | react-router-dom v6 |
| Autenticación | JWT (jwt-decode) en localStorage (`sc_token`, `sc_refresh`) |
| API base URL | `http://localhost:5000/api` (Gateway) |
| Tests actuales | **Ninguno** |

### Mapa de módulos a testear

| Módulo | Feature | Hooks principales |
|--------|---------|-------------------|
| Utilidades | `compartido/utilidades/` | Funciones puras |
| Autenticación | `features/identidad/` | authService, useAuth |
| Catálogo | `features/catalogo/` | useProductos, useMarcas, useCategorias |
| Clientes | `features/clientes/` | useClientes |
| Carrito | `features/ventas/hooks/useCarrito.ts` | Zustand store |
| Ventas | `features/ventas/` | useVentas, useAnularVenta, useCajas |
| Compras | `features/compras/` | useCompras, useOrdenesCompra, useProveedores |
| Inventario | `features/inventario/` | useStock, useMovimientos, useKardex, useAlmacenes |
| Configuración | `features/configuracion/` | useSeriesComprobante, useTablaGeneral, useImpuestos |
| Componentes | `compartido/componentes/` | TablaPaginada, RutaProtegida, usePermiso |

---

## 2. Stack de Testing (igual para todos los agentes)

```json
"devDependencies": {
  "vitest": "^1.6.0",
  "@vitest/coverage-v8": "^1.6.0",
  "@testing-library/react": "^16.0.0",
  "@testing-library/user-event": "^14.5.2",
  "@testing-library/jest-dom": "^6.6.0",
  "msw": "^2.3.0",
  "jsdom": "^24.1.0"
}
```

**Scripts de test en package.json**:
```json
"test": "vitest",
"test:run": "vitest run",
"test:coverage": "vitest run --coverage",
"test:ui": "vitest --ui"
```

**Convención de nombre de tests**:
```
[funcion/hook]_[condicion]_[resultadoEsperado]

Ejemplos válidos:
  calcularIGV_ConMonto100_Devuelve18()
  useProductos_ConRespuestaExitosa_DevuelveListaPaginada()
  useCarrito_AlAgregarProducto_ActualizaTotales()
  login_ConCredencialesInvalidas_LanzaError()
  RutaProtegida_SinPermiso_NoRenderizaHijos()
```

**Patrón AAA obligatorio**:
```typescript
it('useProductos_ConRespuestaExitosa_DevuelveListaPaginada', async () => {
  // Arrange
  server.use(
    http.get(`${API_BASE}/productos`, () =>
      HttpResponse.json({ datos: [productoTest], total: 1, ... })
    )
  )

  // Act
  const { result } = renderHookConProveedores(() => useProductos())

  // Assert
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data?.datos).toHaveLength(1)
})
```

---

## 3. Estructura de Carpetas de Tests

```
D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\
├── vitest.config.ts                    ← AGENTE-FE-0 crea este archivo
├── package.json                        ← AGENTE-FE-0 agrega scripts de test
└── src/
    ├── __tests__/                      ← AGENTE-FE-0 crea esta carpeta
    │   └── setup/
    │       ├── setup.ts                ← beforeAll/afterAll MSW
    │       ├── mswServer.ts            ← servidor MSW + handlers base
    │       └── renderWithProviders.tsx ← wrapper QueryClient + Router
    ├── compartido/
    │   ├── utilidades/
    │   │   └── __tests__/              ← AGENTE-FE-0
    │   │       ├── calculos.test.ts
    │   │       ├── moneda.test.ts
    │   │       ├── fecha.test.ts
    │   │       └── validacion.test.ts
    │   └── __tests__/                  ← AGENTE-FE-9
    │       ├── usePermiso.test.ts
    │       ├── TablaPaginada.test.tsx
    │       └── RutaProtegida.test.tsx
    └── features/
        ├── identidad/
        │   └── __tests__/              ← AGENTE-FE-1
        │       ├── authService.test.ts
        │       └── AuthContext.test.tsx
        ├── catalogo/
        │   └── __tests__/              ← AGENTE-FE-2
        │       ├── useProductos.test.ts
        │       ├── useMarcas.test.ts
        │       └── useCategorias.test.ts
        ├── clientes/
        │   └── __tests__/              ← AGENTE-FE-3
        │       └── useClientes.test.ts
        ├── ventas/
        │   └── __tests__/              ← AGENTE-FE-4 + AGENTE-FE-5
        │       ├── useCarrito.test.ts
        │       └── useVentas.test.ts
        ├── compras/
        │   ├── compras/
        │   │   └── __tests__/          ← AGENTE-FE-6
        │   │       └── useCompras.test.ts
        │   ├── ordenes-compra/
        │   │   └── __tests__/          ← AGENTE-FE-6
        │   │       └── useOrdenesCompra.test.ts
        │   └── proveedores/
        │       └── __tests__/          ← AGENTE-FE-6
        │           └── useProveedores.test.ts
        ├── inventario/
        │   └── __tests__/              ← AGENTE-FE-7
        │       ├── useStock.test.ts
        │       └── useMovimientos.test.ts
        └── configuracion/
            └── __tests__/              ← AGENTE-FE-8
                ├── useSeriesComprobante.test.ts
                └── useTablaGeneral.test.ts
```

---

## 4. Orden de Ejecución de Agentes

```
AGENTE-FE-0 (Setup + Utilidades)
    ├─► AGENTE-FE-1 (Auth)          ─┐
    ├─► AGENTE-FE-2 (Catálogo)      ─┤
    ├─► AGENTE-FE-3 (Clientes)      ─┤
    ├─► AGENTE-FE-4 (Carrito)       ─┤ todos en paralelo
    ├─► AGENTE-FE-5 (Ventas Hooks)  ─┤
    ├─► AGENTE-FE-6 (Compras)       ─┤
    ├─► AGENTE-FE-7 (Inventario)    ─┤
    ├─► AGENTE-FE-8 (Configuración) ─┤
    └─► AGENTE-FE-9 (Componentes)   ─┘
```

**Dependencias**:
- AGENTE-FE-0 debe completarse **antes** que cualquier otro (instala paquetes, crea infraestructura de testing).
- Los agentes FE-1 al FE-9 no tienen dependencias entre sí y pueden ejecutarse en paralelo.

---

## AGENTE-FE-0: Setup de Testing + Tests de Utilidades

**Carpeta objetivo**: `src/__tests__/setup/` + `src/compartido/utilidades/__tests__/`

**Archivos fuente de referencia** (leer antes de empezar):
- `vite.config.ts` — para copiar los aliases de path
- `package.json` — para ver dependencias actuales
- `tsconfig.app.json` — para ver configuración TypeScript
- `src/compartido/utilidades/calculos.ts`
- `src/compartido/utilidades/moneda.ts`
- `src/compartido/utilidades/fecha.ts`
- `src/compartido/utilidades/validacion.ts`
- `src/compartido/configuracion/fiscal.config.ts`

### PASO 1 — Instalar dependencias

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm install --save-dev vitest @vitest/coverage-v8 @testing-library/react @testing-library/user-event @testing-library/jest-dom msw jsdom
```

### PASO 2 — Crear `vitest.config.ts`

```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/__tests__/setup/setup.ts'],
    globals: true,
    css: false,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html'],
      include: ['src/**/*.{ts,tsx}'],
      exclude: [
        'src/componentes/ui/**',
        'src/**/*.d.ts',
        'src/__tests__/**',
        'src/main.tsx',
        'src/App.tsx',
      ],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@features': path.resolve(__dirname, './src/features'),
      '@compartido': path.resolve(__dirname, './src/compartido'),
      '@layouts': path.resolve(__dirname, './src/layouts'),
      '@lib': path.resolve(__dirname, './src/lib'),
      '@/components': path.resolve(__dirname, './src/componentes'),
    },
  },
})
```

### PASO 3 — Agregar scripts en `package.json`

Agregar dentro de `"scripts"`:
```json
"test": "vitest",
"test:run": "vitest run",
"test:coverage": "vitest run --coverage",
"test:ui": "vitest --ui"
```

### PASO 4 — Crear archivos de setup

**`src/__tests__/setup/setup.ts`**
```typescript
import '@testing-library/jest-dom'
import { server } from './mswServer'
import { beforeAll, afterEach, afterAll, vi } from 'vitest'

beforeAll(() => server.listen({ onUnhandledRequest: 'warn' }))
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

const localStorageMock = (() => {
  let store: Record<string, string> = {}
  return {
    getItem: vi.fn((key: string) => store[key] ?? null),
    setItem: vi.fn((key: string, value: string) => { store[key] = value }),
    removeItem: vi.fn((key: string) => { delete store[key] }),
    clear: vi.fn(() => { store = {} }),
  }
})()
Object.defineProperty(window, 'localStorage', { value: localStorageMock })

Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation((query: string) => ({
    matches: false, media: query, onchange: null,
    addListener: vi.fn(), removeListener: vi.fn(),
    addEventListener: vi.fn(), removeEventListener: vi.fn(),
    dispatchEvent: vi.fn(),
  })),
})
```

**`src/__tests__/setup/mswServer.ts`**
```typescript
import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

export const API_BASE = 'http://localhost:5000/api'

export function respuestaPaginadaVacia<T>() {
  return {
    datos: [] as T[],
    total: 0, pageNumber: 1, pageSize: 10,
    totalPages: 0, hasPreviousPage: false, hasNextPage: false,
    status: 200, message: '', transactionId: 'test-id',
  }
}

export const defaultHandlers = [
  http.get(`${API_BASE}/productos`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/categorias`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/marcas`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/ventas`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/compras`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/clientes`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/inventario/stock`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/inventario/movimientos`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/proveedores`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.get(`${API_BASE}/ordenes-compra`, () => HttpResponse.json(respuestaPaginadaVacia())),
  http.post(`${API_BASE}/auth/login`, () =>
    HttpResponse.json({
      token: 'token-test', refreshToken: 'refresh-test',
      usuario: { id: 1, username: 'test', nombres: 'Test', apellidos: 'User', email: 'test@test.com' },
    })
  ),
]

export const server = setupServer(...defaultHandlers)
```

**`src/__tests__/setup/renderWithProviders.tsx`**
```typescript
import React from 'react'
import { render, renderHook, RenderOptions, RenderHookOptions } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { MemoryRouter } from 'react-router-dom'

export function crearQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false, gcTime: 0, staleTime: 0 },
      mutations: { retry: false },
    },
  })
}

function crearWrapper(initialEntries: string[] = ['/']) {
  const queryClient = crearQueryClient()
  return function Wrapper({ children }: { children: React.ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>
        <MemoryRouter initialEntries={initialEntries}>{children}</MemoryRouter>
      </QueryClientProvider>
    )
  }
}

export function renderConProveedores(
  ui: React.ReactElement,
  options?: Omit<RenderOptions, 'wrapper'> & { initialEntries?: string[] }
) {
  const { initialEntries, ...renderOptions } = options ?? {}
  return render(ui, { wrapper: crearWrapper(initialEntries), ...renderOptions })
}

export function renderHookConProveedores<TResult, TProps = void>(
  hook: (props: TProps) => TResult,
  options?: Omit<RenderHookOptions<TProps>, 'wrapper'> & { initialEntries?: string[] }
) {
  const { initialEntries, ...hookOptions } = options ?? {}
  return renderHook(hook, { wrapper: crearWrapper(initialEntries), ...hookOptions })
}
```

### Tests que AGENTE-FE-0 debe implementar

**`src/compartido/utilidades/__tests__/calculos.test.ts`**
- `calcularIGV_ConMonto100_Devuelve18()`
- `calcularIGV_ConMonto0_Devuelve0()`
- `calcularSubtotalDesdeTotal_ConTotal118_Devuelve100()`
- `calcularSubtotal_SinDescuento_EsPrecioXCantidad()`
- `calcularSubtotal_ConDescuento10pct_ReduceElTotal()`
- `calcularTotalesVenta_ConItemGravado_CalculaIGV()` — código afectación "10"
- `calcularTotalesVenta_ConItemExonerado_NoCalculaIGV()` — código "20", igv=0
- `calcularTotalesVenta_ConItemGratuito_VaATotalGratuito()` — código "15", total=0
- `calcularTotalesVenta_ConMultiplesItems_SumaTotalesCorrectamente()`
- `calcularTotalesVenta_ConDescuento_ReduceElTotal()`
- `calcularTotalesVenta_ConListaVacia_DevuelveTodosEnCero()`

**`src/compartido/utilidades/__tests__/moneda.test.ts`**
- `formatMoneda_ConValorEntero_DevuelveFormatoPEN()` — contiene "S/"
- `formatMoneda_ConValorDecimal_DevuelveConDosDecimales()`
- `formatMoneda_ConCero_DevuelveCero()`
- `parsearMoneda_ConStringFormateado_DevuelveNumero()` — "S/ 1,234.56" → 1234.56
- `formatearPorcentaje_Con18_DevuelveString18pct()`

**`src/compartido/utilidades/__tests__/fecha.test.ts`**
- `formatFecha_ConFechaValida_DevuelveString()`
- `formatFecha_ConFechaISO_ContieneAnio()`
- `formatearFechaHora_ConFecha_ContieneHoraYMinutos()`
- `quedenMenosDe24Horas_ConFechaReciente_DevuelveTrue()` — hace 1 hora → true
- `quedenMenosDe24Horas_ConFechaAnterior_DevuelveFalse()` — hace 2 días → false
- `quedenMenosDe24Horas_ConFechaExacta25h_DevuelveFalse()`

**`src/compartido/utilidades/__tests__/validacion.test.ts`**
- `validarRUC_ConRUCValido11Digitos_DevuelveTrue()`
- `validarRUC_Con10Digitos_DevuelveFalse()`
- `validarRUC_ConLetras_DevuelveFalse()`
- `validarRUC_QueComienzaConCero_DevuelveFalse()`
- `validarDNI_ConDNI8Digitos_DevuelveTrue()`
- `validarDNI_Con7Digitos_DevuelveFalse()`
- `validarDNI_Con9Digitos_DevuelveFalse()`
- `validarEmail_ConEmailValido_DevuelveTrue()`
- `validarEmail_SinArroba_DevuelveFalse()`
- `validarTelefono_ConCelularPeruano_DevuelveTrue()` — 9XXXXXXXX
- `validarTelefono_ConStringVacio_DevuelveFalse()`

---

## AGENTE-FE-1: Identidad / Autenticación Tests

**Carpeta objetivo**: `src/features/identidad/__tests__/`

**Archivos fuente de referencia**:
- `src/features/identidad/servicios/authService.ts`
- `src/features/identidad/context/AuthContext.tsx`

### Tests que AGENTE-FE-1 debe implementar

**`src/features/identidad/__tests__/authService.test.ts`**
- `login_ConCredencialesValidas_GuardaTokenEnLocalStorage()`
- `login_ConCredencialesInvalidas_LanzaError()` — respuesta 401 → rechaza
- `logout_LimpiaTokensDelLocalStorage()` — elimina `sc_token` y `sc_refresh`
- `getToken_CuandoHayToken_DevuelveToken()`
- `getToken_CuandoNoHayToken_DevuelveNull()`
- `refresh_ConRefreshTokenValido_ActualizaToken()` — nuevo token en localStorage

**`src/features/identidad/__tests__/AuthContext.test.tsx`**
- `useAuth_InicialmenteSinToken_EstaNoAutenticado()` — estaAutenticado=false, usuario=null
- `useAuth_ConTokenValido_DecodificaRolesCorrectamente()`
- `loginInfo_AlLlamarConDatos_ActualizaEstadoDeAutenticado()` — estaAutenticado=true
- `logout_AlLlamar_LimpiaEstadoDeAutenticacion()` — estaAutenticado=false, usuario=null
- `useAuth_ConRolesEnToken_ExponeLosRoles()` — roles es array no vacío
- `useAuth_ConTokenExpirado_NoAutenticaAlUsuario()`

---

## AGENTE-FE-2: Catálogo Tests

**Carpeta objetivo**: `src/features/catalogo/__tests__/`

**Archivos fuente de referencia**:
- `src/features/catalogo/hooks/useProductos.ts`
- `src/features/catalogo/hooks/useMarcas.ts`
- `src/features/catalogo/hooks/useCategorias.ts`
- `src/features/catalogo/servicios/servicioProductos.ts`
- `src/features/catalogo/tipos/catalogo.types.ts`

### Tests que AGENTE-FE-2 debe implementar

**`src/features/catalogo/__tests__/useProductos.test.ts`**
- `useProductos_ConRespuestaExitosa_DevuelveListaDeDatos()`
- `useProductos_ConError500_DevuelveEstadoError()`
- `useProductos_EnEstadoCargando_DevuelveIsLoading()`
- `useProducto_ConIdValido_DevuelveDetalleDelProducto()`
- `useProducto_ConIdUndefined_NoHaceLlamada()` — fetchStatus='idle'
- `useCrearProducto_ConDatosValidos_LlamaAlEndpointPost()` — responde id=99
- `useActualizarProducto_ConIdYDatos_LlamaAlEndpointPut()`
- `useEliminarProducto_ConIdValido_LlamaAlEndpointDelete()`

**`src/features/catalogo/__tests__/useMarcas.test.ts`**
- `useMarcas_ConRespuestaExitosa_DevuelveLista()`
- `useCrearMarca_ConDatosValidos_CreaLaMarca()`
- `useEliminarMarca_ConId_LlamaDelete()`

**`src/features/catalogo/__tests__/useCategorias.test.ts`**
- `useCategorias_ConRespuestaExitosa_DevuelveLista()`
- `useCrearCategoria_ConDatosValidos_CreaLaCategoria()`
- `useActualizarCategoria_ConIdYDatos_ActualizaLaCategoria()`

---

## AGENTE-FE-3: Clientes Tests

**Carpeta objetivo**: `src/features/clientes/__tests__/`

**Archivos fuente de referencia**:
- `src/features/clientes/hooks/useClientes.ts` (o `src/features/ventas/hooks/useClientes.ts`)
- `src/features/clientes/servicios/servicioClientes.ts`
- `src/features/clientes/types/cliente.types.ts`

### Tests que AGENTE-FE-3 debe implementar

**`src/features/clientes/__tests__/useClientes.test.ts`**
- `useClientes_ConRespuestaExitosa_DevuelveListaPaginada()`
- `useClientes_ConError_DevuelveEstadoError()`
- `useCliente_ConIdValido_DevuelveDetalleCompleto()`
- `useCrearCliente_ConDniValido_CreaElCliente()` — idTipoDocumento=1, 8 dígitos
- `useCrearCliente_ConRucValido_CreaElCliente()` — idTipoDocumento=6, 11 dígitos
- `useActualizarCliente_ConDatosNuevos_ActualizaElCliente()`
- `useEliminarCliente_ConId_LlamaDelete()`
- `useBuscarClientePorDocumento_ConDni8Digitos_EjecutaLaBusqueda()` — enabled cuando length>=8
- `useBuscarClientePorDocumento_ConMenos8Digitos_NoEjecutaLaBusqueda()` — fetchStatus='idle'
- `useHistorialCompras_ConIdCliente_DevuelveHistorial()`

---

## AGENTE-FE-4: Carrito de Ventas (Zustand) Tests

**Carpeta objetivo**: `src/features/ventas/__tests__/useCarrito.test.ts`

**Archivos fuente de referencia**:
- `src/features/ventas/hooks/useCarrito.ts`
- `src/compartido/utilidades/calculos.ts`
- `src/compartido/configuracion/fiscal.config.ts`

> Este es el único agente que NO usa MSW. El carrito es estado local puro (Zustand).

### Conocimiento crítico: Códigos de afectación IGV (SUNAT)

| Código | Tipo | Efecto en totales |
|--------|------|-------------------|
| `10` | Gravado | Se calcula IGV 18% |
| `20` | Exonerado | Sin IGV |
| `30` | Inafecto | Sin IGV |
| `11`–`16` | Gratuito gravado | Va a `totalGratuito`, total=0 |
| `21`, `31`–`36` | Gratuito otros | Va a `totalGratuito`, total=0 |

### Tests que AGENTE-FE-4 debe implementar

> Siempre `beforeEach(() => useCarrito.getState().limpiarCarrito())` y envolver en `act(...)`.

**`src/features/ventas/__tests__/useCarrito.test.ts`**
- `agregarProducto_ConProductoNuevo_AgregaItemAlCarrito()`
- `agregarProducto_ConProductoYaExistente_SumaCantidad()` — mismo id: 2+3=5 unidades
- `agregarProducto_ConProductoGravado_CalculaIGV()` — igv > 0
- `agregarProducto_ConProductoExonerado_NoCalculaIGV()` — igv = 0
- `agregarProducto_ConProductoGratuito_NoSumaAlTotalCobrado()` — total=0, totalGratuito>0
- `agregarProducto_ConDescuento_AplicaDescuentoAlSubtotal()` — 10% de 100 = 90
- `actualizarCantidad_ConNuevaCantidad_ActualizaYRecalcula()`
- `actualizarCantidad_ConCantidadCeroONegativa_EliminaElItem()`
- `actualizarDescuento_ConPorcentaje10_ReduceElTotal()`
- `eliminarProducto_ConId_RemueveElItemDelCarrito()`
- `eliminarProducto_ConId_RecalculaTotales()`
- `limpiarCarrito_ConItemsEnElCarrito_VaciaElCarritoYResetaTotales()` — items=[], total=0, igv=0
- `obtenerCantidadItems_ConMultiplesItems_DevuelveSumaDeCantidades()` — 3+2=5
- `obtenerCantidadItems_SinItems_DevuelveCero()`
- `carrito_ConItemsGravadosYExonerados_DistribuyeCorrectamente()` — igv solo del gravado

---

## AGENTE-FE-5: Ventas Hooks Tests

**Carpeta objetivo**: `src/features/ventas/__tests__/useVentas.test.ts`

**Archivos fuente de referencia**:
- `src/features/ventas/hooks/useVentas.ts`
- `src/features/ventas/servicios/servicioVentas.ts`
- `src/features/ventas/servicios/servicioCajas.ts`
- `src/features/ventas/tipos/ventas.types.ts`

### Tests que AGENTE-FE-5 debe implementar

**`src/features/ventas/__tests__/useVentas.test.ts`**
- `useVentas_ConRespuestaExitosa_DevuelveListaPaginada()` — datos[0].serie='B001'
- `useVenta_ConIdValido_DevuelveDetalleCompleto()` — tiene detalles[] y pagos[]
- `useVenta_ConIdUndefined_NoEjecutaLaQuery()` — fetchStatus='idle'
- `useCrearVenta_ConDatosValidos_CreaLaVenta()` — id=99
- `useCrearVenta_ConError400_DevuelveEstadoError()`
- `useAnularVenta_ConMotivoValido_AnulaLaVenta()` — PATCH /ventas/{id}/anular
- `useVentasDelDia_DevuelveVentasDelDiaActual()` — GET /ventas/hoy
- `useEstadisticasVentas_ConFechas_DevuelveEstadisticas()` — enabled cuando ambas fechas existen
- `useEstadisticasVentas_SinFechas_NoEjecutaLaQuery()` — fetchStatus='idle'
- `useRankingProductos_ConFechas_DevuelveRanking()` — GET /ventas/reportes/ranking-productos
- `useTopClientes_ConFechas_DevuelveTopClientes()` — GET /ventas/reportes/top-clientes
- `useCajas_ConRespuestaExitosa_DevuelveLista()` — GET /cajas
- `useRegistrarMovimientoCaja_ConDatosValidos_RegistraElMovimiento()` — POST /cajas/{id}/movimientos

---

## AGENTE-FE-6: Compras, Órdenes y Proveedores Tests

**Carpeta objetivo**: `src/features/compras/**/__tests__/`

**Archivos fuente de referencia**:
- `src/features/compras/compras/hooks/useCompras.ts`
- `src/features/compras/compras/servicios/servicioCompras.ts`
- `src/features/compras/compras/types/compra.types.ts`
- `src/features/compras/ordenes-compra/hooks/useOrdenesCompra.ts`
- `src/features/compras/ordenes-compra/servicios/ordenCompraService.ts`
- `src/features/compras/ordenes-compra/types/ordenCompra.types.ts`
- `src/features/compras/proveedores/hooks/useProveedores.ts`
- `src/features/compras/proveedores/servicios/servicioProveedores.ts`

### Tests que AGENTE-FE-6 debe implementar

**`src/features/compras/compras/__tests__/useCompras.test.ts`**
- `useCompras_ConRespuestaExitosa_DevuelveListaPaginada()` — datos[0].serieComprobante='F001'
- `useCompra_ConIdValido_DevuelveDetalleCompleto()`
- `useRegistrarCompra_ConDatosValidos_RegistraLaCompra()`
- `useEliminarCompra_ConId_LlamaDelete()`
- `useReporteComprasProveedor_ConFechas_DevuelveReporte()` — GET /compras/reportes/compras-proveedor

**`src/features/compras/ordenes-compra/__tests__/useOrdenesCompra.test.ts`**
- `useOrdenesCompra_ConRespuestaExitosa_DevuelveLista()` — datos[0].codigoOrden='OC-001'
- `useSiguienteNumeroOrdenCompra_DevuelveElSiguienteNumero()` — 'OC-002', staleTime=0
- `useOrdenCompra_ConIdValido_DevuelveDetalleConLineas()` — detalles.length=1
- `useRegistrarOrdenCompra_ConDatosValidos_CreaLaOrden()`
- `useCambiarEstadoOrdenCompra_DeBorradorAPendiente_CambiaElEstado()` — idEstado=41 (Aprobada)

**`src/features/compras/proveedores/__tests__/useProveedores.test.ts`**
- `useProveedores_ConRespuestaExitosa_DevuelveLista()` — datos[0].razonSocial='Proveedor SAC'
- `useProveedor_ConId_DevuelveDetalleDelProveedor()` — numeroDocumento='20123456789'
- `useCrearProveedor_ConRucValido_CreaElProveedor()` — RUC 11 dígitos
- `useActualizarProveedor_ConDatosNuevos_ActualizaElProveedor()`
- `useEliminarProveedor_ConId_LlamaDelete()`

---

## AGENTE-FE-7: Inventario Tests

**Carpeta objetivo**: `src/features/inventario/__tests__/`

**Archivos fuente de referencia**:
- `src/features/inventario/hooks/useInventario.ts`
- `src/features/inventario/servicios/servicioInventario.ts`
- `src/features/inventario/tipos/inventario.types.ts`
- `src/features/inventario/almacenes/hooks/useAlmacenes.ts`
- `src/features/inventario/almacenes/servicios/servicioAlmacenes.ts`

### Conocimiento del dominio

| ID | Tipo de movimiento |
|----|-------------------|
| 19 | ING_COM (entrada por compra) |
| 20 | SAL_VEN (salida por venta) |
| 24 | DevolucionCompra |
| 25 | DevolucionVenta |

### Tests que AGENTE-FE-7 debe implementar

**`src/features/inventario/__tests__/useStock.test.ts`**
- `useStock_ConRespuestaExitosa_DevuelveStockPaginado()` — cantidadActual=100
- `useStockCritico_DevuelveProductosBajoMinimo()` — cantidadActual < cantidadMinima
- `useAjustarStock_ConNuevaCantidad_EnviaAjuste()` — POST /inventario/stock/ajuste

**`src/features/inventario/__tests__/useMovimientos.test.ts`**
- `useMovimientos_ConRespuestaExitosa_DevuelveLista()` — tipoMovimientoNombre='ING_COM'
- `useMovimiento_ConId_DevuelveDetalleCompleto()` — cantidadAnterior=90, cantidadNueva=100
- `useRegistrarMovimiento_ConMovimientoEntrada_RegistraCorrectamente()` — idTipoMovimiento=19
- `useKardex_ConProductoYAlmacenYFechas_DevuelveKardex()` — resumen.stockFinal=100
- `useKardex_SinParametros_NoEjecutaLaQuery()` — fetchStatus='idle'
- `useAlmacenes_ConRespuestaExitosa_DevuelveLista()` — datos[0].nombre='Almacén Principal'
- `useCrearAlmacen_ConDatosValidos_CreaElAlmacen()` — id=99
- `useActualizarAlmacen_ConDatosNuevos_ActualizaElAlmacen()`
- `useEliminarAlmacen_ConId_LlamaDelete()`

---

## AGENTE-FE-8: Configuración Tests

**Carpeta objetivo**: `src/features/configuracion/__tests__/`

**Archivos fuente de referencia**:
- `src/features/configuracion/hooks/useSeriesComprobante.ts`
- `src/features/configuracion/hooks/useTablaGeneral.ts`
- `src/features/configuracion/hooks/useImpuestos.ts`
- `src/features/configuracion/hooks/useTipoComprobante.ts`
- `src/features/configuracion/servicios/servicioSerieComprobante.ts`
- `src/features/configuracion/servicios/servicioTablaGeneral.ts`

### Conocimiento del dominio

**Series de comprobante SUNAT**:
| Serie | Tipo |
|-------|------|
| `F001` | Factura |
| `B001` | Boleta |
| `FC01` | Nota de Crédito |
| `FD01` | Nota de Débito |

**IGV**: Porcentaje 18.00%, ID=1000, código='1000'

### Tests que AGENTE-FE-8 debe implementar

**`src/features/configuracion/__tests__/useSeriesComprobante.test.ts`**
- `useSeriesComprobante_ConRespuestaExitosa_DevuelveLista()` — datos[0].serie='F001'
- `useSerieComprobante_ConId_DevuelveDetalleConUltimoNumero()` — ultimoNumero=42
- `useCrearSerieComprobante_ConSerieF001_CreaLaSerie()`
- `useActualizarSerieComprobante_ConDatosNuevos_ActualizaLaSerie()`

**`src/features/configuracion/__tests__/useTablaGeneral.test.ts`**
- `useTablasGenerales_ConRespuestaExitosa_DevuelveLista()` — nombre='Estados de Documento'
- `useDetallesTablaGeneral_ConTablaId_DevuelveDetalles()` — datos[0].nombre='Registrado'
- `useDetallesTablaGeneral_ConIdUndefined_NoEjecutaLaQuery()` — fetchStatus='idle'
- `useImpuestos_DevuelveImpuestoConIGV()` — porcentaje=18, codigo='1000'
- `useTipoComprobante_DevuelveTiposDeComprobante()` — codigo='01'
- `useTipoComprobante_DevuelveFacturaYBoleta()` — codigos contiene '01' y '03'

---

## AGENTE-FE-9: Componentes Compartidos Tests

**Carpeta objetivo**: `src/compartido/__tests__/`

**Archivos fuente de referencia**:
- `src/compartido/hooks/usePermiso.ts`
- `src/compartido/componentes/tablas/TablaPaginada.tsx`
- `src/compartido/componentes/seguridad/RutaProtegida.tsx`
- `src/features/identidad/context/AuthContext.tsx`

### Tests que AGENTE-FE-9 debe implementar

**`src/compartido/__tests__/usePermiso.test.ts`**

> Mock de AuthContext necesario. Permisos tienen formato `"MODULO:ACCION"` (VER/CREAR/EDITAR/ELIMINAR).

- `usePermiso_ConPermisoEnLaLista_DevuelveTrue()` — 'VENTAS:VER' → true
- `usePermiso_SinElPermiso_DevuelveFalse()` — tiene VER pero no ELIMINAR → false
- `usePermiso_ConPermisoDeOtroModulo_DevuelveFalse()` — VENTAS:VER no da CATALOGO:VER
- `usePermisoMenu_ConAlgunPermisoEnElMenu_DevuelveTrue()` — cualquier VENTAS:* → true
- `usePermisoMenu_SinNingunPermisoEnElMenu_DevuelveFalse()`
- `useEsAdmin_ConRolAdmin_DevuelveTrue()`
- `useEsAdmin_ConRolVendedor_DevuelveFalse()`

**`src/compartido/__tests__/TablaPaginada.test.tsx`**

> Leer el componente para conocer la interfaz exacta de props antes de escribir.

- `TablaPaginada_ConDatos_RenderizaLasFilas()` — "Item 1" en pantalla
- `TablaPaginada_EnEstadoCargando_MuestraIndicadorDeCarga()` — datos no visibles
- `TablaPaginada_SinDatos_MuestraMensajeVacio()`
- `TablaPaginada_AlHacerClickEnSiguiente_LlamaOnCambioPagina()` — llamada con página 2
- `TablaPaginada_RenderizaEncabezadosDeColumnas()` — cabeceras en DOM

**`src/compartido/__tests__/RutaProtegida.test.tsx`**

> Mock de AuthContext necesario para controlar estado de autenticación.

- `RutaProtegida_UsuarioAutenticadoConPermiso_RenderizaLosHijos()`
- `RutaProtegida_UsuarioSinPermiso_NoRenderizaLosHijos()`
- `RutaProtegida_UsuarioNoAutenticado_NoRenderizaLosHijos()`
- `RutaProtegida_UsuarioAdmin_SiempreTieneAcceso()`

---

## 5. Consideraciones Especiales para Gemini Flash

### 5.1 Patrón de override de handler MSW por test

```typescript
// Para forzar un error en un test específico:
server.use(
  http.get(`${API_BASE}/productos`, () =>
    HttpResponse.json({ message: 'Error' }, { status: 500 })
  )
)
// El handler se resetea automáticamente en afterEach(() => server.resetHandlers())
```

### 5.2 Patrón de renderHook con React Query

```typescript
import { renderHook, waitFor } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'

it('hook resuelve datos', async () => {
  // Act
  const { result } = renderHookConProveedores(() => useProductos())

  // Assert — siempre waitFor para queries asincrónicas
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data?.datos).toHaveLength(1)
})
```

### 5.3 Patrón de mutation test

```typescript
it('mutacion crea recurso', async () => {
  server.use(
    http.post(`${API_BASE}/productos`, () =>
      HttpResponse.json({ id: 99, nombre: 'Test' }, { status: 201 })
    )
  )
  const { result } = renderHookConProveedores(() => useCrearProducto())

  act(() => { result.current.mutate({ nombre: 'Test' } as any) })

  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data?.id).toBe(99)
})
```

### 5.4 Patrón de Zustand store testing

```typescript
import { act } from '@testing-library/react'

beforeEach(() => {
  useCarrito.getState().limpiarCarrito() // reset entre tests
})

it('agrega producto', () => {
  act(() => {
    useCarrito.getState().agregarProducto(productoTest, 2)
  })
  expect(useCarrito.getState().items).toHaveLength(1)
  expect(useCarrito.getState().items[0].cantidad).toBe(2)
})
```

### 5.5 Verificar query deshabilitada (enabled: false)

```typescript
it('hook no ejecuta cuando falta parámetro', () => {
  const { result } = renderHookConProveedores(
    () => useProducto(undefined as any)
  )
  // 'idle' significa que no ejecutó la query
  expect(result.current.fetchStatus).toBe('idle')
})
```

### 5.6 Calcularía de totales con afectación SUNAT

El carrito usa `calcularTotalesVenta(items)` donde los precios **incluyen IGV** para items gravados.
La función extrae el IGV: `igv = subtotalGravado * 0.18`, donde `subtotalGravado = precioConIGV / 1.18`.

Para un item con precio=118 (código "10"):
- `subtotalGravado = 118 / 1.18 ≈ 100`
- `igv = 100 * 0.18 = 18`
- `total = 118`

---

## 6. Cronograma Estimado

| Sprint | Agentes | Duración estimada |
|--------|---------|-------------------|
| Sprint 1 | AGENTE-FE-0 (Setup + Utilidades) | 1 día |
| Sprint 2 | AGENTES FE-1 al FE-9 en paralelo | 3 días |
| **Total** | | **~4 días** |

---

## 7. Metas de Cobertura

| Módulo | Tipo | Archivos cubiertos | Objetivo |
|--------|------|--------------------|----------|
| Utilidades puras | Unit | calculos, moneda, fecha, validacion | **95%** |
| Auth | Unit | authService, AuthContext | **90%** |
| Catálogo | Hooks + API mock | useProductos, useMarcas, useCategorias | **85%** |
| Clientes | Hooks + API mock | useClientes | **85%** |
| Carrito | Zustand | useCarrito | **95%** |
| Ventas | Hooks + API mock | useVentas, useCajas | **85%** |
| Compras | Hooks + API mock | useCompras, useOrdenesCompra, useProveedores | **85%** |
| Inventario | Hooks + API mock | useStock, useMovimientos, useKardex, useAlmacenes | **85%** |
| Configuración | Hooks + API mock | useSeriesComprobante, useTablaGeneral, useImpuestos | **80%** |
| Componentes | Component tests | TablaPaginada, RutaProtegida, usePermiso | **75%** |

---

## 8. Comandos de Verificación por Agente

```bash
# FE-0: verificar setup completo
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/compartido/utilidades/__tests__/

# FE-1
npm run test:run -- src/features/identidad/__tests__/

# FE-2
npm run test:run -- src/features/catalogo/__tests__/

# FE-3
npm run test:run -- src/features/clientes/__tests__/

# FE-4
npm run test:run -- src/features/ventas/__tests__/useCarrito.test.ts

# FE-5
npm run test:run -- src/features/ventas/__tests__/useVentas.test.ts

# FE-6
npm run test:run -- src/features/compras/

# FE-7
npm run test:run -- src/features/inventario/__tests__/

# FE-8
npm run test:run -- src/features/configuracion/__tests__/

# FE-9
npm run test:run -- src/compartido/__tests__/

# Todos los tests
npm run test:run

# Con cobertura
npm run test:coverage
```

---

*Versión 1.0 — 2026-04-23. Cubre: React 18 + Vitest + MSW + RTL + Zustand. 10 agentes, ~130 tests totales estimados.*
