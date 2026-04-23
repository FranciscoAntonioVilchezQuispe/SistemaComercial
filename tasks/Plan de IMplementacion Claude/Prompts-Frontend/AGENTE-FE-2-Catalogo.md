# AGENTE-FE-2 — Catálogo Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de catálogo de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/features/catalogo/__tests__/` con tests para los hooks de TanStack Query del módulo de catálogo.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/catalogo/hooks/useProductos.ts
src/features/catalogo/hooks/useMarcas.ts
src/features/catalogo/hooks/useCategorias.ts
src/features/catalogo/servicios/servicioProductos.ts
src/features/catalogo/tipos/catalogo.types.ts
```

## Conocimiento del dominio

### Estructura PagedResponse<T>
```typescript
{
  datos: T[],
  total: number,
  pageNumber: number,
  pageSize: number,
  totalPages: number,
  hasPreviousPage: boolean,
  hasNextPage: boolean,
  status: number,
  message: string,
  transactionId: string,
}
```

### URLs de la API
- `GET http://localhost:5000/api/productos` → lista productos
- `GET http://localhost:5000/api/productos/{id}` → detalle producto
- `POST http://localhost:5000/api/productos` → crear producto
- `PUT http://localhost:5000/api/productos/{id}` → actualizar
- `DELETE http://localhost:5000/api/productos/{id}` → eliminar
- `GET http://localhost:5000/api/marcas` → lista marcas
- `GET http://localhost:5000/api/categorias` → lista categorías

### Producto de test
```typescript
const productoTest = {
  id: 1,
  codigo: 'PROD-001',
  nombre: 'Producto Test',
  descripcion: 'Descripción test',
  idCategoria: 1,
  idMarca: 1,
  idUnidadMedida: 1,
  precioVentaPublico: 118.00,
  precioVentaMayorista: 100.00,
  stock: 50,
  activo: true,
  gravadoImpuesto: true,
  porcentajeImpuesto: 18,
  idTipoAfectacionIgv: 10,
}
```

## Tests que debes implementar

### `src/features/catalogo/__tests__/useProductos.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

// Importar los hooks reales — ajustar ruta según el archivo fuente
// import { useProductos, useProducto, useCrearProducto, useActualizarProducto, useEliminarProducto } from '../hooks/useProductos'

const API_BASE = 'http://localhost:5000/api'

const productoTest = {
  id: 1,
  codigo: 'PROD-001',
  nombre: 'Producto Test',
  activo: true,
  precioVentaPublico: 118.00,
  stock: 50,
}

const respuestaPaginada = {
  datos: [productoTest],
  total: 1,
  pageNumber: 1,
  pageSize: 10,
  totalPages: 1,
  hasPreviousPage: false,
  hasNextPage: false,
  status: 200,
  message: '',
  transactionId: 'test',
}
```

Implementar estos tests:

1. `useProductos_ConRespuestaExitosa_DevuelveListaDeDatos()`
   ```typescript
   // Arrange
   server.use(
     http.get(`${API_BASE}/productos`, () => HttpResponse.json(respuestaPaginada))
   )

   // Act
   const { result } = renderHookConProveedores(() => useProductos())

   // Assert
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos).toHaveLength(1)
   expect(result.current.data?.datos[0].nombre).toBe('Producto Test')
   ```

2. `useProductos_ConError500_DevuelveEstadoError()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/productos`, () =>
       HttpResponse.json({ message: 'Error del servidor' }, { status: 500 })
     )
   )

   const { result } = renderHookConProveedores(() => useProductos())
   await waitFor(() => expect(result.current.isError).toBe(true))
   ```

3. `useProductos_EnEstadoCargando_DevuelveIsLoading()`
   ```typescript
   // El hook inicia en estado de carga antes de que MSW responda
   const { result } = renderHookConProveedores(() => useProductos())
   // En el primer render, debe estar cargando o en estado inicial
   expect(result.current.isLoading || result.current.isPending).toBe(true)
   ```

