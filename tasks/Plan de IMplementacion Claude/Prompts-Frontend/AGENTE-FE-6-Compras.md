# AGENTE-FE-6 — Compras, Órdenes y Proveedores Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de compras de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear tests en `src/features/compras/` para los hooks de compras, órdenes de compra y proveedores.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/compras/compras/hooks/useCompras.ts
src/features/compras/compras/servicios/servicioCompras.ts
src/features/compras/compras/types/compra.types.ts
src/features/compras/ordenes-compra/hooks/useOrdenesCompra.ts
src/features/compras/ordenes-compra/servicios/ordenCompraService.ts
src/features/compras/ordenes-compra/types/ordenCompra.types.ts
src/features/compras/proveedores/hooks/useProveedores.ts
src/features/compras/proveedores/servicios/servicioProveedores.ts
src/features/compras/proveedores/types/proveedor.types.ts
```

## Conocimiento del dominio

### Estados de compra
| ID | Estado |
|----|--------|
| 60 | Registrado |
| 61 | Anulado Directo |
| 64 | Anulado Nota Crédito |
| 66 | Completado |

### Estados de orden de compra
| ID | Estado |
|----|--------|
| 39 | Borrador |
| 40 | Pendiente |
| 41 | Aprobada |
| 42 | Rechazada |
| 100 | Facturada |

### URLs de la API
- `GET http://localhost:5000/api/compras` → lista compras
- `GET http://localhost:5000/api/compras/{id}` → detalle
- `POST http://localhost:5000/api/compras` → registrar compra
- `POST http://localhost:5000/api/compras/{id}/anular` → anular
- `DELETE http://localhost:5000/api/compras/{id}` → eliminar
- `GET http://localhost:5000/api/compras/reportes/compras-proveedor` → reporte
- `GET http://localhost:5000/api/ordenes-compra` → lista órdenes
- `GET http://localhost:5000/api/ordenes-compra/{id}` → detalle orden
- `GET http://localhost:5000/api/ordenes-compra/siguiente-numero` → siguiente número
- `POST http://localhost:5000/api/ordenes-compra` → registrar orden
- `PATCH http://localhost:5000/api/ordenes-compra/{id}/estado` → cambiar estado
- `GET http://localhost:5000/api/proveedores` → lista proveedores
- `GET http://localhost:5000/api/proveedores/{id}` → detalle
- `POST http://localhost:5000/api/proveedores` → crear
- `PUT http://localhost:5000/api/proveedores/{id}` → actualizar
- `DELETE http://localhost:5000/api/proveedores/{id}` → eliminar

### Datos de test
```typescript
const compraResumen = {
  id: 1,
  tipoComprobanteNombre: 'Factura',
  serieComprobante: 'F001',
  numeroComprobante: '00000001',
  fechaEmision: '2024-01-15',
  razonSocialProveedor: 'Proveedor SAC',
  numeroDocumentoProveedor: '20123456789',
  moneda: 'PEN',
  total: 1180.00,
  idEstado: 60,
  estadoNombre: 'Registrado',
}

const ordenCompra = {
  id: 1,
  codigoOrden: 'OC-001',
  idProveedor: 1,
  razonSocialProveedor: 'Proveedor SAC',
  idAlmacenDestino: 1,
  fechaEmision: '2024-01-15',
  idEstado: 40,
  nombreEstado: 'Pendiente',
  totalImporte: 1000.00,
  detalles: [
    { id: 1, idProducto: 1, cantidadSolicitada: 10, precioUnitarioPactado: 100 }
  ],
}

const proveedor = {
  id: 1,
  idTipoDocumento: 6,
  numeroDocumento: '20123456789',
  razonSocial: 'Proveedor SAC',
  email: 'proveedor@test.com',
  telefono: '012345678',
  activado: true,
  esAgenteRetencion: false,
  esBuenContribuyente: false,
  esAgentePercepcion: false,
}
```

## Tests que debes implementar

### `src/features/compras/compras/__tests__/useCompras.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../../__tests__/setup/renderWithProviders'
import { server } from '../../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'
```

1. `useCompras_ConRespuestaExitosa_DevuelveListaPaginada()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/compras`, () =>
       HttpResponse.json({
         datos: [compraResumen], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useCompras())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].serieComprobante).toBe('F001')
   ```

