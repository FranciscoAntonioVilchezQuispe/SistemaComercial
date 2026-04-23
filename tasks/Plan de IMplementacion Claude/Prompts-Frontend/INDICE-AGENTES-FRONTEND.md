# Índice de Agentes — Plan de Tests Frontend

**Proyecto**: `D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`
**Fecha**: 2026-04-23
**Total de agentes**: 10 (AGENTE-FE-0 al AGENTE-FE-9)
**Stack**: React 18 · TypeScript · Vite · TanStack Query · Zustand · Axios · MSW

---

## Orden de ejecución obligatorio

```
AGENTE-FE-0 (Setup + Utilidades)
    ├─► AGENTE-FE-1 (Auth)
    ├─► AGENTE-FE-2 (Catálogo)
    ├─► AGENTE-FE-3 (Clientes)
    ├─► AGENTE-FE-4 (Carrito)     ─┐
    ├─► AGENTE-FE-5 (Ventas Hooks) ─┤ (paralelos entre sí)
    ├─► AGENTE-FE-6 (Compras)     ─┤
    ├─► AGENTE-FE-7 (Inventario)  ─┤
    ├─► AGENTE-FE-8 (Configuración)┤
    └─► AGENTE-FE-9 (Componentes) ─┘
```

**Regla**: AGENTE-FE-0 debe completar y verificar `npm run test:run` antes de iniciar cualquier otro agente. Una vez completado, todos los demás pueden ejecutarse en paralelo.

---

## Tabla de agentes

| Agente | Archivo de prompt | Carpeta de salida | Depende de |
|--------|------------------|--------------------|------------|
| AGENTE-FE-0 | `AGENTE-FE-0-Setup-Utilidades.md` | `src/__tests__/setup/` + `src/compartido/utilidades/__tests__/` | — |
| AGENTE-FE-1 | `AGENTE-FE-1-Auth.md` | `src/features/identidad/__tests__/` | FE-0 |
| AGENTE-FE-2 | `AGENTE-FE-2-Catalogo.md` | `src/features/catalogo/__tests__/` | FE-0 |
| AGENTE-FE-3 | `AGENTE-FE-3-Clientes.md` | `src/features/clientes/__tests__/` | FE-0 |
| AGENTE-FE-4 | `AGENTE-FE-4-Carrito.md` | `src/features/ventas/__tests__/useCarrito.test.ts` | FE-0 |
| AGENTE-FE-5 | `AGENTE-FE-5-Ventas.md` | `src/features/ventas/__tests__/` | FE-0 |
| AGENTE-FE-6 | `AGENTE-FE-6-Compras.md` | `src/features/compras/**/__tests__/` | FE-0 |
| AGENTE-FE-7 | `AGENTE-FE-7-Inventario.md` | `src/features/inventario/__tests__/` | FE-0 |
| AGENTE-FE-8 | `AGENTE-FE-8-Configuracion.md` | `src/features/configuracion/__tests__/` | FE-0 |
| AGENTE-FE-9 | `AGENTE-FE-9-Componentes.md` | `src/compartido/__tests__/` | FE-0 |

---

## Instrucción para cada agente

Cada agente debe:

1. **Leer su archivo de prompt** completo antes de escribir código.
2. **Leer todos los archivos fuente** listados en la sección "Archivos fuente que DEBES leer primero".
3. **Crear los archivos** exactamente en las rutas indicadas.
4. **NO modificar** archivos fuera de `__tests__/` (excepto FE-0 que modifica `package.json` y crea `vitest.config.ts`).
5. **Verificar que los tests pasan** con `npm run test:run` antes de terminar.
6. **Reportar** si algún archivo fuente de referencia no existe o difiere del prompt.

---

## Reglas globales aplicables a todos los agentes

### Stack de testing instalado por AGENTE-FE-0

```
vitest ^1.6.0
@vitest/coverage-v8 ^1.6.0
@testing-library/react ^16.0.0
@testing-library/user-event ^14.5.2
@testing-library/jest-dom ^6.6.0
msw ^2.3.0
jsdom ^24.1.0
```

### Convención de nombres de tests
```
[funcion/hook]_[condicion]_[resultadoEsperado]

Ejemplos:
  calcularIGV_ConMonto100_Devuelve18()
  useProductos_ConRespuestaExitosa_DevuelveListaPaginada()
  useCarrito_AlAgregarProducto_ActualizaTotales()
  login_ConCredencialesInvalidas_LanzaError()
```

