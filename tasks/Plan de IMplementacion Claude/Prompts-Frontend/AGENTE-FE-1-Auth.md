# AGENTE-FE-1 — Identidad / Autenticación Tests

## Contexto del proyecto

Eres un agente especializado en crear tests para el módulo de autenticación de un frontend React. El proyecto está en:
`D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend\`

La carpeta `src/__tests__/setup/` ya existe con `setup.ts`, `mswServer.ts` y `renderWithProviders.tsx` (creados por AGENTE-FE-0). Úsalos como base.

## Tu misión

Crear `src/features/identidad/__tests__/` con tests para el servicio de autenticación y el contexto de usuario.

## Archivos fuente que DEBES leer primero (TODOS obligatorios)

```
src/features/identidad/servicios/authService.ts
src/features/identidad/context/AuthContext.tsx
```

Lee ambos archivos completos antes de escribir cualquier test.

## Conocimiento del dominio

### JWT almacenado en localStorage
- `sc_token` → token JWT
- `sc_refresh` → refresh token

### Claims del JWT
El token tiene claims estándar más claims de la app:
- `sub` o `NameIdentifier` → userId
- `role` o `http://schemas.microsoft.com/ws/2008/06/identity/claims/role` → array de roles
- `permisos` → array de códigos de permiso (ej: `["VENTAS:VER", "VENTAS:CREAR"]`)
- `exp` → Unix timestamp de expiración

### Token de test para mockear
```typescript
// Token JWT válido para tests (firmado con clave de test)
// En los tests se usa directamente la librería jwt-decode o se mockea

// Para generar un token de test sin firma real:
const payloadTest = {
  sub: '1',
  username: 'admin',
  nombres: 'Admin',
  apellidos: 'Test',
  email: 'admin@test.com',
  role: ['ADMIN'],
  permisos: ['VENTAS:VER', 'VENTAS:CREAR'],
  exp: Math.floor(Date.now() / 1000) + 3600, // expira en 1 hora
}
```

### URLs de la API
- `POST http://localhost:5000/api/auth/login`
- `POST http://localhost:5000/api/auth/refresh`

## Tests que debes implementar

### `src/features/identidad/__tests__/authService.test.ts`

Lee `authService.ts` primero. Importa solo las funciones que realmente exporte.

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'

const API_BASE = 'http://localhost:5000/api'

// Limpiar localStorage antes de cada test
beforeEach(() => {
  localStorage.clear()
  vi.clearAllMocks()
})
```

Implementar los siguientes tests:

1. `login_ConCredencialesValidas_GuardaTokenEnLocalStorage()`
   ```typescript
   // Arrange
   server.use(
     http.post(`${API_BASE}/auth/login`, () =>
       HttpResponse.json({
         token: 'jwt-token-test',
         refreshToken: 'refresh-test',
         usuario: { id: 1, username: 'admin', nombres: 'Admin', apellidos: 'Test' },
       })
     )
   )

   // Act
   await authService.login({ username: 'admin', password: '1234' })

   // Assert
   expect(localStorage.setItem).toHaveBeenCalledWith('sc_token', 'jwt-token-test')
   ```

2. `login_ConCredencialesInvalidas_LanzaError()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/auth/login`, () =>
       HttpResponse.json({ message: 'Credenciales inválidas' }, { status: 401 })
     )
   )
   await expect(authService.login({ username: 'mal', password: 'mal' })).rejects.toThrow()
   ```

3. `logout_LimpiaTokensDelLocalStorage()`
   ```typescript
   // Simular que hay tokens
   localStorage.setItem('sc_token', 'token-existente')
   localStorage.setItem('sc_refresh', 'refresh-existente')

   authService.logout()

   expect(localStorage.removeItem).toHaveBeenCalledWith('sc_token')
   expect(localStorage.removeItem).toHaveBeenCalledWith('sc_refresh')
   ```

4. `getToken_CuandoHayToken_DevuelveToken()`
   ```typescript
   localStorage.getItem.mockReturnValue('mi-token')
   expect(authService.getToken()).toBe('mi-token')
   ```

5. `getToken_CuandoNoHayToken_DevuelveNull()`
   ```typescript
   localStorage.getItem.mockReturnValue(null)
   expect(authService.getToken()).toBeNull()
   ```

