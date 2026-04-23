# AGENTE-FE-0 — Setup de Testing + Tests de Utilidades

## Contexto del proyecto

Eres un agente especializado en configurar infraestructura de testing para un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

El frontend usa: React 18 · TypeScript · Vite · TanStack Query v5 · Zustand v5 · Axios · react-router-dom v6

**Actualmente NO existe ninguna configuración de testing.** Tu misión es instalar el stack, configurarlo y escribir los primeros tests sobre las funciones utilitarias puras.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
vite.config.ts
package.json
tsconfig.app.json
src/compartido/utilidades/calculos.ts
src/compartido/utilidades/moneda.ts
src/compartido/utilidades/fecha.ts
src/compartido/utilidades/validacion.ts
src/compartido/configuracion/fiscal.config.ts
src/lib/axios.ts
```

Lee TODOS estos archivos antes de escribir cualquier código.

## PASO 1 — Instalar dependencias de testing

Ejecutar en la terminal (desde la carpeta del frontend):
```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm install --save-dev vitest @vitest/coverage-v8 @testing-library/react @testing-library/user-event @testing-library/jest-dom msw jsdom
```

## PASO 2 — Crear `vitest.config.ts`

Crear el archivo `D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\vitest.config.ts`:

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

## PASO 3 — Agregar scripts de test en `package.json`

Agregar dentro de `"scripts"` (no borrar los existentes):
```json
"test": "vitest",
"test:run": "vitest run",
"test:coverage": "vitest run --coverage",
"test:ui": "vitest --ui"
```

## PASO 4 — Crear archivos de setup

### `src/__tests__/setup/setup.ts`
```typescript
import '@testing-library/jest-dom'
import { server } from './mswServer'
import { beforeAll, afterEach, afterAll, vi } from 'vitest'

beforeAll(() => server.listen({ onUnhandledRequest: 'warn' }))
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

// Mock de localStorage para todos los tests
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

// Mock de window.matchMedia (necesario para algunos componentes de UI)
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation((query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: vi.fn(),
    removeListener: vi.fn(),
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
    dispatchEvent: vi.fn(),
  })),
})
```

### `src/__tests__/setup/mswServer.ts`
```typescript
import { setupServer } from 'msw/node'
import { http, HttpResponse } from 'msw'

export const API_BASE = 'http://localhost:5000/api'

// Respuesta paginada vacía reutilizable
export function respuestaPaginadaVacia<T>(): {
  datos: T[]
  total: number
  pageNumber: number
  pageSize: number
  totalPages: number
  hasPreviousPage: boolean
  hasNextPage: boolean
  status: number
  message: string
  transactionId: string
} {
  return {
    datos: [],
    total: 0,
    pageNumber: 1,
    pageSize: 10,
    totalPages: 0,
    hasPreviousPage: false,
    hasNextPage: false,
    status: 200,
    message: '',
    transactionId: 'test-id',
  }
}

// Handlers por defecto — retornan listas vacías para no romper tests de otros módulos
export const defaultHandlers = [
  http.get(`${API_BASE}/productos`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/categorias`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/marcas`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/ventas`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/compras`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/clientes`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/inventario/stock`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/inventario/movimientos`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/proveedores`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/ordenes-compra`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/configuracion/series-comprobante`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.get(`${API_BASE}/configuracion/tablas-generales`, () =>
    HttpResponse.json(respuestaPaginadaVacia())
  ),
  http.post(`${API_BASE}/auth/login`, () =>
    HttpResponse.json({
      token: 'token-test',
      refreshToken: 'refresh-test',
      usuario: { id: 1, username: 'test', nombres: 'Test', apellidos: 'User', email: 'test@test.com' },
    })
  ),
]

export const server = setupServer(...defaultHandlers)
```

### `src/__tests__/setup/renderWithProviders.tsx`
```typescript
import React from 'react'
import { render, renderHook, RenderOptions, RenderHookOptions } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { MemoryRouter } from 'react-router-dom'

export function crearQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
        gcTime: 0,
        staleTime: 0,
      },
      mutations: {
        retry: false,
      },
    },
  })
}

