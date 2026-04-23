# AGENTE-FE-7 — Inventario Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de inventario de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/features/inventario/__tests__/` con tests para los hooks de inventario (stock, movimientos, kardex, almacenes).

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/inventario/hooks/useInventario.ts
src/features/inventario/servicios/servicioInventario.ts
src/features/inventario/tipos/inventario.types.ts
src/features/inventario/almacenes/hooks/useAlmacenes.ts
src/features/inventario/almacenes/servicios/servicioAlmacenes.ts
```

## Conocimiento del dominio

### Tipos de movimiento de inventario
| ID | Nombre | Origen |
|----|--------|--------|
| 19 | ING_COM | Entrada por compra |
| 20 | SAL_VEN | Salida por venta |
| 24 | DevolucionCompra | NC de compra |
| 25 | DevolucionVenta | NC de venta |
| 26 | NotaDebitoCompra | ND de compra |
| 27 | NotaDebitoVenta | ND de venta |

### Métodos de valuación de kardex
| Método | Descripción |
|--------|-------------|
| PP | Promedio Ponderado |
| PE | PEPS/FIFO |
| UE | UEPS/LIFO |

### URLs de la API
- `GET http://localhost:5000/api/inventario/stock` → lista paginada de stock
- `GET http://localhost:5000/api/inventario/stock/reporte-critico` → stock bajo mínimo
- `GET http://localhost:5000/api/inventario/stock/producto/{id}` → stock por producto
- `GET http://localhost:5000/api/inventario/movimientos` → lista movimientos
- `GET http://localhost:5000/api/inventario/movimientos/{id}` → detalle movimiento
- `POST http://localhost:5000/api/inventario/movimientos` → registrar movimiento
- `POST http://localhost:5000/api/inventario/stock/ajuste` → ajustar stock
- `GET http://localhost:5000/api/inventario/kardex/{idProducto}` → kardex del producto
- `GET http://localhost:5000/api/inventario/tipos-movimiento` → tipos de movimiento
- `GET http://localhost:5000/api/inventario/almacenes` → lista almacenes
- `GET http://localhost:5000/api/inventario/almacenes/{id}` → detalle almacén
- `POST http://localhost:5000/api/inventario/almacenes` → crear almacén
- `PUT http://localhost:5000/api/inventario/almacenes/{id}` → actualizar
- `DELETE http://localhost:5000/api/inventario/almacenes/{id}` → eliminar

### Datos de test
```typescript
const stockItem = {
  id: 1,
  idProducto: 1,
  idAlmacen: 1,
  cantidadActual: 100,
  cantidadMinima: 10,
  cantidadMaxima: 500,
  ultimaActualizacion: '2024-01-15T10:00:00',
}

const movimientoResumen = {
  id: 1,
  tipoMovimientoNombre: 'ING_COM',
  productoNombre: 'Producto Test',
  almacenNombre: 'Almacén Principal',
  cantidad: 10,
  costoUnitarioMovimiento: 100.00,
  fechaCreacion: '2024-01-15T10:00:00',
}

const movimientoDetalle = {
  ...movimientoResumen,
  idTipoMovimiento: 19,
  cantidadAnterior: 90,
  cantidadNueva: 100,
  saldoCantidad: 100,
  saldoValorizado: 10000,
  costoPromedioActual: 100.00,
}

const almacenTest = {
  id: 1,
  nombre: 'Almacén Principal',
  idEmpresa: 1,
  direccion: 'Av. Principal 123',
  activo: true,
  fechaCreacion: '2024-01-01T00:00:00',
}

const kardexData = {
  producto: { id: 1, nombre: 'Producto Test' },
  almacen: { id: 1, nombre: 'Almacén Principal' },
  fechaInicio: '2024-01-01',
  fechaFin: '2024-01-31',
  movimientos: [
    {
      fecha: '2024-01-05',
      tipoMovimiento: 'ING_COM',
      referencia: 'F001-00000001',
      entrada: 100,
      salida: 0,
      saldo: 100,
      costoUnitario: 50.00,
      costoTotal: 5000.00,
    }
  ],
  resumen: {
    stockInicial: 0,
    totalEntradas: 100,
    totalSalidas: 0,
    stockFinal: 100,
  },
}
```

## Tests que debes implementar

### `src/features/inventario/__tests__/useStock.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'
```

1. `useStock_ConRespuestaExitosa_DevuelveStockPaginado()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/inventario/stock`, () =>
       HttpResponse.json({
         datos: [stockItem], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useStock())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].cantidadActual).toBe(100)
   ```

2. `useStockCritico_DevuelveProductosBajoMinimo()`
   ```typescript
   const itemCritico = { ...stockItem, cantidadActual: 5, cantidadMinima: 10 }
   server.use(
     http.get(`${API_BASE}/inventario/stock/reporte-critico`, () =>
       HttpResponse.json({
         datos: [itemCritico], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useStockCritico())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   // El item tiene cantidadActual < cantidadMinima
   expect(result.current.data?.datos[0].cantidadActual).toBeLessThan(
     result.current.data?.datos[0].cantidadMinima!
   )
   ```

