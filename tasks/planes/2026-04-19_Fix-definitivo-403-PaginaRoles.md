# Plan de Implementación: Fix Definitivo — Error 403 en PaginaRoles

**Fecha:** 2026-04-19
**Generado por:** Claude Code
**Ejecuta:** Antigravity (Gemini Flash)
**Revisa:** Claude Code

---

## Contexto

Al intentar guardar la matriz de permisos granulares en `PaginaRoles` como usuario administrador (rol `ADMINISTRADOR`), el sistema retorna HTTP 403. El error es recurrente porque hay **tres bugs distintos** que se combinan:

1. **Gateway**: La verificación de rol admin usa `string.Contains()` case-sensitive y sin logging — si el claim falla por cualquier motivo, el middleware bloquea silenciosamente sin evidencia.
2. **RefreshTokenManejador**: Al renovar el JWT, usa el repositorio de permisos VIEJO (`IPermisoRepositorio`) en lugar del granular (`IRolMenuPermisoRepositorio`). Resultado: tras el primer refresh automático, el token pierde todos los permisos granulares.
3. **PaginaRoles (Frontend)**: El `catch` de `handleGuardar` no diferencia un 403 de un error de red genérico — el usuario no sabe si debe re-loguearse.

Ninguno de los tres cambios es complejo. Se pueden ejecutar en paralelo. No hay migraciones de BD.

---

## Referencias de Código Existente

Los agentes DEBEN leer estos archivos como contexto ANTES de modificar nada:

- `Codigo/Backend/src/Gateway.API/Program.cs` — archivo completo a modificar (Tarea A)
- `Codigo/Backend/src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs` — archivo completo a modificar (Tarea B)
- `Codigo/Backend/src/Identidad.API/Identidad.API.Application/Features/Auth/Login/LoginManejador.cs` — **modelo a replicar** en el Refresh (las líneas de `_rolMenuPermisoRepositorio`)
- `Codigo/Frontend/src/features/identidad/pages/PaginaRoles.tsx` — archivo completo a modificar (Tarea C)
- `Codigo/Frontend/src/features/identidad/context/AuthContext.tsx` — para entender qué exporta `useAuth` (roles, permisos)

---

## Reglas Críticas (extraídas de GEMINI.md)

- **Nunca dejar un `catch` vacío o con solo `toast.error` genérico** — siempre inspeccionar el código HTTP.
- **Todo bloque que pueda fallar → `try/catch`** con manejo descriptivo.
- **Impacto mínimo**: Cada tarea toca SOLO los archivos listados. No refactorizar nada extra.
- **Verificación obligatoria**: Tras cada tarea ejecutar `dotnet build` (backend) o `npx tsc --noEmit` (frontend) y confirmar 0 errores.
- **Append-only en `tasks/`**: Al terminar, crear archivo de resumen en `tasks/planes/` con lo que se hizo — NO tocar `todo.md`.

---

## Tarea A — Gateway: Fix verificación de admin + logging (Agente 1)

**Tiempo estimado:** 10 minutos
**Archivo único:** `Codigo/Backend/src/Gateway.API/Program.cs`

### Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Backend/src/Gateway.API/Program.cs` | MODIFICAR | 3 cambios puntuales dentro del middleware custom |

### Especificación detallada

El middleware custom de autorización está en las líneas ~108-212 de `Program.cs`. Hay que hacer **3 cambios** dentro de ese bloque `app.Use(...)`:

#### Cambio 1 — Reemplazar la verificación de admin (línea ~136)

**BUSCAR exactamente esta línea:**
```csharp
bool esAdmin = roles.Contains("ADMINISTRADOR");
```

**REEMPLAZAR por:**
```csharp
bool esAdmin = context.User?.IsInRole("ADMINISTRADOR") == true
    || roles.Any(r => r.Equals("ADMINISTRADOR", StringComparison.OrdinalIgnoreCase));
```

**Explicación**: `IsInRole` usa `ClaimTypes.Role` (el claim estándar de .NET que viene del JWT `"role"` claim). El fallback `roles.Any(...)` cubre el custom claim `"roles"` con comparación insensible a mayúsculas. Doble seguro.

---

#### Cambio 2 — Agregar logging en el bloque de denegación admin (línea ~147-157)

**BUSCAR exactamente este bloque:**
```csharp
    if (authRutaAdmin && !esAdmin)
    {
        context.Response.StatusCode = 403;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { 
            status = 403, 
            message = "Acceso denegado. Se requieren privilegios administrativos.",
            transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
        });
        return;
    }
```