4. `useProducto_ConIdValido_DevuelveDetalleDelProducto()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/productos/1`, () =>
       HttpResponse.json({ ...productoTest, descripcion: 'Descripción completa' })
     )
   )

   const { result } = renderHookConProveedores(() => useProducto(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(1)
   ```

5. `useProducto_ConIdUndefined_NoHaceLlamada()`
   ```typescript
   // Cuando id es undefined, el hook no debe ejecutar la query (enabled: false)
   const { result } = renderHookConProveedores(() => useProducto(undefined as any))
   // No debe estar cargando ni en éxito — el hook está deshabilitado
   expect(result.current.fetchStatus).toBe('idle')
   ```

6. `useCrearProducto_ConDatosValidos_LlamaAlEndpointPost()`
   ```typescript
   let bodyRecibido: unknown
   server.use(
     http.post(`${API_BASE}/productos`, async ({ request }) => {
       bodyRecibido = await request.json()
       return HttpResponse.json({ ...productoTest, id: 99 }, { status: 201 })
     })
   )

   const { result } = renderHookConProveedores(() => useCrearProducto())

   act(() => {
     result.current.mutate({
       nombre: 'Nuevo Producto',
       codigo: 'NP-001',
       activo: true,
     } as any)
   })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(99)
   ```

7. `useActualizarProducto_ConIdYDatos_LlamaAlEndpointPut()`
   ```typescript
   server.use(
     http.put(`${API_BASE}/productos/1`, () =>
       HttpResponse.json({ ...productoTest, nombre: 'Producto Actualizado' })
     )
   )

   const { result } = renderHookConProveedores(() => useActualizarProducto())

   act(() => {
     result.current.mutate({ id: 1, datos: { nombre: 'Producto Actualizado' } as any })
   })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

8. `useEliminarProducto_ConIdValido_LlamaAlEndpointDelete()`
   ```typescript
   let deleteLlamado = false
   server.use(
     http.delete(`${API_BASE}/productos/1`, () => {
       deleteLlamado = true
       return new HttpResponse(null, { status: 204 })
     })
   )

   const { result } = renderHookConProveedores(() => useEliminarProducto())

   act(() => { result.current.mutate(1) })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(deleteLlamado).toBe(true)
   ```

### `src/features/catalogo/__tests__/useMarcas.test.ts`

Lee `hooks/useMarcas.ts` primero. Implementar:

```typescript
const marcaTest = { id: 1, nombre: 'Marca Test', descripcion: 'Test', activo: true }
```

1. `useMarcas_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/marcas`, () =>
       HttpResponse.json({ datos: [marcaTest], total: 1, pageNumber: 1, pageSize: 10, totalPages: 1 })
     )
   )
   const { result } = renderHookConProveedores(() => useMarcas())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos).toHaveLength(1)
   ```

2. `useCrearMarca_ConDatosValidos_CreaLaMarca()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/marcas`, () =>
       HttpResponse.json({ ...marcaTest, id: 5 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearMarca())
   act(() => { result.current.mutate({ nombre: 'Nueva Marca', activo: true } as any) })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

3. `useEliminarMarca_ConId_LlamaDelete()`
   ```typescript
   let deleteLlamado = false
   server.use(
     http.delete(`${API_BASE}/marcas/1`, () => {
       deleteLlamado = true
       return new HttpResponse(null, { status: 204 })
     })
   )
   const { result } = renderHookConProveedores(() => useEliminarMarca())
   act(() => { result.current.mutate(1) })
   await waitFor(() => expect(deleteLlamado).toBe(true))
   ```

### `src/features/catalogo/__tests__/useCategorias.test.ts`

Lee `hooks/useCategorias.ts` primero. Implementar:

```typescript
const categoriaTest = {
  id: 1,
  nombre: 'Categoría Test',
  descripcion: 'Test',
  idCategoriaPadre: null,
  activo: true,
}
```

1. `useCategorias_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/categorias`, () =>
       HttpResponse.json({ datos: [categoriaTest], total: 1, pageNumber: 1, pageSize: 10, totalPages: 1 })
     )
   )
   const { result } = renderHookConProveedores(() => useCategorias())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].nombre).toBe('Categoría Test')
   ```

2. `useCrearCategoria_ConDatosValidos_CreaLaCategoria()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/categorias`, () =>
       HttpResponse.json({ ...categoriaTest, id: 10 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearCategoria())
   act(() => { result.current.mutate({ nombre: 'Nueva Categoría', activo: true } as any) })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

3. `useActualizarCategoria_ConIdYDatos_ActualizaLaCategoria()`
   ```typescript
   server.use(
     http.put(`${API_BASE}/categorias/1`, () =>
       HttpResponse.json({ ...categoriaTest, nombre: 'Categoría Actualizada' })
     )
   )
   const { result } = renderHookConProveedores(() => useActualizarCategoria())
   act(() => { result.current.mutate({ id: 1, datos: { nombre: 'Categoría Actualizada' } as any }) })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- Siempre `await waitFor(...)` para esperar que los hooks asincrónicos resuelvan
- Leer el archivo fuente para confirmar nombres exactos de hooks y firmas de mutaciones
- NO inventar nombres de hooks — importar solo lo que realmente exporte el módulo

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/catalogo/__tests__/
```
