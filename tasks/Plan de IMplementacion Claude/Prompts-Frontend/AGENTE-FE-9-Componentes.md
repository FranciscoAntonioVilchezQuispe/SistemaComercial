# AGENTE-FE-9 — Componentes Compartidos Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para componentes React compartidos. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx`. Úsalos.

## Tu misión

Crear `src/compartido/__tests__/` con tests para:
1. El hook `usePermiso` (permisos y roles)
2. El componente `TablaPaginada` (tabla con paginación)
3. El componente `RutaProtegida` (guarda de rutas)

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/compartido/hooks/usePermiso.ts
src/compartido/componentes/tablas/TablaPaginada.tsx
src/compartido/componentes/seguridad/RutaProtegida.tsx
src/features/identidad/context/AuthContext.tsx
```

Lee todos los archivos antes de escribir cualquier test.

## Conocimiento del dominio

### Sistema de permisos
Los permisos tienen formato: `"CODIGO_MENU:ACCION"` donde ACCION es: `VER`, `CREAR`, `EDITAR`, `ELIMINAR`

Ejemplos:
- `"VENTAS:VER"` — ver módulo de ventas
- `"VENTAS:CREAR"` — crear ventas
- `"CONFIGURACION:EDITAR"` — editar configuración
- `"CATALOGO:ELIMINAR"` — eliminar productos

Los roles son strings: `"ADMIN"`, `"VENDEDOR"`, `"ALMACENERO"`, etc.

### Hook usePermiso
```typescript
// usePermiso(codigoMenu, accion): boolean
const puedeCrear = usePermiso('VENTAS', 'CREAR')

// usePermisoMenu(codigoMenu): boolean — tiene CUALQUIER permiso en ese menú
const tieneAcceso = usePermisoMenu('VENTAS')