**REEMPLAZAR por:**
```csharp
    if (authRutaAdmin && !esAdmin)
    {
        var userIdLog = context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "anonimo";
        Console.WriteLine($"[403-ADMIN] User={userIdLog} | Ruta={path} | Metodo={method} | RolesEnToken=[{string.Join(", ", roles)}] | IsInRole={context.User?.IsInRole("ADMINISTRADOR")}");
        context.Response.StatusCode = 403;
        context.Response.ContentType = "application/json";
        await context.Response.WriteAsJsonAsync(new { 
            status = 403, 
            message = "Acceso denegado. Se requieren privilegios administrativos.",
            transactionId = DateTime.Now.ToString("yyyyMMddHHmmssfff")
        });
        return;
    }
```

---

#### Cambio 3 — Agregar rutas de seguridad a `authRutaAdmin` (línea ~140-145)

**BUSCAR exactamente este bloque:**
```csharp
    bool authRutaAdmin =
        (path.StartsWith("/api/usuarios") && method != "GET") ||
        (path.StartsWith("/api/roles") && method != "GET") ||
        (path.StartsWith("/api/trabajadores") && method != "GET") ||
        (path.StartsWith("/api/configuracion") && method != "GET") ||
        (path.StartsWith("/api/contabilidad") && method != "GET");
```

**REEMPLAZAR por:**
```csharp
    bool authRutaAdmin =
        (path.StartsWith("/api/usuarios") && method != "GET") ||
        (path.StartsWith("/api/roles") && method != "GET") ||
        (path.StartsWith("/api/menus") && method != "GET") ||
        (path.StartsWith("/api/tipos-permiso") && method != "GET") ||
        (path.StartsWith("/api/roles-menus") && method != "GET") ||
        (path.StartsWith("/api/trabajadores") && method != "GET") ||
        (path.StartsWith("/api/configuracion") && method != "GET") ||
        (path.StartsWith("/api/contabilidad") && method != "GET");
```

### Criterio de completitud

- [ ] `bool esAdmin` usa `IsInRole` con fallback `OrdinalIgnoreCase`
- [ ] El bloque `if (authRutaAdmin && !esAdmin)` tiene `Console.WriteLine` con `RolesEnToken` e `IsInRole`
- [ ] `authRutaAdmin` incluye `/api/menus`, `/api/tipos-permiso` y `/api/roles-menus`
- [ ] `dotnet build` en el proyecto `Gateway.API` retorna 0 errores, 0 warnings relevantes
- [ ] No se modificó ninguna otra sección del archivo

### ⚠️ Trampas comunes

- **NO mover el middleware**: El bloque `app.Use(...)` debe quedar en la misma posición (después de `app.UseAuthorization()` y antes de `app.MapReverseProxy()`). No reorganizar el pipeline.
- **NO cambiar el `authRutaAdmin` para GET requests**: Los GET de `/api/menus`, `/api/tipos-permiso` son públicos para usuarios autenticados. Solo se bloquea `method != "GET"`.
- **El `ClaimTypes` ya está importado** en el archivo (ver línea 8: `using System.Security.Claims;`). No agregar using duplicado.
- **NO usar `StringComparison.InvariantCultureIgnoreCase`** — usar `OrdinalIgnoreCase` que es más eficiente para comparaciones de identidad.

---

## Tarea B — RefreshTokenManejador: usar permisos granulares (Agente 2)

**Tiempo estimado:** 10 minutos
**Archivo único:** `Codigo/Backend/src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs`

### Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Backend/src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs` | MODIFICAR | Reemplazar repositorio de permisos viejo por granular |

### Contexto del problema

El `LoginManejador.cs` (leer como referencia) usa en la línea 55:
```csharp
var permisos = await _rolMenuPermisoRepositorio.ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id);
```

Pero el `RefreshTokenManejador.cs` usa en la línea 47-49:
```csharp
var rolIds = usuario.UsuariosRoles.Select(ur => ur.IdRol).ToList();
var permisos = await _permisoRepositorio.ObtenerCodigosPorRolIdsAsync(rolIds);
```

Esto genera un JWT con permisos del sistema viejo (o vacío) en vez del sistema granular. Hay que sincronizarlo con `LoginManejador`.

### Especificación detallada

#### Cambio 1 — Agregar campo al constructor