function crearWrapper(initialEntries: string[] = ['/']) {
  const queryClient = crearQueryClient()
  return function Wrapper({ children }: { children: React.ReactNode }) {
    return (
      <QueryClientProvider client={queryClient}>
        <MemoryRouter initialEntries={initialEntries}>
          {children}
        </MemoryRouter>
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

## PASO 5 — Crear tests de utilidades puras

> **IMPORTANTE**: Lee cada archivo fuente antes de escribir su test. Las funciones reales pueden tener firmas distintas a las documentadas. Adapta los assertions a lo que realmente exporta el módulo.

### `src/compartido/utilidades/__tests__/calculos.test.ts`

Lee `src/compartido/utilidades/calculos.ts` primero. Luego implementa:

```typescript
import { describe, it, expect } from 'vitest'
// Importar todas las funciones exportadas por calculos.ts
// Ajustar nombres de import según lo que realmente exporte el módulo

describe('calcularIGV', () => {
  it('calcularIGV_ConMonto100_Devuelve18', () => {
    // Arrange
    const monto = 100

    // Act
    const resultado = calcularIGV(monto)

    // Assert
    expect(resultado).toBeCloseTo(18, 2)
  })

  it('calcularIGV_ConMonto0_Devuelve0', () => {
    expect(calcularIGV(0)).toBe(0)
  })

  it('calcularIGV_ConMonto200_Devuelve36', () => {
    expect(calcularIGV(200)).toBeCloseTo(36, 2)
  })
})

describe('calcularSubtotalDesdeTotal', () => {
  it('calcularSubtotalDesdeTotal_ConTotal118_Devuelve100', () => {
    expect(calcularSubtotalDesdeTotal(118)).toBeCloseTo(100, 2)
  })

  it('calcularSubtotalDesdeTotal_ConTotal0_Devuelve0', () => {
    expect(calcularSubtotalDesdeTotal(0)).toBe(0)
  })
})

describe('calcularSubtotal', () => {
  it('calcularSubtotal_SinDescuento_EsPrecioXCantidad', () => {
    // precio=100, cantidad=3, descuento=0 → 300
    const resultado = calcularSubtotal(100, 3, 0)
    expect(resultado).toBeCloseTo(300, 2)
  })

  it('calcularSubtotal_ConDescuento10pct_ReduceElTotal', () => {
    // precio=100, cantidad=1, descuento=10 → 90
    const resultado = calcularSubtotal(100, 1, 10)
    expect(resultado).toBeCloseTo(90, 2)
  })
})

describe('calcularTotal', () => {
  it('calcularTotal_ConSubtotal100_DevuelveTotalConIGV', () => {
    // subtotal=100 → total=118 (o 100+IGV según implementación)
    const resultado = calcularTotal(100)
    expect(resultado).toBeGreaterThan(100)
  })
})

describe('calcularTotalesVenta', () => {
  it('calcularTotalesVenta_ConItemGravado_CalulaIGV', () => {
    // Arrange — item gravado (código SUNAT "10")
    // Lee el tipo real del item en calculos.ts y ajusta la estructura
    const items = [
      {
        precio: 118,
        cantidad: 1,
        porcentajeDescuento: 0,
        codigoAfectacion: '10',
      },
    ]

    // Act
    const resultado = calcularTotalesVenta(items)

    // Assert
    expect(resultado.igv).toBeGreaterThan(0)
    expect(resultado.total).toBeCloseTo(118, 0)
    expect(resultado.subtotalGravado).toBeGreaterThan(0)
  })

  it('calcularTotalesVenta_ConItemExonerado_NoCalulaIGV', () => {
    const items = [
      {
        precio: 100,
        cantidad: 1,
        porcentajeDescuento: 0,
        codigoAfectacion: '20',
      },
    ]

    const resultado = calcularTotalesVenta(items)

    expect(resultado.igv).toBe(0)
    expect(resultado.subtotalExonerado).toBeCloseTo(100, 0)
    expect(resultado.total).toBeCloseTo(100, 0)
  })

  it('calcularTotalesVenta_ConItemGratuito_VaATotalGratuito', () => {
    const items = [
      {
        precio: 100,
        cantidad: 1,
        porcentajeDescuento: 0,
        codigoAfectacion: '15', // gratuito
      },
    ]

    const resultado = calcularTotalesVenta(items)

    expect(resultado.totalGratuito).toBeGreaterThan(0)
    expect(resultado.total).toBe(0) // gratuito no suma al total cobrado
  })

  it('calcularTotalesVenta_ConMultiplesItems_SumaTotalesCorrectamente', () => {
    // 1 item gravado + 1 exonerado
    const items = [
      { precio: 118, cantidad: 1, porcentajeDescuento: 0, codigoAfectacion: '10' },
      { precio: 50, cantidad: 2, porcentajeDescuento: 0, codigoAfectacion: '20' },
    ]

    const resultado = calcularTotalesVenta(items)

    expect(resultado.total).toBeCloseTo(218, 0) // 118 + 100
    expect(resultado.igv).toBeGreaterThan(0)
    expect(resultado.subtotalExonerado).toBeCloseTo(100, 0)
  })

  it('calcularTotalesVenta_ConDescuento_ReduceElTotal', () => {
    const items = [
      { precio: 100, cantidad: 1, porcentajeDescuento: 10, codigoAfectacion: '20' },
    ]

    const resultado = calcularTotalesVenta(items)

    expect(resultado.total).toBeCloseTo(90, 0)
  })

  it('calcularTotalesVenta_ConListaVacia_DevuelveTodosEnCero', () => {
    const resultado = calcularTotalesVenta([])

    expect(resultado.total).toBe(0)
    expect(resultado.igv).toBe(0)
    expect(resultado.subtotal).toBe(0)
  })
})
```

### `src/compartido/utilidades/__tests__/moneda.test.ts`

Lee `src/compartido/utilidades/moneda.ts` primero. Luego implementa:

```typescript
import { describe, it, expect } from 'vitest'
// Importar funciones según lo que exporte moneda.ts

describe('formatMoneda', () => {
  it('formatMoneda_ConValorEntero_DevuelveFormatoPEN', () => {
    // Arrange
    const valor = 1234

    // Act
    const resultado = formatMoneda(valor)

    // Assert — debe contener "S/" y el número
    expect(resultado).toContain('S/')
    expect(resultado).toContain('1')
  })

  it('formatMoneda_ConValorDecimal_DevuelveConDosDecimales', () => {
    const resultado = formatMoneda(1234.5)
    expect(resultado).toContain('1')
    expect(resultado).toMatch(/\d+[.,]\d{2}/)
  })

  it('formatMoneda_ConCero_DevuelveCero', () => {
    const resultado = formatMoneda(0)
    expect(resultado).toContain('0')
  })
})

describe('formatDecimal', () => {
  it('formatDecimal_ConValor1234_DevuelveFormateado', () => {
    const resultado = formatDecimal(1234.567, 2)
    expect(resultado).toMatch(/1[.,]234[.,]57|1234[.,]57/)
  })
})

describe('parsearMoneda', () => {
  it('parsearMoneda_ConStringFormateado_DevuelveNumero', () => {
    // "S/ 1,234.56" → 1234.56
    const resultado = parsearMoneda('S/ 1,234.56')
    expect(resultado).toBeCloseTo(1234.56, 2)
  })

  it('parsearMoneda_ConCero_Devuelve0', () => {
    expect(parsearMoneda('S/ 0.00')).toBe(0)
  })
})

describe('formatearPorcentaje', () => {
  it('formatearPorcentaje_Con18_DevuelveString18pct', () => {
    const resultado = formatearPorcentaje(18)
    expect(resultado).toContain('18')
  })
})
```

### `src/compartido/utilidades/__tests__/fecha.test.ts`

Lee `src/compartido/utilidades/fecha.ts` primero. Luego implementa:

```typescript
import { describe, it, expect } from 'vitest'
// Importar funciones según lo que exporte fecha.ts

describe('formatFecha / formatearFecha', () => {
  it('formatFecha_ConFechaValida_DevuelveString', () => {
    const fecha = new Date('2024-01-15T10:00:00')
    const resultado = formatFecha(fecha)
    expect(typeof resultado).toBe('string')
    expect(resultado.length).toBeGreaterThan(0)
  })

  it('formatFecha_ConFechaISO_ContieneAnio', () => {
    const resultado = formatFecha(new Date('2024-06-15'))
    expect(resultado).toContain('2024')
  })
})

describe('formatearFechaHora', () => {
  it('formatearFechaHora_ConFecha_ContieneHoraYMinutos', () => {
    const fecha = new Date('2024-01-15T10:30:00')
    const resultado = formatearFechaHora(fecha)
    expect(resultado).toMatch(/\d{2}:\d{2}/)
  })
})

describe('quedenMenosDe24Horas', () => {
  it('quedenMenosDe24Horas_ConFechaReciente_DevuelveTrue', () => {
    const ahoraHace1Hora = new Date(Date.now() - 60 * 60 * 1000)
    expect(quedenMenosDe24Horas(ahoraHace1Hora)).toBe(true)
  })

  it('quedenMenosDe24Horas_ConFechaAnterior_DevuelveFalse', () => {
    const hace2Dias = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000)
    expect(quedenMenosDe24Horas(hace2Dias)).toBe(false)
  })

  it('quedenMenosDe24Horas_ConFechaExacta24h_DevuelveFalse', () => {
    const hace25Horas = new Date(Date.now() - 25 * 60 * 60 * 1000)
    expect(quedenMenosDe24Horas(hace25Horas)).toBe(false)
  })
})

describe('formatearFechaRelativa', () => {
  it('formatearFechaRelativa_ConFechaReciente_DevuelveStringRelativo', () => {
    const hace5Min = new Date(Date.now() - 5 * 60 * 1000)
    const resultado = formatearFechaRelativa(hace5Min)
    expect(typeof resultado).toBe('string')
    expect(resultado.length).toBeGreaterThan(0)
  })
})
```

### `src/compartido/utilidades/__tests__/validacion.test.ts`

Lee `src/compartido/utilidades/validacion.ts` primero. Luego implementa:

```typescript
import { describe, it, expect } from 'vitest'
// Importar funciones según lo que exporte validacion.ts

describe('validarRUC', () => {
  it('validarRUC_ConRUCValido_DevuelveTrue', () => {
    // RUC de prueba válido (11 dígitos, comienza con 1 o 2)
    expect(validarRUC('20123456789')).toBe(true)
  })

  it('validarRUC_ConMenos11Digitos_DevuelveFalse', () => {
    expect(validarRUC('2012345678')).toBe(false) // 10 dígitos
  })

  it('validarRUC_ConMas11Digitos_DevuelveFalse', () => {
    expect(validarRUC('201234567890')).toBe(false) // 12 dígitos
  })

  it('validarRUC_ConLetras_DevuelveFalse', () => {
    expect(validarRUC('2012345678A')).toBe(false)
  })

  it('validarRUC_ConStringVacio_DevuelveFalse', () => {
    expect(validarRUC('')).toBe(false)
  })

  it('validarRUC_QueComienzaConCero_DevuelveFalse', () => {
    // RUC no puede empezar con 0
    expect(validarRUC('00123456789')).toBe(false)
  })
})

describe('validarDNI', () => {
  it('validarDNI_ConDNI8Digitos_DevuelveTrue', () => {
    expect(validarDNI('12345678')).toBe(true)
  })

  it('validarDNI_ConMenos8Digitos_DevuelveFalse', () => {
    expect(validarDNI('1234567')).toBe(false)
  })

  it('validarDNI_ConMas8Digitos_DevuelveFalse', () => {
    expect(validarDNI('123456789')).toBe(false)
  })

  it('validarDNI_ConLetras_DevuelveFalse', () => {
    expect(validarDNI('1234567A')).toBe(false)
  })

  it('validarDNI_ConStringVacio_DevuelveFalse', () => {
    expect(validarDNI('')).toBe(false)
  })
})

describe('validarEmail', () => {
  it('validarEmail_ConEmailValido_DevuelveTrue', () => {
    expect(validarEmail('usuario@empresa.com')).toBe(true)
  })

  it('validarEmail_SinArroba_DevuelveFalse', () => {
    expect(validarEmail('usuarioempresa.com')).toBe(false)
  })

  it('validarEmail_SinDominio_DevuelveFalse', () => {
    expect(validarEmail('usuario@')).toBe(false)
  })

  it('validarEmail_ConStringVacio_DevuelveFalse', () => {
    expect(validarEmail('')).toBe(false)
  })
})

describe('validarTelefono', () => {
  it('validarTelefono_ConCelularPeruano_DevuelveTrue', () => {
    // Celular peruano: 9XXXXXXXX
    expect(validarTelefono('987654321')).toBe(true)
  })

  it('validarTelefono_ConFijo_DevuelveTrue', () => {
    // Fijo: 6-7 dígitos
    expect(validarTelefono('2345678')).toBe(true)
  })

  it('validarTelefono_ConStringVacio_DevuelveFalse', () => {
    expect(validarTelefono('')).toBe(false)
  })
})
```

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/compartido/utilidades/__tests__/
```

Todos los tests de utilidades deben pasar. Si alguna función no existe con el nombre esperado, lee el archivo fuente y ajusta el import y el nombre de la función.