### Patrón AAA obligatorio en cada test
```typescript
it('descripcion_del_test', async () => {
  // Arrange
  const datos = { ... }

  // Act
  const resultado = await funcion(datos)

  // Assert
  expect(resultado).toBe(esperado)
})
```

### Estructura de archivos de tests

Tests co-localizados con el código fuente:
```
src/
  __tests__/
    setup/
      setup.ts              ← beforeAll/afterAll MSW
      mswServer.ts          ← servidor MSW con handlers base
      renderWithProviders.tsx ← wrapper con QueryClient + Router
  compartido/
    utilidades/
      __tests__/
        calculos.test.ts
        moneda.test.ts
        fecha.test.ts
        validacion.test.ts
  features/
    identidad/
      __tests__/
        authService.test.ts
        AuthContext.test.tsx
    catalogo/
      __tests__/
        useProductos.test.ts
        useMarcas.test.ts
        useCategorias.test.ts
    clientes/
      __tests__/
        useClientes.test.ts
    ventas/
      __tests__/
        useCarrito.test.ts
        useVentas.test.ts
    compras/
      compras/
        __tests__/
          useCompras.test.ts
      ordenes-compra/
        __tests__/
          useOrdenesCompra.test.ts
      proveedores/
        __tests__/
          useProveedores.test.ts
    inventario/
      __tests__/
        useStock.test.ts
        useMovimientos.test.ts
    configuracion/
      __tests__/
        useSeriesComprobante.test.ts
        useTablaGeneral.test.ts
    compartido/
      __tests__/
        usePermiso.test.ts
```

### URL base de la API (para MSW handlers)
```typescript
export const API_BASE = 'http://localhost:5000/api'
```

### Patrón de respuesta paginada (PagedResponse<T>)
```typescript
const respuestaPaginada = {
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
```

### Patrón de renderHook con React Query
```typescript
import { renderHook, waitFor } from '@testing-library/react'
import { crearQueryClient, renderHookConProveedores } from '@src/__tests__/setup/renderWithProviders'

it('hook devuelve datos', async () => {
  // Arrange — el handler MSW ya está configurado por defecto

  // Act
  const { result } = renderHookConProveedores(() => useProductos())

  // Assert
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data?.datos).toEqual([])
})
```

### Patrón de override de handler MSW por test
```typescript
import { server } from '@src/__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

it('maneja error 500', async () => {
  // Arrange
  server.use(
    http.get(`${API_BASE}/productos`, () => {
      return HttpResponse.json({ message: 'Error' }, { status: 500 })
    })
  )

  // Act
  const { result } = renderHookConProveedores(() => useProductos())

  // Assert
  await waitFor(() => expect(result.current.isError).toBe(true))
})
```

### Patrón de mutation test
```typescript
it('mutacion crea recurso', async () => {
  // Arrange
  server.use(
    http.post(`${API_BASE}/productos`, () => {
      return HttpResponse.json({ id: 1, nombre: 'Producto Test' }, { status: 201 })
    })
  )

  const { result } = renderHookConProveedores(() => useCrearProducto())

  // Act
  act(() => {
    result.current.mutate({ nombre: 'Producto Test', ... })
  })

  // Assert
  await waitFor(() => expect(result.current.isSuccess).toBe(true))
  expect(result.current.data?.id).toBe(1)
})
```

### Patrón de test para Zustand stores
```typescript
import { act } from '@testing-library/react'

describe('useCarrito store', () => {
  beforeEach(() => {
    // Limpiar store antes de cada test
    useCarrito.getState().limpiarCarrito()
  })

  it('agrega producto y actualiza totales', () => {
    // Act
    act(() => {
      useCarrito.getState().agregarProducto(producto, 2)
    })

    // Assert
    const estado = useCarrito.getState()
    expect(estado.items).toHaveLength(1)
    expect(estado.items[0].cantidad).toBe(2)
  })
})
```

### Códigos de afectación IGV (SUNAT) para tests
| Código | Tipo |
|--------|------|
| `10` | Gravado — IGV |
| `20` | Exonerado |
| `30` | Inafecto |
| `11`–`16` | Gratuito gravado |
| `21` | Gratuito exonerado |

### Porcentaje IGV
- Siempre 18% (`FISCAL_CONFIG.PORCENTAJE_IGV = 18.00`)
- Factor: `1.18`

---

## Comandos de verificación por agente

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
npm run test:run -- src/features/ventas/__tests__/

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
```