3. `useAjustarStock_ConNuevaCantidad_EnviaAjuste()`
   ```typescript
   let bodyRecibido: unknown
   server.use(
     http.post(`${API_BASE}/inventario/stock/ajuste`, async ({ request }) => {
       bodyRecibido = await request.json()
       return HttpResponse.json({ success: true })
     })
   )
   const { result } = renderHookConProveedores(() => useAjustarStock())
   act(() => {
     result.current.mutate({
       idProducto: 1,
       idAlmacen: 1,
       nuevaCantidad: 150,
       motivo: 'Ajuste por inventario físico',
     })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

### `src/features/inventario/__tests__/useMovimientos.test.ts`

4. `useMovimientos_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/inventario/movimientos`, () =>
       HttpResponse.json({
         datos: [movimientoResumen], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useMovimientos())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].tipoMovimientoNombre).toBe('ING_COM')
   ```

5. `useMovimiento_ConId_DevuelveDetalleCompleto()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/inventario/movimientos/1`, () =>
       HttpResponse.json(movimientoDetalle)
     )
   )
   const { result } = renderHookConProveedores(() => useMovimiento(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.cantidadAnterior).toBe(90)
   expect(result.current.data?.cantidadNueva).toBe(100)
   ```

6. `useRegistrarMovimiento_ConMovimientoEntrada_RegistraCorrectamente()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/inventario/movimientos`, () =>
       HttpResponse.json({ id: 99, success: true }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useRegistrarMovimiento())
   act(() => {
     result.current.mutate({
       idProducto: 1,
       idAlmacen: 1,
       idTipoMovimiento: 19, // ING_COM
       cantidad: 10,
       precioCosto: 100,
     } as any)
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

7. `useKardex_ConProductoYAlmacenYFechas_DevuelveKardex()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/inventario/kardex/1`, () =>
       HttpResponse.json(kardexData)
     )
   )
   const { result } = renderHookConProveedores(
     () => useKardex(1, 1, '2024-01-01', '2024-01-31')
   )
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.resumen.stockFinal).toBe(100)
   expect(result.current.data?.movimientos).toHaveLength(1)
   ```

### Almacenes: `src/features/inventario/__tests__/useAlmacenes.test.ts`

Lee `almacenes/hooks/useAlmacenes.ts` primero. Si está en `servicios/servicioInventario.ts`, adaptar URL.

8. `useAlmacenes_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/inventario/almacenes`, () =>
       HttpResponse.json({
         datos: [almacenTest], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useAlmacenes())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].nombre).toBe('Almacén Principal')
   ```

9. `useCrearAlmacen_ConDatosValidos_CreaElAlmacen()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/inventario/almacenes`, () =>
       HttpResponse.json({ ...almacenTest, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearAlmacen())
   act(() => {
     result.current.mutate({
       nombre: 'Almacén Secundario',
       idEmpresa: 1,
       activo: true,
     })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(99)
   ```

10. `useActualizarAlmacen_ConDatosNuevos_ActualizaElAlmacen()`
    ```typescript
    server.use(
      http.put(`${API_BASE}/inventario/almacenes/1`, () =>
        HttpResponse.json({ ...almacenTest, nombre: 'Almacén Actualizado' })
      )
    )
    const { result } = renderHookConProveedores(() => useActualizarAlmacen())
    act(() => {
      result.current.mutate({ id: 1, data: { nombre: 'Almacén Actualizado' } as any })
    })
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    ```

11. `useEliminarAlmacen_ConId_LlamaDelete()`
    ```typescript
    let deleteLlamado = false
    server.use(
      http.delete(`${API_BASE}/inventario/almacenes/1`, () => {
        deleteLlamado = true
        return new HttpResponse(null, { status: 204 })
      })
    )
    const { result } = renderHookConProveedores(() => useEliminarAlmacen())
    act(() => { result.current.mutate(1) })
    await waitFor(() => expect(deleteLlamado).toBe(true))
    ```

## Instrucción especial

Si `useKardex` requiere que todos los parámetros estén definidos para ejecutarse (enabled: !!idProducto && !!idAlmacen && !!fechaInicio && !!fechaFin), verificar también:

```typescript
it('useKardex_SinParametros_NoEjecutaLaQuery', () => {
  const { result } = renderHookConProveedores(
    () => useKardex(undefined as any, undefined as any, '', '')
  )
  expect(result.current.fetchStatus).toBe('idle')
})
```

## Reglas obligatorias

- Patrón AAA en cada test
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- `await waitFor(...)` para estados asincrónico
- Leer archivos fuente para URLs y firmas exactas
- Las URLs de almacenes pueden estar en `/inventario/almacenes` — verificar en `servicioAlmacenes.ts`

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/inventario/__tests__/
```
