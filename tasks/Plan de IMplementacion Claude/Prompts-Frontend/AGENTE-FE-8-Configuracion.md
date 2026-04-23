# AGENTE-FE-8 — Configuración Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de configuración de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/features/configuracion/__tests__/` con tests para los hooks de configuración del sistema.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/configuracion/hooks/useSeriesComprobante.ts
src/features/configuracion/hooks/useTablaGeneral.ts
src/features/configuracion/hooks/useImpuestos.ts
src/features/configuracion/hooks/useTipoComprobante.ts
src/features/configuracion/servicios/servicioSerieComprobante.ts
src/features/configuracion/servicios/servicioTablaGeneral.ts
src/features/configuracion/servicios/servicioImpuesto.ts
src/features/configuracion/servicios/servicioTipoComprobante.ts
```

Si alguno de estos archivos no existe, listar los que sí existen en `src/features/configuracion/hooks/` y crear tests para los disponibles.

## Conocimiento del dominio

### Series de comprobante (SUNAT)
| Serie | Tipo |
|-------|------|
| `F001` | Factura Electrónica |
| `B001` | Boleta de Venta Electrónica |
| `FC01` | Nota de Crédito (Factura) |
| `FD01` | Nota de Débito (Factura) |

### Tipos de comprobante (SUNAT Catálogo 01)
| Código | Nombre |
|--------|--------|
| `01` | Factura |
| `03` | Boleta de Venta |
| `07` | Nota de Crédito |
| `08` | Nota de Débito |

### IGV configurado
- ID: 1000
- Porcentaje: 18.00%
- Código: `1000` en `configuracion.impuestos`

### URLs de la API
- `GET http://localhost:5000/api/configuracion/series-comprobante` → lista series
- `GET http://localhost:5000/api/configuracion/series-comprobante/{id}` → detalle
- `POST http://localhost:5000/api/configuracion/series-comprobante` → crear
- `PUT http://localhost:5000/api/configuracion/series-comprobante/{id}` → actualizar
- `GET http://localhost:5000/api/configuracion/tablas-generales` → lista tablas
- `GET http://localhost:5000/api/configuracion/tablas-generales/{id}/detalles` → detalles de tabla
- `GET http://localhost:5000/api/configuracion/impuestos` → lista impuestos
- `GET http://localhost:5000/api/configuracion/tipos-comprobante` → lista tipos

> **NOTA**: Lee `servicioSerieComprobante.ts` para verificar las rutas exactas. Pueden diferir de las documentadas.

### Datos de test
```typescript
const serieTest = {
  id: 1,
  serie: 'F001',
  idTipoComprobante: 1,
  tipoComprobanteNombre: 'Factura',
  idAlmacen: 1,
  almacenNombre: 'Almacén Principal',
  ultimoNumero: 1,
  activo: true,
}

const tablaGeneralTest = {
  id: 1,
  codigo: 'TABLA_15',
  nombre: 'Estados de Documento',
  descripcion: 'Estados del ciclo de vida del documento',
  activo: true,
}

const detalleTablaTest = {
  id: 60,
  idTablaGeneral: 1,
  codigo: '60',
  nombre: 'Registrado',
  descripcion: 'Documento registrado',
  orden: 1,
  activo: true,
}

const impuestoTest = {
  id: 1000,
  codigo: '1000',
  nombre: 'IGV',
  porcentaje: 18.00,
  activo: true,
}

const tipoComprobanteTest = {
  id: 1,
  codigo: '01',
  nombre: 'Factura',
  descripcion: 'Factura Electrónica',
  activo: true,
}
```

## Tests que debes implementar