**BUSCAR el bloque de campos privados (líneas ~13-16):**
```csharp
        private readonly IRefreshTokenRepositorio _refreshTokenRepositorio;
        private readonly ITokenService _tokenService;
        private readonly IUsuarioRepositorio _usuarioRepositorio;
        private readonly IPermisoRepositorio _permisoRepositorio;
```

**REEMPLAZAR por** (agregar `IRolMenuPermisoRepositorio`):
```csharp
        private readonly IRefreshTokenRepositorio _refreshTokenRepositorio;
        private readonly ITokenService _tokenService;
        private readonly IUsuarioRepositorio _usuarioRepositorio;
        private readonly IPermisoRepositorio _permisoRepositorio;
        private readonly IRolMenuPermisoRepositorio _rolMenuPermisoRepositorio;
```

#### Cambio 2 — Agregar parámetro al constructor

**BUSCAR la firma del constructor (líneas ~19-24):**
```csharp
        public RefreshTokenManejador(
            IRefreshTokenRepositorio refreshTokenRepositorio, 
            ITokenService tokenService, 
            IUsuarioRepositorio usuarioRepositorio,
            IPermisoRepositorio permisoRepositorio)
        {
```

**REEMPLAZAR por:**
```csharp
        public RefreshTokenManejador(
            IRefreshTokenRepositorio refreshTokenRepositorio, 
            ITokenService tokenService, 
            IUsuarioRepositorio usuarioRepositorio,
            IPermisoRepositorio permisoRepositorio,
            IRolMenuPermisoRepositorio rolMenuPermisoRepositorio)
        {
```

#### Cambio 3 — Agregar asignación en el body del constructor

**BUSCAR el cierre del constructor (líneas ~25-30):**
```csharp
        {
            _refreshTokenRepositorio = refreshTokenRepositorio;
            _tokenService = tokenService;
            _usuarioRepositorio = usuarioRepositorio;
            _permisoRepositorio = permisoRepositorio;
        }
```

**REEMPLAZAR por:**
```csharp
        {
            _refreshTokenRepositorio = refreshTokenRepositorio;
            _tokenService = tokenService;
            _usuarioRepositorio = usuarioRepositorio;
            _permisoRepositorio = permisoRepositorio;
            _rolMenuPermisoRepositorio = rolMenuPermisoRepositorio;
        }
```

#### Cambio 4 — Reemplazar la obtención de permisos en el método Handle

**BUSCAR las líneas 46-49 en el método `Handle`:**
```csharp
            var roles = usuario.UsuariosRoles.Select(ur => ur.Rol.NombreRol).ToList();
            var rolIds = usuario.UsuariosRoles.Select(ur => ur.IdRol).ToList();
            
            var permisos = await _permisoRepositorio.ObtenerCodigosPorRolIdsAsync(rolIds);
```

**REEMPLAZAR por** (eliminar `rolIds`, usar sistema granular igual que LoginManejador):
```csharp
            var roles = usuario.UsuariosRoles.Select(ur => ur.Rol.NombreRol).ToList();
            
            var permisos = await _rolMenuPermisoRepositorio.ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id);
```

#### Cambio 5 — Verificar que el using del namespace de IRolMenuPermisoRepositorio esté presente

La interfaz `IRolMenuPermisoRepositorio` vive en `Identidad.API.Domain.Interfaces`. Si ese using **no existe** al inicio del archivo, agregarlo:

```csharp
using Identidad.API.Domain.Interfaces;
```

**Verificar primero** que el using ya esté incluido antes de agregarlo — no duplicar.

### Criterio de completitud

- [ ] El constructor tiene 5 parámetros (agregado `IRolMenuPermisoRepositorio rolMenuPermisoRepositorio`)
- [ ] El campo `_rolMenuPermisoRepositorio` existe y está asignado
- [ ] El método `Handle` NO usa `rolIds` ni `_permisoRepositorio.ObtenerCodigosPorRolIdsAsync`
- [ ] El método `Handle` usa `_rolMenuPermisoRepositorio.ObtenerPermisosAplanadosPorUsuarioAsync(usuario.Id)`
- [ ] `dotnet build` en el proyecto completo de `Identidad.API` retorna 0 errores

### ⚠️ Trampas comunes