2. `useCompra_ConIdValido_DevuelveDetalleCompleto()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/compras/1`, () =>
       HttpResponse.json({ ...compraResumen, detalles: [] })
     )
   )
   const { result } = renderHookConProveedores(() => useCompra(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(1)
   ```

3. `useRegistrarCompra_ConDatosValidos_RegistraLaCompra()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/compras`, () =>
       HttpResponse.json({ ...compraResumen, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useRegistrarCompra())
   act(() => {
     result.current.mutate({
       idProveedor: 1,
       idAlmacen: 1,
       idTipoComprobante: 1,
       serieComprobante: 'F001',
       numeroComprobante: '00000001',
       fechaEmision: '2024-01-15',
       detalles: [{ idProducto: 1, cantidad: 10, precioUnitarioCompra: 100 }],
     } as any)
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

4. `useEliminarCompra_ConId_LlamaDelete()`
   ```typescript
   let deleteLlamado = false
   server.use(
     http.delete(`${API_BASE}/compras/1`, () => {
       deleteLlamado = true
       return new HttpResponse(null, { status: 204 })
     })
   )
   const { result } = renderHookConProveedores(() => useEliminarCompra())
   act(() => { result.current.mutate(1) })
   await waitFor(() => expect(deleteLlamado).toBe(true))
   ```

5. `useReporteComprasProveedor_ConFechas_DevuelveReporte()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/compras/reportes/compras-proveedor`, () =>
       HttpResponse.json([
         { razonSocial: 'Proveedor SAC', totalCompras: 5000 }
       ])
     )
   )
   const { result } = renderHookConProveedores(
     () => useReporteComprasProveedor('2024-01-01', '2024-01-31')
   )
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(Array.isArray(result.current.data)).toBe(true)
   ```

### `src/features/compras/ordenes-compra/__tests__/useOrdenesCompra.test.ts`

1. `useOrdenesCompra_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ordenes-compra`, () =>
       HttpResponse.json({
         datos: [ordenCompra], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useOrdenesCompra())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].codigoOrden).toBe('OC-001')
   ```

2. `useSiguienteNumeroOrdenCompra_DevuelveElSiguienteNumero()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ordenes-compra/siguiente-numero`, () =>
       HttpResponse.json('OC-002')
     )
   )
   const { result } = renderHookConProveedores(() => useSiguienteNumeroOrdenCompra())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data).toBe('OC-002')
   ```

3. `useOrdenCompra_ConIdValido_DevuelveDetalleConLineas()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/ordenes-compra/1`, () => HttpResponse.json(ordenCompra))
   )
   const { result } = renderHookConProveedores(() => useOrdenCompra(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.detalles).toHaveLength(1)
   ```

4. `useRegistrarOrdenCompra_ConDatosValidos_CreaLaOrden()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/ordenes-compra`, () =>
       HttpResponse.json({ ...ordenCompra, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useRegistrarOrdenCompra())
   act(() => {
     result.current.mutate({
       codigoOrden: 'OC-002',
       idProveedor: 1,
       idAlmacenDestino: 1,
       fechaEmision: '2024-01-20',
       idEstado: 39,
       detalles: [{ idProducto: 1, cantidadSolicitada: 5, precioUnitarioPactado: 100 }],
     })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

5. `useCambiarEstadoOrdenCompra_DeBorradorAPendiente_CambiaElEstado()`
   ```typescript
   server.use(
     http.patch(`${API_BASE}/ordenes-compra/1/estado`, () =>
       HttpResponse.json({ success: true })
     )
   )
   const { result } = renderHookConProveedores(() => useCambiarEstadoOrdenCompra())
   act(() => { result.current.mutate({ id: 1, idEstado: 41 }) }) // Aprobada
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

### `src/features/compras/proveedores/__tests__/useProveedores.test.ts`

1. `useProveedores_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/proveedores`, () =>
       HttpResponse.json({
         datos: [proveedor], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useProveedores())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].razonSocial).toBe('Proveedor SAC')
   ```

2. `useProveedor_ConId_DevuelveDetalleDelProveedor()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/proveedores/1`, () => HttpResponse.json(proveedor))
   )
   const { result } = renderHookConProveedores(() => useProveedor(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.numeroDocumento).toBe('20123456789')
   ```

3. `useCrearProveedor_ConRucValido_CreaElProveedor()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/proveedores`, () =>
       HttpResponse.json({ ...proveedor, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearProveedor())
   act(() => {
     result.current.mutate({
       idTipoDocumento: 6,
       numeroDocumento: '20123456789',
       razonSocial: 'Nuevo Proveedor SAC',
       activado: true,
       esAgenteRetencion: false,
       esBuenContribuyente: false,
       esAgentePercepcion: false,
     })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

4. `useActualizarProveedor_ConDatosNuevos_ActualizaElProveedor()`
   ```typescript
   server.use(
     http.put(`${API_BASE}/proveedores/1`, () =>
       HttpResponse.json({ ...proveedor, email: 'nuevo@proveedor.com' })
     )
   )
   const { result } = renderHookConProveedores(() => useActualizarProveedor())
   act(() => {
     result.current.mutate({ id: 1, data: { email: 'nuevo@proveedor.com' } as any })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

5. `useEliminarProveedor_ConId_LlamaDelete()`
   ```typescript
   let deleteLlamado = false
   server.use(
     http.delete(`${API_BASE}/proveedores/1`, () => {
       deleteLlamado = true
       return new HttpResponse(null, { status: 204 })
     })
   )
   const { result } = renderHookConProveedores(() => useEliminarProveedor())
   act(() => { result.current.mutate(1) })
   await waitFor(() => expect(deleteLlamado).toBe(true))
   ```

## Reglas obligatorias

- Patrón AAA en cada test
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- `await waitFor(...)` siempre para estados asincrónico
- Leer archivos fuente para confirmar firmas exactas de mutaciones
- Las rutas relativas al import de `renderWithProviders` tienen 4 niveles porque los tests están en subcarpetas de `compras/`

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/compras/
```
