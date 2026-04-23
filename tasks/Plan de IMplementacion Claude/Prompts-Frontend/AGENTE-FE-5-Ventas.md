# AGENTE-FE-5 — Ventas Hooks Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para los hooks de ventas de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/features/ventas/__tests__/useVentas.test.ts` con tests para los hooks de TanStack Query del módulo de ventas (excluyendo useCarrito, que lo cubre AGENTE-FE-4).

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/ventas/hooks/useVentas.ts
src/features/ventas/servicios/servicioVentas.ts
src/features/ventas/servicios/servicioCajas.ts
src/features/ventas/tipos/ventas.types.ts
```

## Conocimiento del dominio

### Estados de venta
| ID | Estado |
|----|--------|
| 29 | Completada |
| 30 | Anulada |
| 31 | Pendiente de Pago |

### Estados de pago
| ID | Estado |
|----|--------|
| 46 | Pagado |
| 47 | Parcial |
| 48 | Crédito |
| 49 | Pendiente |

### URLs de la API (ventas)
- `GET http://localhost:5000/api/ventas` → lista paginada
- `GET http://localhost:5000/api/ventas/{id}` → detalle
- `POST http://localhost:5000/api/ventas` → crear venta
- `PATCH http://localhost:5000/api/ventas/{id}/anular` → anular
- `GET http://localhost:5000/api/ventas/hoy` → ventas del día
- `GET http://localhost:5000/api/ventas/estadisticas` → estadísticas
- `GET http://localhost:5000/api/ventas/reportes/ranking-productos` → ranking
- `GET http://localhost:5000/api/ventas/reportes/top-clientes` → top clientes

### URLs de la API (cajas)
- `GET http://localhost:5000/api/cajas` → lista cajas
- `POST http://localhost:5000/api/cajas` → crear caja
- `PUT http://localhost:5000/api/cajas/{id}` → actualizar caja
- `PATCH http://localhost:5000/api/cajas/{id}/estado` → cambiar estado
- `POST http://localhost:5000/api/cajas/{cajaId}/movimientos` → registrar movimiento

### Datos de test
```typescript
const ventaResumen = {
  id: 1,
  serie: 'B001',
  numero: '00000001',
  numeroFormateado: 'B001-00000001',
  fechaEmision: '2024-01-15',
  idCliente: 1,
  nombreCliente: 'Juan Pérez',
  idTipoComprobante: 3,
  tipoComprobanteNombre: 'Boleta de Venta',
  idEstado: 29,
  estadoNombre: 'Completada',
  idEstadoPago: 46,
  estadoPagoNombre: 'Pagado',
  subtotalGravado: 100,
  totalImpuesto: 18,
  totalVenta: 118,
  moneda: 'PEN',
}

const ventaDetalle = {
  ...ventaResumen,
  detalles: [
    {
      id: 1,
      idProducto: 1,
      descripcionProducto: 'Producto Test',
      cantidad: 1,
      precioUnitario: 118,
      totalItem: 118,
    }
  ],
  pagos: [
    { id: 1, idMetodoPago: 1, montoPago: 118 }
  ],
}

const cajaTest = {
  id: 1,
  nombreCaja: 'Caja 1',
  idAlmacen: 1,
  idEstado: 60,
  montoApertura: 200.00,
  montoActual: 500.00,
  activado: true,
}
```

## Tests que debes implementar

### `src/features/ventas/__tests__/useVentas.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'
```

#### Grupo: Lista y detalle de ventas

1. `useVentas_ConRespuestaExitosa_DevuelveListaPaginada()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ventas`, () =>
       HttpResponse.json({
         datos: [ventaResumen],
         total: 1,
         pageNumber: 1,
         pageSize: 10,
         totalPages: 1,
         hasPreviousPage: false,
         hasNextPage: false,
         status: 200,
         message: '',
         transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useVentas())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos).toHaveLength(1)
   expect(result.current.data?.datos[0].serie).toBe('B001')
   ```