- **NO eliminar el campo `_permisoRepositorio`**: Puede que exista otro método en la clase que lo use. Solo modificar el método `Handle`.
- **NO eliminar el parámetro `IPermisoRepositorio permisoRepositorio` del constructor**: Mismo motivo — mantenerlo aunque ya no se use en `Handle`, para no romper la inyección de dependencias.
- **La DI ya está registrada**: `IRolMenuPermisoRepositorio` ya está registrado en `Program.cs` de Identidad.API (línea 45: `builder.Services.AddScoped<IRolMenuPermisoRepositorio, RolMenuPermisoRepositorio>()`). No hay que registrar nada más.
- **Verificar que `usuario.UsuariosRoles` tenga datos cargados**: El repositorio `ObtenerPorIdAsync` debe hacer eager loading de `UsuariosRoles`. Si no, `usuario.UsuariosRoles` estará vacío. Verificar en el código existente de `LoginManejador` que se haga el mismo call — si Login funciona correctamente, Refresh también funcionará con el mismo patrón.

---

## Tarea C — Frontend PaginaRoles: manejo defensivo de 403 + guard de admin (Agente 3)

**Tiempo estimado:** 10 minutos
**Archivo único:** `Codigo/Frontend/src/features/identidad/pages/PaginaRoles.tsx`

### Archivos a modificar

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Frontend/src/features/identidad/pages/PaginaRoles.tsx` | MODIFICAR | 3 cambios: import, guard y catch de 403 |

### Especificación detallada

#### Cambio 1 — Importar `useAuth`

**BUSCAR la línea de importación de `toast`:**
```typescript
import { toast } from "sonner";
```

**REEMPLAZAR por** (agregar import de useAuth en la misma zona):
```typescript
import { toast } from "sonner";
import { useAuth } from "@/features/identidad/context/AuthContext";
```

---

#### Cambio 2 — Extraer `roles` del contexto y derivar `esAdmin`

**BUSCAR el bloque de estados al inicio de `PaginaRoles()` (línea ~31):**
```typescript
    const [roles, setRoles] = useState<RolDto[]>([]);