### `src/features/configuracion/__tests__/useSeriesComprobante.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { waitFor, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'
```

1. `useSeriesComprobante_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   // Ajustar URL según servicioSerieComprobante.ts
   server.use(
     http.get(`${API_BASE}/configuracion/series-comprobante`, () =>
       HttpResponse.json({
         datos: [serieTest], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   const { result } = renderHookConProveedores(() => useSeriesComprobante())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].serie).toBe('F001')
   ```

2. `useSerieComprobante_ConId_DevuelveDetalleConUltimoNumero()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/configuracion/series-comprobante/1`, () =>
       HttpResponse.json({ ...serieTest, ultimoNumero: 42 })
     )
   )
   const { result } = renderHookConProveedores(() => useSerieComprobante(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.ultimoNumero).toBe(42)
   ```

3. `useCrearSerieComprobante_ConSerieF001_CreaLaSerie()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/configuracion/series-comprobante`, () =>
       HttpResponse.json({ ...serieTest, id: 99 }, { status: 201 })
     )
   )
   const { result } = renderHookConProveedores(() => useCrearSerieComprobante())
   act(() => {
     result.current.mutate({
       serie: 'F001',
       idTipoComprobante: 1,
       idAlmacen: 1,
       activo: true,
     } as any)
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

4. `useActualizarSerieComprobante_ConDatosNuevos_ActualizaLaSerie()`
   ```typescript
   server.use(
     http.put(`${API_BASE}/configuracion/series-comprobante/1`, () =>
       HttpResponse.json({ ...serieTest, activo: false })
     )
   )
   const { result } = renderHookConProveedores(() => useActualizarSerieComprobante())
   act(() => {
     result.current.mutate({ id: 1, datos: { activo: false } as any })
   })
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   ```

### `src/features/configuracion/__tests__/useTablaGeneral.test.ts`

5. `useTablaGeneral_ConRespuestaExitosa_DevuelveLista()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/configuracion/tablas-generales`, () =>
       HttpResponse.json({
         datos: [tablaGeneralTest], total: 1, pageNumber: 1, pageSize: 10,
         totalPages: 1, hasPreviousPage: false, hasNextPage: false,
         status: 200, message: '', transactionId: 'test',
       })
     )
   )
   // Ajustar nombre del hook según lo que exporte useTablaGeneral.ts
   const { result } = renderHookConProveedores(() => useTablasGenerales())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data?.datos[0].nombre).toBe('Estados de Documento')
   ```

6. `useDetallesTablaGeneral_ConTablaId_DevuelveDetalles()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/configuracion/tablas-generales/1/detalles`, () =>
       HttpResponse.json([detalleTablaTest])
     )
   )
   // Ajustar nombre del hook y URL según el servicio real
   const { result } = renderHookConProveedores(() => useDetallesTablaGeneral(1))
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data).toHaveLength(1)
   expect(result.current.data![0].nombre).toBe('Registrado')
   ```

7. `useDetallesTablaGeneral_ConIdUndefined_NoEjecutaLaQuery()`
   ```typescript
   const { result } = renderHookConProveedores(
     () => useDetallesTablaGeneral(undefined as any)
   )
   expect(result.current.fetchStatus).toBe('idle')
   ```

8. `useImpuestos_DevuelveImpuestoConIGV()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/configuracion/impuestos`, () =>
       HttpResponse.json([impuestoTest])
     )
   )
   // Ajustar nombre del hook
   const { result } = renderHookConProveedores(() => useImpuestos())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))

   // Verificar que el IGV (18%) está en la lista
   const igv = result.current.data?.find(i => i.porcentaje === 18)
   expect(igv).toBeDefined()
   expect(igv?.codigo).toBe('1000')
   ```

9. `useTipoComprobante_DevuelveTiposDeComprobante()`
   ```typescript
   server.use(
     http.get(`${API_BASE}/configuracion/tipos-comprobante`, () =>
       HttpResponse.json([tipoComprobanteTest])
     )
   )
   const { result } = renderHookConProveedores(() => useTipoComprobante())
   await waitFor(() => expect(result.current.isSuccess).toBe(true))
   expect(result.current.data).toHaveLength(1)
   expect(result.current.data![0].codigo).toBe('01')
   ```

10. `useTipoComprobante_DevuelveFacturaYBoleta()`
    ```typescript
    server.use(
      http.get(`${API_BASE}/configuracion/tipos-comprobante`, () =>
        HttpResponse.json([
          { id: 1, codigo: '01', nombre: 'Factura', activo: true },
          { id: 2, codigo: '03', nombre: 'Boleta de Venta', activo: true },
        ])
      )
    )
    const { result } = renderHookConProveedores(() => useTipoComprobante())
    await waitFor(() => expect(result.current.isSuccess).toBe(true))

    const codigos = result.current.data?.map(t => t.codigo)
    expect(codigos).toContain('01') // Factura
    expect(codigos).toContain('03') // Boleta
    ```

## Instrucción especial

Lee todos los archivos de hooks antes de escribir tests. Los nombres de hooks y las URLs exactas de los servicios pueden diferir. Si un hook no existe, omite ese test y escribe un comentario indicando que el hook no fue encontrado.

Para cada hook, el patrón mínimo de test es:
1. Test de éxito (200 OK)
2. Test de error (500 o 404)
3. Test de `enabled: false` si el hook acepta parámetro opcional

## Reglas obligatorias

- Patrón AAA en cada test
- Nombres: `[hook]_[condicion]_[resultadoEsperado]`
- `await waitFor(...)` para estados asincrónico
- NO inventar nombres de hooks — leer los archivos fuente

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/configuracion/__tests__/
```
