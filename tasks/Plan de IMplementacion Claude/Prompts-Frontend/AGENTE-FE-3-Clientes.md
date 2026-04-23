# AGENTE-FE-3 — Clientes Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de clientes de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/features/clientes/__tests__/` con tests para los hooks de clientes.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/clientes/hooks/useClientes.ts
src/features/clientes/servicios/servicioClientes.ts
src/features/clientes/types/cliente.types.ts
```

Si los hooks de clientes están en `src/features/ventas/hooks/useClientes.ts`, leer ese archivo.

## Conocimiento del dominio

### Tipos de documento en Perú
| ID | Tipo | Longitud |
|----|------|----------|
| 1 | DNI | 8 dígitos |
| 6 | RUC | 11 dígitos |
| 7 | Pasaporte | variable |
| 4 | Carné | hasta 12 |

### Regla SUNAT: Tipo de documento → Tipo de comprobante
- DNI (idTipoDocumento=1) → Boleta (código 03)
- RUC (idTipoDocumento=6) → Factura (código 01)

### URLs de la API
- `GET http://localhost:5000/api/clientes` → lista paginada
- `GET http://localhost:5000/api/clientes/{id}` → detalle
- `POST http://localhost:5000/api/clientes` → crear
- `PUT http://localhost:5000/api/clientes/{id}` → actualizar
- `DELETE http://localhost:5000/api/clientes/{id}` → eliminar
- `GET http://localhost:5000/api/clientes/documento/{numero}` → buscar por documento

### Clientes de test
```typescript
const clienteDni = {
  id: 1,
  idTipoDocumento: 1,
  tipoDocumentoCodigo: 'DNI',
  tipoDocumentoNombre: 'D.N.I.',
  numeroDocumento: '12345678',
  razonSocial: 'Juan Pérez García',
  email: 'juan@test.com',
  telefono: '987654321',
  activado: true,
}

const clienteRuc = {
  id: 2,
  idTipoDocumento: 6,
  tipoDocumentoCodigo: 'RUC',
  tipoDocumentoNombre: 'RUC',
  numeroDocumento: '20123456789',
  razonSocial: 'Empresa SAC',
  nombreComercial: 'Empresa',
  email: 'empresa@test.com',
  activado: true,
}
```

## Tests que debes implementar

### `src/features/clientes/__tests__/useClientes.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'
```

Implementar estos tests:

1. `useClientes_ConRespuestaExitosa_DevuelveListaPaginada()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/clientes`, () =>
       HttpResponse.json({
         datos: [clienteDni, clienteRuc],
         total: 2,
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

   const { result } = renderHookConProveedores(() => useClientes())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos).toHaveLength(2)
   ```

2. `useClientes_ConError_DevuelveEstadoError()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/clientes`, () =>
       HttpResponse.json({ message: 'Error' }, { status: 500 })
     )
   )
   const { result } = renderHookConProveedores(() => useClientes())
   await waitFor(() => expect(result.current.isError).toBe(true))
   ```

3. `useCliente_ConIdValido_DevuelveDetalleCompleto()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/clientes/1`, () =>
       HttpResponse.json({ ...clienteDni, contactos: [] })
     )
   )

   const { result } = renderHookConProveedores(() => useCliente(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.numeroDocumento).toBe('12345678')
   ```

4. `useCrearCliente_ConDniValido_CreaElCliente()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/clientes`, () =>
       HttpResponse.json({ ...clienteDni, id: 99 }, { status: 201 })
     )
   )

   const { result } = renderHookConProveedores(() => useCrearCliente())

   act(() => {
     result.current.mutate({
       idTipoDocumento: 1,
       numeroDocumento: '12345678',
       razonSocial: 'Juan Pérez García',
       activado: true,
     } as any)
   })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.id).toBe(99)
   ```

5. `useCrearCliente_ConRucValido_CreaElCliente()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/clientes`, () =>
       HttpResponse.json({ ...clienteRuc, id: 100 }, { status: 201 })
     )
   )

   const { result } = renderHookConProveedores(() => useCrearCliente())

   act(() => {
     result.current.mutate({
       idTipoDocumento: 6,
       numeroDocumento: '20123456789',
       razonSocial: 'Empresa SAC',
       activado: true,
     } as any)
   })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

6. `useActualizarCliente_ConDatosNuevos_ActualizaElCliente()`
   ```typescript
   server.use(
     http.put(`${API_BASE}/clientes/1`, () =>
       HttpResponse.json({ ...clienteDni, email: 'nuevo@test.com' })
     )
   )

   const { result } = renderHookConProveedores(() => useActualizarCliente())

   act(() => {
     result.current.mutate({ id: 1, datos: { email: 'nuevo@test.com' } as any })
   })

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

7. `useEliminarCliente_ConId_LlamaDelete()`
   ```typescript
   let deleteLlamado = false
   server.use(
     http.delete(`${API_BASE}/clientes/1`, () => {
       deleteLlamado = true
       return new HttpResponse(null, { status: 204 })
     })
   )

   const { result } = renderHookConProveedores(() => useEliminarCliente())
   act(() => { result.current.mutate(1) })
   await waitFor(() => expect(deleteLlamado).toBe(true))
   ```

8. `useBuscarClientePorDocumento_ConDni8Digitos_EjecutaLaBusqueda()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/clientes/documento/12345678`, () =>
       HttpResponse.json(clienteDni)
     )
   )

   // Este hook usa 'enabled: numeroDocumento.length >= 8'
   const { result } = renderHookConProveedores(
     () => useBuscarClientePorDocumento('12345678')
   )

   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.numeroDocumento).toBe('12345678')
   ```

9. `useBuscarClientePorDocumento_ConMenos8Digitos_NoEjecutaLaBusqueda()`
   ```typescript
   // Con menos de 8 caracteres, el hook está deshabilitado
   const { result } = renderHookConProveedores(
     () => useBuscarClientePorDocumento('123') // solo 3 dígitos
   )

   // fetchStatus 'idle' = no ejecutó la query
   expect(result.current.fetchStatus).toBe('idle')
   ```

10. `useHistorialCompras_ConIdCliente_DevuelveHistorial()`
    ```typescript
    server.use(
      http.get(`${API_BASE}/clientes/1/historial`, () =>
        HttpResponse.json({ ventas: [], total: 0 })
      )
    )

    // Verificar que el hook existe y ejecuta la llamada cuando hay idCliente
    // Ajustar según la firma real del hook en el archivo fuente
    const { result } = renderHookConProveedores(() => useHistorialCompras(1))
    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    ```

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- Leer el archivo fuente para confirmar nombres exactos de hooks y firmas
- Si la URL real del endpoint es diferente a la documentada, ajustar el handler MSW
- Usar `waitFor` siempre que se espere un estado asincrónico

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/clientes/__tests__/
```