```

Hay un conflicto de nombre: el estado local también se llama `roles` pero es `RolDto[]`. Renombrar la variable del contexto para evitar colisión. **Agregar estas dos líneas ANTES de los useState**, como primera línea del componente:

```typescript
export function PaginaRoles() {
    const { roles: rolesUsuario } = useAuth();
    const esAdmin = rolesUsuario.includes("ADMINISTRADOR");
    
    const [roles, setRoles] = useState<RolDto[]>([]);
    // ... resto sin cambios
```

**IMPORTANTE**: Solo agregar las 2 líneas nuevas al inicio. NO tocar ningún `useState` existente.

---

#### Cambio 3 — Manejar 403 específicamente en `handleGuardar`

**BUSCAR el catch de `handleGuardar` (línea ~132):**
```typescript
        } catch (error) {
            toast.error("Error al guardar la matriz de accesos");
        } finally {
```

**REEMPLAZAR por:**
```typescript
        } catch (error: any) {
            const status = error?.response?.status;
            if (status === 403) {
                toast.error("Sin permisos para guardar. Cierra sesión e inicia sesión nuevamente.", {
                    duration: 6000
                });
            } else {
                toast.error("Error al guardar la matriz de accesos");
            }
        } finally {
```

---

#### Cambio 4 — Deshabilitar el botón Guardar si no es admin

**BUSCAR el botón Guardar (línea ~207-212):**
```tsx
                            <Button 
                                onClick={handleGuardar} 
                                disabled={saving || loadingAccesos}
                                className="h-10 px-6 gap-2 shadow-lg shadow-primary/20"
                            >
```

**REEMPLAZAR por** (agregar `|| !esAdmin` al disabled):
```tsx
                            <Button 
                                onClick={handleGuardar} 
                                disabled={saving || loadingAccesos || !esAdmin}
                                className="h-10 px-6 gap-2 shadow-lg shadow-primary/20"
                                title={!esAdmin ? "Se requiere rol Administrador" : undefined}
                            >
```

### Criterio de completitud

- [ ] `useAuth` está importado desde `@/features/identidad/context/AuthContext`
- [ ] `const { roles: rolesUsuario } = useAuth()` y `const esAdmin = ...` son las primeras líneas del componente (antes de los `useState`)
- [ ] El `catch` de `handleGuardar` tiene `error: any` y diferencia status 403
- [ ] El botón Guardar tiene `disabled={saving || loadingAccesos || !esAdmin}`
- [ ] `npx tsc --noEmit` ejecutado en `Codigo/Frontend/` retorna 0 errores

### ⚠️ Trampas comunes

- **Conflicto de nombre `roles`**: El estado local `const [roles, setRoles] = useState<RolDto[]>([])` y el del contexto se llaman igual. Por eso el contexto se extrae como `rolesUsuario`. Si Flash usa `roles` para ambos, TypeScript lanzará un error de tipo (array de `string` vs array de `RolDto`).
- **NO tipar `error` como `AxiosError`**: Usar `error: any` y acceder con `error?.response?.status`. Evita agregar imports innecesarios.
- **La variable `esAdmin` no reemplaza el estado `saving`**: Son independientes. `saving` controla el estado del request, `esAdmin` es un computed del contexto.
- **NO envolver `useAuth()` en un `useEffect`**: Es un hook que se llama directamente en el cuerpo del componente, en la primera línea.
- **El `toast.error` con `duration: 6000`**: Dar 6 segundos al usuario para leer el mensaje de re-login. Si la sintaxis de `sonner` no acepta options directamente, usar: `toast.error("mensaje", { duration: 6000 })`.

---

## Dependencias entre Tareas

```
Tarea A (Gateway)          → Independiente, ejecutar primero
Tarea B (RefreshToken)     → Independiente, puede ser paralela con A
Tarea C (Frontend)         → Independiente, puede ser paralela con A y B
```

Las tres tareas son **completamente paralelas**. No comparten archivos. Cada agente trabaja en un archivo distinto.

---

## Checklist de Revisión Final (Claude Code)

- [ ] **Gateway**: `dotnet build Codigo/Backend/src/Gateway.API` → 0 errores
- [ ] **Identidad.API**: `dotnet build Codigo/Backend/src/Identidad.API` → 0 errores
- [ ] **Frontend**: `npx tsc --noEmit` en `Codigo/Frontend/` → 0 errores
- [ ] **Gateway `Program.cs`**: Verificar que `esAdmin` usa `IsInRole` Y `OrdinalIgnoreCase`
- [ ] **Gateway `Program.cs`**: Verificar que el bloque 403-admin tiene `Console.WriteLine` con `RolesEnToken`
- [ ] **Gateway `Program.cs`**: Verificar que `authRutaAdmin` incluye `/api/menus`, `/api/tipos-permiso`, `/api/roles-menus`
- [ ] **RefreshTokenManejador**: Verificar que el constructor tiene 5 parámetros
- [ ] **RefreshTokenManejador**: Verificar que `Handle` usa `ObtenerPermisosAplanadosPorUsuarioAsync`
- [ ] **RefreshTokenManejador**: Verificar que NO usa `ObtenerCodigosPorRolIdsAsync` ni `rolIds`
- [ ] **PaginaRoles.tsx**: Verificar que `useAuth` está importado
- [ ] **PaginaRoles.tsx**: Verificar que `esAdmin` se deriva de `rolesUsuario.includes("ADMINISTRADOR")`
- [ ] **PaginaRoles.tsx**: Verificar que el `catch` diferencia 403
- [ ] **PaginaRoles.tsx**: Verificar que el botón tiene `|| !esAdmin` en su `disabled`
- [ ] **Prueba funcional**: Login como ADMINISTRADOR → ir a Seguridad/Roles → seleccionar rol → modificar checkbox → clic "Guardar Permisos" → debe aparecer toast de éxito, no 403

---

## Comandos de Verificación

```bash
# Verificar Gateway
cd "Codigo/Backend/src/Gateway.API"
dotnet build

# Verificar Identidad.API
cd "Codigo/Backend/src/Identidad.API"
dotnet build

# Verificar Frontend TypeScript
cd "Codigo/Frontend"
npx tsc --noEmit

# Buscar que el RefreshToken ya no use el repositorio viejo
grep -n "ObtenerCodigosPorRolIdsAsync" "Codigo/Backend/src/Identidad.API/Identidad.API.Application/Features/Auth/Refresh/RefreshTokenManejador.cs"
# Debe retornar: sin resultados

# Buscar que el Gateway tenga IsInRole
grep -n "IsInRole" "Codigo/Backend/src/Gateway.API/Program.cs"
# Debe retornar al menos 1 línea

# Buscar que el frontend tiene el guard
grep -n "esAdmin" "Codigo/Frontend/src/features/identidad/pages/PaginaRoles.tsx"
# Debe retornar al menos 3 líneas (declaración, disabled, catch)
```