// useEsAdmin(): boolean
const esAdmin = useEsAdmin()
```

> **NOTA**: Lee `usePermiso.ts` para ver la implementación exacta. El hook probablemente consume `AuthContext` internamente.

### RutaProtegida
Un componente HOC que verifica si el usuario tiene el permiso requerido:
- Si tiene permiso → renderiza los `children`
- Si no tiene permiso → redirige a `/no-autorizado` o muestra `PaginaNoAutorizado`

### TablaPaginada
Tabla genérica que recibe:
- `columnas`: definición de columnas
- `datos`: array de datos
- `total`: total de registros
- `pagina` / `pageNumber`: página actual
- `pageSize`: tamaño de página
- `onCambioPagina` / `onChange`: callback al cambiar página
- `cargando` / `isLoading`: estado de carga

## Tests que debes implementar

### `src/compartido/__tests__/usePermiso.test.ts`

```typescript
import { describe, it, expect, beforeEach } from 'vitest'
import { renderHookConProveedores } from '../../__tests__/setup/renderWithProviders'
import { act } from '@testing-library/react'
// Importar usePermiso, usePermisoMenu, useEsAdmin según lo que exporte el módulo
```

**NOTA CRÍTICA**: El hook `usePermiso` probablemente usa `AuthContext` internamente. Para que funcione en tests, el usuario debe estar autenticado con permisos específicos. Hay dos enfoques:

**Opción A** — Mock del AuthContext:
```typescript
import { vi } from 'vitest'
vi.mock('../../features/identidad/context/AuthContext', () => ({
  useAuth: () => ({
    estaAutenticado: true,
    roles: ['VENDEDOR'],
    permisos: ['VENTAS:VER', 'VENTAS:CREAR'],
    usuario: { id: 1, username: 'vendedor' },
  }),
}))
```

**Opción B** — Si AuthContext permite pasar estado inicial, usarlo.

Lee `usePermiso.ts` y `AuthContext.tsx` para elegir la opción correcta.

1. `usePermiso_ConPermisoEnLaLista_DevuelveTrue()`
   ```typescript
   // Arrange: usuario con permiso "VENTAS:VER"
   // (Mockear AuthContext si es necesario)

   // Act
   const { result } = renderHookConProveedores(
     () => usePermiso('VENTAS', 'VER')
   )

   // Assert
   expect(result.current).toBe(true)
   ```

2. `usePermiso_SinElPermiso_DevuelveFalse()`
   ```typescript
   // Usuario tiene VENTAS:VER pero NO VENTAS:ELIMINAR
   const { result } = renderHookConProveedores(
     () => usePermiso('VENTAS', 'ELIMINAR')
   )
   expect(result.current).toBe(false)
   ```

3. `usePermiso_ConPermisoDeOtroModulo_DevuelveFalse()`
   ```typescript
   // Usuario tiene VENTAS:VER pero NO CATALOGO:VER
   const { result } = renderHookConProveedores(
     () => usePermiso('CATALOGO', 'VER')
   )
   expect(result.current).toBe(false)
   ```

4. `usePermisoMenu_ConAlgunPermisoEnElMenu_DevuelveTrue()`
   ```typescript
   // Usuario tiene VENTAS:VER (tiene algo en VENTAS)
   const { result } = renderHookConProveedores(
     () => usePermisoMenu('VENTAS')
   )
   expect(result.current).toBe(true)
   ```

5. `usePermisoMenu_SinNingunPermisoEnElMenu_DevuelveFalse()`
   ```typescript
   const { result } = renderHookConProveedores(
     () => usePermisoMenu('COMPRAS') // no tiene permisos de COMPRAS
   )
   expect(result.current).toBe(false)
   ```

6. `useEsAdmin_ConRolAdmin_DevuelveTrue()`
   ```typescript
   // Mock: roles = ['ADMIN']
   const { result } = renderHookConProveedores(() => useEsAdmin())
   expect(result.current).toBe(true)
   ```

7. `useEsAdmin_ConRolVendedor_DevuelveFalse()`
   ```typescript
   // Mock: roles = ['VENDEDOR']
   const { result } = renderHookConProveedores(() => useEsAdmin())
   expect(result.current).toBe(false)
   ```

### `src/compartido/__tests__/TablaPaginada.test.tsx`

Lee `TablaPaginada.tsx` primero para conocer la interfaz exacta de props.

```typescript
import { describe, it, expect, vi } from 'vitest'
import { screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { renderConProveedores } from '../../__tests__/setup/renderWithProviders'
// import TablaPaginada from '../componentes/tablas/TablaPaginada'
```

**Definición de columnas de test** (adaptar según la interfaz real de TablaPaginada):
```typescript
const columnasTest = [
  { key: 'id', header: 'ID', accessor: 'id' },
  { key: 'nombre', header: 'Nombre', accessor: 'nombre' },
]
// O si usa la interfaz de TanStack Table:
// const columnasTest: ColumnDef<any>[] = [...]
// Lee TablaPaginada.tsx para saber el formato exacto
```

**Datos de test**:
```typescript
const datosTest = [
  { id: 1, nombre: 'Item 1' },
  { id: 2, nombre: 'Item 2' },
  { id: 3, nombre: 'Item 3' },
]
```

1. `TablaPaginada_ConDatos_RenderizaLasFilas()`
   ```typescript
   // Arrange
   renderConProveedores(
     <TablaPaginada
       columnas={columnasTest}
       datos={datosTest}
       total={3}
       pageNumber={1}
       pageSize={10}
       onCambioPagina={vi.fn()}
       cargando={false}
     />
   )

   // Assert — los datos deben estar en el DOM
   expect(screen.getByText('Item 1')).toBeInTheDocument()
   expect(screen.getByText('Item 2')).toBeInTheDocument()
   expect(screen.getByText('Item 3')).toBeInTheDocument()
   ```

2. `TablaPaginada_EnEstadoCargando_MuestraIndicadorDeCarga()`
   ```typescript
   renderConProveedores(
     <TablaPaginada
       columnas={columnasTest}
       datos={[]}
       total={0}
       pageNumber={1}
       pageSize={10}
       onCambioPagina={vi.fn()}
       cargando={true}
     />
   )

   // Debe haber algún indicador de carga (spinner, skeleton, etc.)
   // Ajustar el selector según lo que realmente renderiza TablaPaginada
   expect(
     screen.queryByText('Item 1') // datos no deben mostrarse
   ).not.toBeInTheDocument()
   ```

3. `TablaPaginada_SinDatos_MuestraMensajeVacio()`
   ```typescript
   renderConProveedores(
     <TablaPaginada
       columnas={columnasTest}
       datos={[]}
       total={0}
       pageNumber={1}
       pageSize={10}
       onCambioPagina={vi.fn()}
       cargando={false}
     />
   )

   // Debe mostrar algún mensaje de "sin datos" o estado vacío
   // El texto exacto depende de la implementación — leer el componente
   // expect(screen.getByText(/sin datos|no hay registros|vacío/i)).toBeInTheDocument()
   ```

4. `TablaPaginada_AlHacerClickEnSiguiente_LlamaOnCambioPagina()`
   ```typescript
   const onCambioPaginaMock = vi.fn()
   const user = userEvent.setup()

   renderConProveedores(
     <TablaPaginada
       columnas={columnasTest}
       datos={datosTest}
       total={25} // más de una página
       pageNumber={1}
       pageSize={10}
       onCambioPagina={onCambioPaginaMock}
       cargando={false}
     />
   )

   // Hacer click en botón "Siguiente" (ajustar selector según el componente real)
   const botonSiguiente = screen.getByRole('button', { name: /siguiente|next|›|>/i })
   await user.click(botonSiguiente)

   expect(onCambioPaginaMock).toHaveBeenCalledWith(2)
   ```

5. `TablaPaginada_RenderizaEncabezadosDeColumnas()`
   ```typescript
   renderConProveedores(
     <TablaPaginada
       columnas={columnasTest}
       datos={[]}
       total={0}
       pageNumber={1}
       pageSize={10}
       onCambioPagina={vi.fn()}
       cargando={false}
     />
   )

   expect(screen.getByText('ID')).toBeInTheDocument()
   expect(screen.getByText('Nombre')).toBeInTheDocument()
   ```

### `src/compartido/__tests__/RutaProtegida.test.tsx`

Lee `RutaProtegida.tsx` primero. Luego implementar:

```typescript
import { describe, it, expect, vi } from 'vitest'
import { screen } from '@testing-library/react'
import { renderConProveedores } from '../../__tests__/setup/renderWithProviders'
// import RutaProtegida from '../componentes/seguridad/RutaProtegida'
```

**NOTA**: Los tests de RutaProtegida requieren mockear `useAuth` o `usePermiso` para simular distintos estados de autenticación y permisos.

```typescript
// Mock del contexto de autenticación
const mockUseAuth = vi.fn()
vi.mock('../../features/identidad/context/AuthContext', () => ({
  useAuth: () => mockUseAuth(),
}))

// Mock del hook usePermiso (si RutaProtegida lo usa)
vi.mock('../hooks/usePermiso', () => ({
  usePermiso: vi.fn(),
  usePermisoMenu: vi.fn(),
  useEsAdmin: vi.fn(),
}))
```

1. `RutaProtegida_UsuarioAutenticadoConPermiso_RenderizaLosHijos()`
   ```typescript
   // Arrange — usuario autenticado con permiso
   mockUseAuth.mockReturnValue({
     estaAutenticado: true,
     permisos: ['VENTAS:VER'],
     roles: ['VENDEDOR'],
   })

   // Act
   renderConProveedores(
     <RutaProtegida codigoMenu="VENTAS" accion="VER">
       <div data-testid="contenido-protegido">Contenido visible</div>
     </RutaProtegida>
   )

   // Assert
   expect(screen.getByTestId('contenido-protegido')).toBeInTheDocument()
   ```

2. `RutaProtegida_UsuarioSinPermiso_NoRenderizaLosHijos()`
   ```typescript
   mockUseAuth.mockReturnValue({
     estaAutenticado: true,
     permisos: ['VENTAS:VER'], // tiene VER pero no ELIMINAR
     roles: ['VENDEDOR'],
   })

   renderConProveedores(
     <RutaProtegida codigoMenu="VENTAS" accion="ELIMINAR">
       <div data-testid="contenido-protegido">Contenido restringido</div>
     </RutaProtegida>
   )

   expect(screen.queryByTestId('contenido-protegido')).not.toBeInTheDocument()
   ```

3. `RutaProtegida_UsuarioNoAutenticado_RedirigEALogin()`
   ```typescript
   mockUseAuth.mockReturnValue({
     estaAutenticado: false,
     permisos: [],
     roles: [],
   })

   // Renderizar con initialEntries para verificar redirección
   renderConProveedores(
     <RutaProtegida codigoMenu="VENTAS" accion="VER">
       <div data-testid="contenido-protegido">Contenido</div>
     </RutaProtegida>,
     { initialEntries: ['/ventas'] }
   )

   // El contenido protegido no debe verse
   expect(screen.queryByTestId('contenido-protegido')).not.toBeInTheDocument()
   ```

4. `RutaProtegida_UsuarioAdmin_SiempreTieneAcceso()`
   ```typescript
   // Admin tiene acceso a todo
   mockUseAuth.mockReturnValue({
     estaAutenticado: true,
     permisos: [], // sin permisos explícitos
     roles: ['ADMIN'],
   })

   renderConProveedores(
     <RutaProtegida codigoMenu="CONFIGURACION" accion="EDITAR">
       <div data-testid="admin-content">Panel Admin</div>
     </RutaProtegida>
   )

   // Admin debe ver el contenido (si esa es la regla de negocio)
   // NOTA: Ajustar según la lógica real de RutaProtegida
   ```

## Instrucción especial

**Si los tests de TablaPaginada o RutaProtegida son difíciles de testear** por dependencias internas complejas (contextos, state interno), prioriza los tests de `usePermiso` que son más directos y tienen mayor valor para el negocio.

**Si la firma de props de TablaPaginada no coincide**, lee el componente y ajusta los tests a la interfaz real — no inventes props.

**Para los mocks de contexto**: Si `vi.mock()` con rutas relativas no funciona, usa el alias de path: `vi.mock('@features/identidad/context/AuthContext', ...)`.

## Reglas obligatorias

- Patrón AAA en cada test
- Nombres: `[componente/hook]_[condicion]_[resultadoEsperado]`
- Leer los archivos fuente antes de escribir — los props reales pueden diferir
- `screen.getByRole` y `screen.getByText` son preferibles a `getByTestId`
- Si un test es imposible por dependencias internas, escribir un comentario explicando por qué se omite

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/compartido/__tests__/
```