2. `useVenta_ConIdValido_DevuelveDetalleCompleto()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ventas/1`, () => HttpResponse.json(ventaDetalle))
   )
   const { result } = renderHookConProveedores(() => useVenta(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.detalles).toHaveLength(1)
   expect(result.current.data?.pagos).toHaveLength(1)
   ```

3. `useVenta_ConIdUndefined_NoEjecutaLaQuery()`
   ```typescript
   const { result } = renderHookConProveedores(() => useVenta(undefined as any))
   expect(result.current.fetchStatus).toBe('idle')
   ```

#### Grupo: Crear y anular ventas

4. `useCrearVenta_ConDatosValidos_CreaLaVenta()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/ventas`, () =>
       HttpResponse.json({ ...ventaDetalle, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearVenta())
   act(() => {
     result.current.mutate({
       idCliente: 1,
       idTipoComprobante: 3,
       detalles: [{ idProducto: 1, cantidad: 1, precioUnitario: 118 }],
       pagos: [{ idMetodoPago: 1, montoPago: 118 }],
     } as any)
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(99)
   ```

5. `useCrearVenta_ConError400_DevuelveEstadoError()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/ventas`, () =>
       HttpResponse.json({ message: 'Datos inválidos', errors: [] }, { status: 400 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearVenta())
   act(() => { result.current.mutate({} as any) })
   await waitFor(() => expect(result.current.isError).toBe(true))
   ```

6. `useAnularVenta_ConMotivoValido_AnulaLaVenta()`
   ```typescript
   server.use(
     http.patch(`${API_BASE}/ventas/1/anular`, () =>
       HttpResponse.json({ success: true })
     )
   )
   const { result } = renderHookConProveedores(() => useAnularVenta())
   act(() => {
     result.current.mutate({ id: 1, motivo: 'Error en el pedido', usuarioId: 1 })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

#### Grupo: Ventas del día y estadísticas

7. `useVentasDelDia_DevuelveVentasDelDiaActual()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ventas/hoy`, () =>
       HttpResponse.json([ventaResumen])
     )
   )
   const { result } = renderHookConProveedores(() => useVentasDelDia())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(Array.isArray(result.current.data)).toBe(true)
   ```

8. `useEstadisticasVentas_ConFechas_DevuelveEstadisticas()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ventas/estadisticas`, () =>
       HttpResponse.json({ totalVentas: 5000, cantidadVentas: 10 })
     )
   )
   const fechaInicio = '2024-01-01'
   const fechaFin = '2024-01-31'
   const { result } = renderHookConProveedores(
     () => useEstadisticasVentas(fechaInicio, fechaFin)
   )
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

9. `useEstadisticasVentas_SinFechas_NoEjecutaLaQuery()`
   ```typescript
   // El hook está deshabilitado cuando faltan fechas
   const { result } = renderHookConProveedores(
     () => useEstadisticasVentas(undefined as any, undefined as any)
   )
   expect(result.current.fetchStatus).toBe('idle')
   ```

#### Grupo: Reportes

10. `useRankingProductos_ConFechas_DevuelveRanking()`
    ```typescript
    server.use(
      http.get(`${API_BASE}/ventas/reportes/ranking-productos`, () =>
        HttpResponse.json([
          { idProducto: 1, nombreProducto: 'Producto A', totalVendido: 100 }
        ])
      )
    )
    const { result } = renderHookConProveedores(
      () => useRankingProductos('2024-01-01', '2024-01-31')
    )
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(Array.isArray(result.current.data)).toBe(true)
    ```

11. `useTopClientes_ConFechas_DevuelveTopClientes()`
    ```typescript
    server.use(
      http.get(`${API_BASE}/ventas/reportes/top-clientes`, () =>
        HttpResponse.json([
          { idCliente: 1, nombreCliente: 'Juan Pérez', totalCompras: 5000 }
        ])
      )
    )
    const { result } = renderHookConProveedores(
      () => useTopClientes('2024-01-01', '2024-01-31')
    )
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data).toHaveLength(1)
    ```

#### Grupo: Cajas (si el servicio de cajas tiene hooks — leer servicioCajas.ts)

12. `useCajas_ConRespuestaExitosa_DevuelveLista()`
    ```typescript
    // NOTA: Ajustar URL según servicioCajas.ts — puede ser /cajas o /ventas/cajas
    server.use(
      http.get(`${API_BASE}/cajas`, () =>
        HttpResponse.json([cajaTest])
      )
    )
    // Importar el hook correcto para cajas (leer hooks de ventas para encontrarlo)
    // const { result } = renderHookConProveedores(() => useCajas())
    // await waitFor(() => expect(result.current.isSuccess).toBe(true))
    // expect(result.current.data).toHaveLength(1)
    ```

13. `useRegistrarMovimientoCaja_ConDatosValidos_RegistraElMovimiento()`
    ```typescript
    server.use(
      http.post(`${API_BASE}/cajas/1/movimientos`, () =>
        HttpResponse.json({ id: 1, monto: 100, concepto: 'Ingreso manual' })
      )
    )
    // Adaptar según el hook disponible en hooks/useVentas.ts o similar
    ```

## Instrucción especial

Si los hooks de cajas están definidos en un archivo separado (ej: `hooks/useCajas.ts`), créa también el test en un archivo `useCajas.test.ts` dentro de `src/features/ventas/__tests__/`.

Lee los hooks disponibles en `src/features/ventas/hooks/` para saber qué existe realmente.

## Reglas obligatorias

- Patrón AAA en cada test
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- `await waitFor(...)` para estados asincrónico
- Leer los archivos fuente para confirmar nombres exactos
- Si un hook no existe, no escribir el test

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/ventas/__tests__/useVentas.test.ts
```