6. `refresh_ConRefreshTokenValido_ActualizaToken()`
   ```typescript
   server.use(
     http.post(`${API_BASE}/auth/refresh`, () =>
       HttpResponse.json({
         token: 'nuevo-token',
         refreshToken: 'nuevo-refresh',
         usuario: { id: 1 },
       })
     )
   )

   await authService.refresh('refresh-token-valido')

   expect(localStorage.setItem).toHaveBeenCalledWith('sc_token', 'nuevo-token')
   ```

### `src/features/identidad/__tests__/AuthContext.test.tsx`

Lee `AuthContext.tsx` primero. Importa `AuthProvider` y `useAuth` (o el nombre real que usen).

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { renderHook, act } from '@testing-library/react'
import { renderHookConProveedores } from '../../../__tests__/setup/renderWithProviders'
import { server } from '../../../__tests__/setup/mswServer'
import { http, HttpResponse } from 'msw'
```

**NOTA IMPORTANTE**: Los tests del AuthContext/useAuth pueden requerir envolver con `AuthProvider`. Lee el archivo fuente para saber si `useAuth` depende de un contexto separado o si puede usarse directamente. Ajusta el wrapper según corresponda.

Implementar los siguientes tests:

1. `useAuth_InicialmenteSinToken_EstaNoAutenticado()`
   ```typescript
   // Arrange
   localStorage.getItem.mockReturnValue(null)

   // Act
   const { result } = renderHookConProveedores(() => useAuth())

   // Assert
   expect(result.current.estaAutenticado).toBe(false)
   expect(result.current.usuario).toBeNull()
   ```

2. `useAuth_ConTokenValido_DecodificaRolesCorrectamente()`
   ```typescript
   // Para este test, mockear la función jwt-decode o proporcionar un token real
   // Verificar que los roles se extraen correctamente del JWT
   // NOTA: Lee AuthContext.tsx para ver cómo obtiene los roles del token

   // Si AuthContext usa localStorage directamente, simular:
   // localStorage.getItem.mockReturnValueOnce('token-con-roles')
   // y mockear jwt-decode para retornar el payload esperado
   ```

3. `loginInfo_AlLlamarConDatos_ActualizaEstadoDeAutenticado()`
   ```typescript
   // Act
   const { result } = renderHookConProveedores(() => useAuth())

   act(() => {
     result.current.loginInfo(
       { id: 1, username: 'admin', nombres: 'Admin', apellidos: 'Test', email: 'a@b.com' },
       'jwt-token-test'
     )
   })

   // Assert
   expect(result.current.estaAutenticado).toBe(true)
   expect(result.current.usuario?.username).toBe('admin')
   ```

4. `logout_AlLlamar_LimpiaEstadoDeAutenticacion()`
   ```typescript
   const { result } = renderHookConProveedores(() => useAuth())

   // Primero autenticar
   act(() => {
     result.current.loginInfo(
       { id: 1, username: 'admin', nombres: 'Admin', apellidos: 'Test', email: 'a@b.com' },
       'jwt-token-test'
     )
   })

   // Luego desloguear
   act(() => {
     result.current.logout()
   })

   expect(result.current.estaAutenticado).toBe(false)
   expect(result.current.usuario).toBeNull()
   ```

5. `useAuth_ConRolesEnToken_ExponeLosRoles()`
   ```typescript
   // Verifica que result.current.roles es un array con los roles del JWT
   // Adaptar según cómo AuthContext.tsx extrae los roles
   ```

6. `useAuth_ConTokenExpirado_NoAutenticaAlUsuario()`
   ```typescript
   // Token expirado = exp < Date.now() / 1000
   // Verificar que el contexto detecta la expiración
   // NOTA: Lee cómo AuthContext verifica la expiración del token
   ```

## Reglas obligatorias

- Patrón AAA: `// Arrange`, `// Act`, `// Assert`
- Nombres: `[funcion]_[condicion]_[resultadoEsperado]`
- NO importar de rutas que no existen — leer el archivo fuente primero
- Si `useAuth` necesita un Provider específico, usar `renderHook` con el wrapper correcto
- `vi.mock('jwt-decode', ...)` si los tests de claims del JWT son complejos

## Verificación final

```bash
cd D:\Personal\Proyectos\SistemaComercial\Codigo\Frontend
npm run test:run -- src/features/identidad/__tests__/
```
