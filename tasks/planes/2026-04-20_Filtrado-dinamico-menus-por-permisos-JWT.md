# Plan de Implementación: Filtrado Dinámico de Menús por Permisos JWT

**Fecha:** 2026-04-20
**Generado por:** Claude Code
**Ejecuta:** Antigravity (Gemini Flash) — 4 agentes en paralelo
**Revisa:** Claude Code

---

## Contexto

Actualmente el sidebar muestra TODOS los módulos a cualquier usuario autenticado. El Gateway sí valida permisos en cada request y retorna 403 si el usuario no tiene acceso — pero el usuario ya vio el menú, navegó a la página y tuvo que esperar el error. Esto es mala UX y expone la arquitectura.

**Objetivo:** El JWT ya contiene los permisos del usuario (`"permisos": ["VENTAS:VER", "VENTAS:CREAR", ...]`). El frontend debe leer esos permisos y:
1. **Sidebar**: Ocultar secciones enteras si el usuario no tiene ningún permiso del módulo.
2. **Rutas**: Redirigir a `/no-autorizado` si el usuario intenta navegar directamente a una ruta sin permiso.
3. **Gateway**: Asegurar que todos los prefijos de ruta estén mapeados a un código de módulo.

**Formato de permisos en JWT:**
```
"VENTAS:VER"       → puede ver listados de ventas
"VENTAS:CREAR"     → puede crear ventas
"COMPRAS:EDITAR"   → puede editar compras
"VENTAS_POS:VER"   → submenú específico
```
El admin (`rol ADMINISTRADOR`) bypasea TODOS los checks — siempre ve todo.

---

## Referencias Obligatorias (leer antes de empezar)

- `Codigo/Frontend/src/features/identidad/context/AuthContext.tsx` — qué exporta `useAuth` (`roles`, `permisos`)
- `Codigo/Frontend/src/config/menu.tsx` — estructura actual de `menuItems` e interfaz `ItemMenu`
- `Codigo/Frontend/src/layouts/LayoutPrincipal/Sidebar.tsx` — cómo se renderiza el menú hoy
- `Codigo/Frontend/src/compartido/componentes/seguridad/RutaProtegida.tsx` — guard actual
- `Codigo/Frontend/src/configuracion/rutas.tsx` — definición completa de rutas
- `Codigo/Backend/src/Gateway.API/Program.cs` — mapeo ruta→menuCodigo (líneas 164-183), para entender los códigos válidos

---

## Reglas Críticas

- **Admin siempre pasa**: `roles.includes("ADMINISTRADOR")` → bypass total, ve todos los menús y accede a todas las rutas.
- **Los códigos de menú DEBEN coincidir** con los `menuCodigo` del Gateway (`VENTAS`, `COMPRAS`, `INVENTARIO`, `CLIENTES`, `CATALOGO`, `CONFIGURACION`, `CONTABILIDAD`). Escribir distinto rompe la coherencia.
- **Impacto mínimo**: Solo modificar los 5 archivos del plan + crear 2 archivos nuevos. No tocar páginas individuales.
- **No tipar `error` como `AxiosError`** — no importar tipos de axios innecesarios.
- **Verificación obligatoria**: `npx tsc --noEmit` sin errores al final de cada tarea frontend. `dotnet build` para la tarea backend.
- **El interceptor Axios global ya maneja 403** — no agregar toasts duplicados.

---

## Tarea A — Frontend: Hook `usePermiso` + `menu.tsx` con códigos (Agente 1)

**Tiempo estimado:** 15 minutos
**Puede ejecutarse en paralelo con B, C y D.**

### Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Frontend/src/compartido/hooks/usePermiso.ts` | CREAR | Hook reutilizable para verificar permisos del JWT |
| `Codigo/Frontend/src/config/menu.tsx` | MODIFICAR | Agregar `codigoPermiso` y `soloAdmin` a la interfaz y a cada ítem |

---

### Especificación: `usePermiso.ts` (CREAR)

Crear el archivo en `Codigo/Frontend/src/compartido/hooks/usePermiso.ts` con el siguiente contenido **exacto**:

```typescript
import { useAuth } from "@/features/identidad/context/AuthContext";

export type AccionPermiso = "VER" | "CREAR" | "EDITAR" | "ELIMINAR";

export function usePermiso(codigoMenu: string, accion: AccionPermiso = "VER"): boolean {
    const { roles, permisos } = useAuth();

    const esAdmin = roles.some(r => r === "ADMINISTRADOR");
    if (esAdmin) return true;

    const permisoExacto = `${codigoMenu}:${accion}`;
    const tieneExacto = permisos.includes(permisoExacto);
    const tieneSubMenu = permisos.some(
        p => p.startsWith(`${codigoMenu}_`) && p.endsWith(`:${accion}`)
    );

    return tieneExacto || tieneSubMenu;
}

export function usePermisoMenu(codigoMenu: string): boolean {
    return usePermiso(codigoMenu, "VER");
}

export function useEsAdmin(): boolean {
    const { roles } = useAuth();
    return roles.some(r => r === "ADMINISTRADOR");
}
```

**Notas:**
- La lógica `tieneExacto || tieneSubMenu` replica EXACTAMENTE la del Gateway (`Program.cs` líneas 200-201).
- `usePermisoMenu` es el shorthand para verificar visibilidad de ítems del sidebar (solo necesitan `VER`).
- `useEsAdmin` es el shorthand reutilizable para checks de admin en cualquier componente.

---

### Especificación: `menu.tsx` (MODIFICAR)

**Cambio 1 — Extender la interfaz `ItemMenu`:**

BUSCAR:
```typescript
export interface ItemMenu {
  titulo: string;
  icono: React.ReactNode;
  ruta?: string;
  subItems?: ItemMenu[];
}
```

REEMPLAZAR POR:
```typescript
export interface ItemMenu {
  titulo: string;
  icono: React.ReactNode;
  ruta?: string;
  subItems?: ItemMenu[];
  codigoPermiso?: string;
  soloAdmin?: boolean;
}
```

---

**Cambio 2 — Agregar `codigoPermiso`/`soloAdmin` a cada ítem del array `menuItems`:**

El array `menuItems` completo debe quedar así (reemplazar todo el array):

```typescript
export const menuItems: ItemMenu[] = [
  {
    titulo: RUTAS_TITULOS["/dashboard"] || "Dashboard",
    icono: <LayoutDashboard className="h-5 w-5" />,
    ruta: "/dashboard",
    // Sin codigoPermiso: dashboard es visible para todos los autenticados
  },
  {
    titulo: "Catálogo",
    icono: <Package className="h-5 w-5" />,
    codigoPermiso: "CATALOGO",
    subItems: [
      { titulo: RUTAS_TITULOS["/catalogo/productos"] || "Productos", icono: <Box className="h-6 w-6" />, ruta: "/catalogo/productos", codigoPermiso: "CATALOGO" },
      { titulo: RUTAS_TITULOS["/catalogo/categorias"] || "Categorías", icono: <FolderTree className="h-6 w-6" />, ruta: "/catalogo/categorias", codigoPermiso: "CATALOGO" },
      { titulo: RUTAS_TITULOS["/catalogo/marcas"] || "Marcas", icono: <Tags className="h-6 w-6" />, ruta: "/catalogo/marcas", codigoPermiso: "CATALOGO" },
      { titulo: RUTAS_TITULOS["/catalogo/unidades-medida"] || "Unidades de Medida", icono: <Ruler className="h-6 w-6" />, ruta: "/catalogo/unidades-medida", codigoPermiso: "CATALOGO" },
      { titulo: RUTAS_TITULOS["/catalogo/listas-precios"] || "Listas de Precios", icono: <DollarSign className="h-6 w-6" />, ruta: "/catalogo/listas-precios", codigoPermiso: "CATALOGO" },
    ],
  },
  {
    titulo: "Ventas",
    icono: <ShoppingCart className="h-5 w-5" />,
    codigoPermiso: "VENTAS",
    subItems: [
      { titulo: RUTAS_TITULOS["/ventas/pos"] || "Punto de Venta", icono: <Calculator className="h-6 w-6" />, ruta: "/ventas/pos", codigoPermiso: "VENTAS" },
      { titulo: RUTAS_TITULOS["/ventas/lista"] || "Ventas", icono: <List className="h-6 w-6" />, ruta: "/ventas/lista", codigoPermiso: "VENTAS" },
      { titulo: RUTAS_TITULOS["/ventas/notas"] || "Notas SUNAT", icono: <FileText className="h-6 w-6" />, ruta: "/ventas/notas", codigoPermiso: "VENTAS" },
      { titulo: RUTAS_TITULOS["/ventas/cotizaciones"] || "Cotizaciones", icono: <FileText className="h-6 w-6" />, ruta: "/ventas/cotizaciones", codigoPermiso: "VENTAS" },
      { titulo: RUTAS_TITULOS["/clientes"] || "Clientes", icono: <Users className="h-6 w-6" />, ruta: "/clientes", codigoPermiso: "CLIENTES" },
    ],
  },
  {
    titulo: "Inventario",
    icono: <Warehouse className="h-5 w-5" />,
    codigoPermiso: "INVENTARIO",
    subItems: [
      { titulo: RUTAS_TITULOS["/inventario/stock"] || "Stock", icono: <Box className="h-6 w-6" />, ruta: "/inventario/stock", codigoPermiso: "INVENTARIO" },
      { titulo: RUTAS_TITULOS["/inventario/movimientos"] || "Operaciones", icono: <ArrowLeftRight className="h-6 w-6" />, ruta: "/inventario/movimientos", codigoPermiso: "INVENTARIO" },
      { titulo: RUTAS_TITULOS["/inventario/traslados"] || "Traslados", icono: <Truck className="h-6 w-6" />, ruta: "/inventario/traslados", codigoPermiso: "INVENTARIO" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/reporte"] || "Reporte Kardex", icono: <BarChart3 className="h-6 w-6" />, ruta: "/inventario/kardex/reporte", codigoPermiso: "INVENTARIO" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/periodos"] || "Periodos Kardex", icono: <History className="h-6 w-6" />, ruta: "/inventario/kardex/periodos", codigoPermiso: "INVENTARIO" },
      { titulo: RUTAS_TITULOS["/inventario/almacenes"] || "Almacenes", icono: <Home className="h-6 w-6" />, ruta: "/inventario/almacenes", codigoPermiso: "INVENTARIO" },
    ],
  },
  {
    titulo: "Compras",
    icono: <ShoppingBag className="h-5 w-5" />,
    codigoPermiso: "COMPRAS",
    subItems: [
      { titulo: RUTAS_TITULOS["/proveedores/ordenes"] || "Órdenes de Compra", icono: <ClipboardList className="h-6 w-6" />, ruta: "/proveedores/ordenes", codigoPermiso: "COMPRAS" },
      { titulo: "Compras", icono: <ShoppingBag className="h-6 w-6" />, ruta: "/compras/lista", codigoPermiso: "COMPRAS" },
      { titulo: RUTAS_TITULOS["/compras/notas"] || "Notas de Compra", icono: <FileText className="h-6 w-6" />, ruta: "/compras/notas", codigoPermiso: "COMPRAS" },
      { titulo: RUTAS_TITULOS["/proveedores"] || "Proveedores", icono: <Truck className="h-6 w-6" />, ruta: "/proveedores", codigoPermiso: "COMPRAS" },
    ],
  },
  {
    titulo: RUTAS_TITULOS["/reportes"] || "Reportes",
    icono: <FileText className="h-5 w-5" />,
    ruta: "/reportes",
    // Sin codigoPermiso: reportes visibles para todos los autenticados
  },
  {
    titulo: "Seguridad",
    icono: <ShieldCheck className="h-5 w-5 text-emerald-600" />,
    soloAdmin: true,
    subItems: [
      { titulo: "Usuarios", icono: <Users className="h-6 w-6" />, ruta: "/seguridad/usuarios", soloAdmin: true },
      { titulo: "Roles y Permisos", icono: <UserCheck className="h-6 w-6" />, ruta: "/seguridad/roles", soloAdmin: true },
      { titulo: "Personal", icono: <UserPlus className="h-6 w-6" />, ruta: "/seguridad/trabajadores", soloAdmin: true },
    ],
  },
  {
    titulo: "Configuración",
    icono: <Settings className="h-5 w-5" />,
    codigoPermiso: "CONFIGURACION",
    subItems: [
      { titulo: RUTAS_TITULOS["/configuracion/empresa"] || "Empresa", icono: <Building2 className="h-6 w-6" />, ruta: "/configuracion/empresa", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/sucursales"] || "Sucursales", icono: <Home className="h-6 w-6" />, ruta: "/configuracion/sucursales", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/impuestos"] || "Impuestos", icono: <Percent className="h-6 w-6" />, ruta: "/configuracion/impuestos", codigoPermiso: "CONFIGURACION" },
      { titulo: "Afectación IGV", icono: <ShieldCheck className="h-6 w-6" />, ruta: "/configuracion/afectacion-igv", codigoPermiso: "CONFIGURACION" },
      { titulo: "Tipos de Tributo", icono: <Calculator className="h-6 w-6" />, ruta: "/configuracion/tipos-tributo", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/metodos-pago"] || "Métodos de Pago", icono: <CreditCard className="h-6 w-6" />, ruta: "/configuracion/metodos-pago", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/comprobantes"] || "Comprobantes", icono: <FileJson className="h-6 w-6" />, ruta: "/configuracion/comprobantes", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/reglas-sunat"] || "Reglas SUNAT", icono: <ShieldCheck className="h-6 w-6" />, ruta: "/configuracion/reglas-sunat", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/operaciones-sunat"] || "Op. SUNAT", icono: <FileText className="h-6 w-6" />, ruta: "/configuracion/operaciones-sunat", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/matriz-sunat"] || "Matriz SUNAT", icono: <Table className="h-6 w-6" />, ruta: "/configuracion/matriz-sunat", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/tablas-generales"] || "Tablas Generales", icono: <List className="h-6 w-6" />, ruta: "/configuracion/tablas-generales", codigoPermiso: "CONFIGURACION" },
      { titulo: RUTAS_TITULOS["/configuracion/ubigeos"] || "Ubigeos", icono: <MapPin className="h-6 w-6" />, ruta: "/configuracion/ubigeos", codigoPermiso: "CONFIGURACION" },
    ],
  },
];
```

### Criterio de completitud — Tarea A
- [ ] Archivo `usePermiso.ts` creado en `src/compartido/hooks/`
- [ ] Exporta `usePermiso`, `usePermisoMenu` y `useEsAdmin`
- [ ] `menu.tsx` — interfaz `ItemMenu` tiene `codigoPermiso?` y `soloAdmin?`
- [ ] Todos los ítems padres tienen `codigoPermiso` o `soloAdmin` asignado
- [ ] `npx tsc --noEmit` → 0 errores

### ⚠️ Trampas comunes — Tarea A
- **Los códigos son exactamente**: `"VENTAS"`, `"COMPRAS"`, `"INVENTARIO"`, `"CLIENTES"`, `"CATALOGO"`, `"CONFIGURACION"`. En MAYÚSCULAS, sin tildes. Si escribe `"Ventas"` o `"VENTA"` no coincidirá con el Gateway.
- **Dashboard y Reportes NO tienen `codigoPermiso`** — son visibles para todos los autenticados. No agregar uno inventado.
- **Seguridad usa `soloAdmin: true`**, no `codigoPermiso`. Son conceptos distintos.
- **No cambiar los imports** del archivo `menu.tsx` — los iconos ya están importados.

---

## Tarea B — Frontend: Sidebar filtrado por permisos (Agente 2)

**Tiempo estimado:** 15 minutos
**Puede ejecutarse en paralelo con A, C y D.**
**IMPORTANTE:** Esta tarea asume que `menu.tsx` ya tiene `codigoPermiso` y `soloAdmin`. Si ejecuta en paralelo, usar el código de `menu.tsx` del plan de Tarea A como referencia — no el archivo actual.

### Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Frontend/src/layouts/LayoutPrincipal/Sidebar.tsx` | MODIFICAR | Filtrar items según permisos del JWT |

---

### Especificación: `Sidebar.tsx` (MODIFICAR)

Reemplazar el archivo completo con:

```tsx
import { NavLink } from "react-router-dom";
import { ChevronDown } from "lucide-react";
import { cn } from "@/lib/utils";
import { useState } from "react";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";
import { ItemMenu, menuItems } from "@/config/menu";
import { useAuth } from "@/features/identidad/context/AuthContext";

interface PropiedadesSidebar {
  abierto: boolean;
  onMouseEnter?: () => void;
  onMouseLeave?: () => void;
}

function usePuedeVerItem(item: ItemMenu): boolean {
  const { roles, permisos } = useAuth();
  const esAdmin = roles.some(r => r === "ADMINISTRADOR");

  if (esAdmin) return true;
  if (item.soloAdmin) return false;
  if (!item.codigoPermiso) return true; // sin restricción (Dashboard, Reportes)

  const permisoVer = `${item.codigoPermiso}:VER`;
  return permisos.includes(permisoVer) ||
         permisos.some(p => p.startsWith(`${item.codigoPermiso}_`) && p.endsWith(":VER"));
}

function ItemMenuSidebar({
  item,
  abierto,
}: {
  item: ItemMenu;
  abierto: boolean;
}) {
  const [expandido, setExpandido] = useState(false);
  const puedeVer = usePuedeVerItem(item);

  if (!puedeVer) return null;

  // Item con subitems
  if (item.subItems) {
    const subItemsVisibles = item.subItems.filter(sub => {
      const { roles, permisos } = useAuthSnapshot();
      const esAdmin = roles.some(r => r === "ADMINISTRADOR");
      if (esAdmin) return true;
      if (sub.soloAdmin) return false;
      if (!sub.codigoPermiso) return true;
      const permisoVer = `${sub.codigoPermiso}:VER`;
      return permisos.includes(permisoVer) ||
             permisos.some(p => p.startsWith(`${sub.codigoPermiso}_`) && p.endsWith(":VER"));
    });

    if (subItemsVisibles.length === 0) return null;

    return (
      <Collapsible open={expandido} onOpenChange={setExpandido}>
        <CollapsibleTrigger className="w-full">
          <div
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-accent",
              !abierto && "justify-center",
            )}
          >
            {item.icono}
            {abierto && (
              <>
                <span className="flex-1 text-left">{item.titulo}</span>
                <ChevronDown
                  className={cn(
                    "h-4 w-4 transition-transform",
                    expandido && "rotate-180",
                  )}
                />
              </>
            )}
          </div>
        </CollapsibleTrigger>
        {abierto && (
          <CollapsibleContent className="space-y-1 pl-6">
            {subItemsVisibles.map((subItem, index) => (
              <NavLink
                key={index}
                to={subItem.ruta!}
                className={({ isActive }) =>
                  cn(
                    "flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-muted-foreground transition-all hover:text-primary hover:bg-accent",
                    isActive && "bg-accent text-primary font-medium",
                  )
                }
              >
                {subItem.titulo}
              </NavLink>
            ))}
          </CollapsibleContent>
        )}
      </Collapsible>
    );
  }

  // Item simple
  return (
    <NavLink
      to={item.ruta!}
      className={({ isActive }) =>
        cn(
          "flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-accent",
          isActive && "bg-accent text-primary font-medium",
          !abierto && "justify-center",
        )
      }
    >
      {item.icono}
      {abierto && <span>{item.titulo}</span>}
    </NavLink>
  );
}

export function Sidebar({
  abierto,
  onMouseEnter,
  onMouseLeave,
}: PropiedadesSidebar) {
  return (
    <aside
      className={cn(
        "fixed left-0 top-16 z-40 h-[calc(100vh-4rem)] border-r bg-background transition-all duration-300",
        abierto ? "w-64" : "w-16",
      )}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      <nav className="flex flex-col gap-1 p-4 h-full overflow-y-auto">
        {menuItems.map((item, index) => (
          <ItemMenuSidebar key={index} item={item} abierto={abierto} />
        ))}
      </nav>
    </aside>
  );
}
```

**ATENCIÓN — error en el código anterior**: El código de `subItemsVisibles` usa `useAuthSnapshot()` que no existe porque los hooks de React NO pueden llamarse dentro de callbacks (viola las reglas de hooks). Esto causará un error de compilación. El agente DEBE reescribir la función `ItemMenuSidebar` usando este patrón correcto:

```tsx
function ItemMenuSidebar({
  item,
  abierto,
}: {
  item: ItemMenu;
  abierto: boolean;
}) {
  const [expandido, setExpandido] = useState(false);
  const { roles, permisos } = useAuth();

  const esAdmin = roles.some(r => r === "ADMINISTRADOR");

  const puedeVerItem = (i: ItemMenu): boolean => {
    if (esAdmin) return true;
    if (i.soloAdmin) return false;
    if (!i.codigoPermiso) return true;
    const permisoVer = `${i.codigoPermiso}:VER`;
    return permisos.includes(permisoVer) ||
           permisos.some(p => p.startsWith(`${i.codigoPermiso}_`) && p.endsWith(":VER"));
  };

  if (!puedeVerItem(item)) return null;

  if (item.subItems) {
    const subItemsVisibles = item.subItems.filter(puedeVerItem);
    if (subItemsVisibles.length === 0) return null;

    return (
      <Collapsible open={expandido} onOpenChange={setExpandido}>
        <CollapsibleTrigger className="w-full">
          <div className={cn(
            "flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-accent",
            !abierto && "justify-center",
          )}>
            {item.icono}
            {abierto && (
              <>
                <span className="flex-1 text-left">{item.titulo}</span>
                <ChevronDown className={cn("h-4 w-4 transition-transform", expandido && "rotate-180")} />
              </>
            )}
          </div>
        </CollapsibleTrigger>
        {abierto && (
          <CollapsibleContent className="space-y-1 pl-6">
            {subItemsVisibles.map((subItem, index) => (
              <NavLink
                key={index}
                to={subItem.ruta!}
                className={({ isActive }) =>
                  cn(
                    "flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-muted-foreground transition-all hover:text-primary hover:bg-accent",
                    isActive && "bg-accent text-primary font-medium",
                  )
                }
              >
                {subItem.titulo}
              </NavLink>
            ))}
          </CollapsibleContent>
        )}
      </Collapsible>
    );
  }

  return (
    <NavLink
      to={item.ruta!}
      className={({ isActive }) =>
        cn(
          "flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-accent",
          isActive && "bg-accent text-primary font-medium",
          !abierto && "justify-center",
        )
      }
    >
      {item.icono}
      {abierto && <span>{item.titulo}</span>}
    </NavLink>
  );
}
```

**Eliminar `usePuedeVerItem`** — toda la lógica queda dentro de `ItemMenuSidebar` con la función `puedeVerItem` que no es un hook.

### Criterio de completitud — Tarea B
- [ ] `useAuth` importado en `Sidebar.tsx`
- [ ] La función `puedeVerItem` NO es un hook (no empieza con `use` al llamarse, es una función pura dentro del componente)
- [ ] Items con `soloAdmin: true` solo aparecen si `esAdmin === true`
- [ ] Items con `codigoPermiso` solo aparecen si el usuario tiene `CODIGO:VER` en sus permisos
- [ ] Items sin `codigoPermiso` ni `soloAdmin` siempre aparecen
- [ ] Si todos los subItems de un grupo están ocultos, el grupo padre también se oculta
- [ ] `npx tsc --noEmit` → 0 errores

### ⚠️ Trampas comunes — Tarea B
- **CRÍTICO: No llamar hooks dentro de callbacks o `.filter()`**. `useAuth` se llama UNA VEZ al inicio del componente. La función `puedeVerItem` recibe los valores como closure, no los obtiene llamando al hook.
- **No eliminar `CollapsibleContent`** ni el comportamiento de expansión/colapso existente.
- **No cambiar los imports de UI** (`Collapsible`, `NavLink`, `cn`).

---

## Tarea C — Frontend: `RutaProtegida` con permisos + página 403 (Agente 3)

**Tiempo estimado:** 20 minutos
**Puede ejecutarse en paralelo con A, B y D.**

### Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Frontend/src/compartido/componentes/seguridad/RutaProtegida.tsx` | MODIFICAR | Agregar soporte de `codigoPermiso` |
| `Codigo/Frontend/src/compartido/componentes/seguridad/PaginaNoAutorizado.tsx` | CREAR | Página de error 403 |
| `Codigo/Frontend/src/configuracion/rutas.tsx` | MODIFICAR | Envolver rutas sensibles con `codigoPermiso` |

---

### Especificación: `PaginaNoAutorizado.tsx` (CREAR)

Crear en `Codigo/Frontend/src/compartido/componentes/seguridad/PaginaNoAutorizado.tsx`:

```tsx
import { ShieldX } from "lucide-react";
import { Button } from "@/componentes/ui/button";
import { useNavigate } from "react-router-dom";

export function PaginaNoAutorizado() {
    const navigate = useNavigate();
    return (
        <div className="flex flex-col items-center justify-center h-[calc(100vh-8rem)] gap-6 text-center px-4">
            <ShieldX className="h-16 w-16 text-destructive opacity-80" />
            <div>
                <h1 className="text-3xl font-bold tracking-tight">Acceso Denegado</h1>
                <p className="text-muted-foreground mt-2 max-w-md">
                    No tienes permisos para ver esta sección. Contacta al administrador del sistema.
                </p>
            </div>
            <Button variant="outline" onClick={() => navigate("/dashboard")}>
                Volver al Dashboard
            </Button>
        </div>
    );
}
```

---

### Especificación: `RutaProtegida.tsx` (MODIFICAR)

Reemplazar el contenido completo del archivo:

```tsx
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/features/identidad/context/AuthContext';
import React from 'react';
import { PaginaNoAutorizado } from './PaginaNoAutorizado';

interface RutaProtegidaProps {
    children: React.ReactNode;
    rolesRequeridos?: string[];
    codigoPermiso?: string;
}

export const RutaProtegida = ({ children, rolesRequeridos, codigoPermiso }: RutaProtegidaProps) => {
    const { estaAutenticado, roles, permisos, cargando } = useAuth();
    const location = useLocation();

    if (cargando) {
        return (
            <div className="h-screen w-full flex items-center justify-center">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
        );
    }

    if (!estaAutenticado) {
        return <Navigate to="/login" state={{ from: location }} replace />;
    }

    const esAdmin = roles.some(r => r === "ADMINISTRADOR");

    if (rolesRequeridos && !esAdmin && !rolesRequeridos.some(r => roles.includes(r))) {
        return <PaginaNoAutorizado />;
    }

    if (codigoPermiso && !esAdmin) {
        const tienePermiso = permisos.includes(`${codigoPermiso}:VER`) ||
            permisos.some(p => p.startsWith(`${codigoPermiso}_`) && p.endsWith(":VER"));
        if (!tienePermiso) {
            return <PaginaNoAutorizado />;
        }
    }

    return <>{children}</>;
};
```

**Nota importante**: `RutaProtegida` ahora muestra `<PaginaNoAutorizado />` en lugar de redirigir al dashboard. Esto es mejor UX porque el usuario sabe por qué no puede acceder.

---

### Especificación: `rutas.tsx` (MODIFICAR)

Solo modificar las rutas de los módulos principales. Envolver cada `<Suspense>` sensible agregando `codigoPermiso` al `RutaProtegida` que ya envuelve el layout. 

**IMPORTANTE**: El `<RutaProtegida>` ya existe en el nivel del layout (`path: "/"`) — NO agregar uno por ruta. En cambio, crear componentes wrapper mínimos.

**Alternativa más limpia**: Crear un componente `RutaConPermiso` local en `rutas.tsx`:

Agregar DESPUÉS de la definición de `CargandoPagina` y ANTES de la definición de `ruteador`:

```tsx
const RutaConPermiso = ({ children, codigoPermiso }: { children: React.ReactNode; codigoPermiso: string }) => {
    const { roles, permisos, cargando } = useAuth();
    if (cargando) return <CargandoPagina />;
    const esAdmin = roles.some(r => r === "ADMINISTRADOR");
    if (esAdmin) return <>{children}</>;
    const tiene = permisos.includes(`${codigoPermiso}:VER`) ||
        permisos.some(p => p.startsWith(`${codigoPermiso}_`) && p.endsWith(":VER"));
    if (!tiene) return <PaginaNoAutorizado />;
    return <>{children}</>;
};
```

Agregar los imports necesarios al inicio de `rutas.tsx`:
```tsx
import { useAuth } from "@/features/identidad/context/AuthContext";
const PaginaNoAutorizado = lazy(() => import("@/compartido/componentes/seguridad/PaginaNoAutorizado").then(m => ({ default: m.PaginaNoAutorizado })));
```

Luego envolver las rutas de módulos sensibles. **Solo modificar estos grupos** (no tocar dashboard, perfil, configuracion-usuario):

```tsx
// Catálogo — envolver los 5 path de catalogo/*
{
  path: "catalogo/productos",
  element: (
    <Suspense fallback={<CargandoPagina />}>
      <RutaConPermiso codigoPermiso="CATALOGO">
        <PaginaProductos />
      </RutaConPermiso>
    </Suspense>
  ),
},
// ... mismo patrón para catalogo/categorias, catalogo/marcas, catalogo/unidades-medida, catalogo/listas-precios

// Ventas
{
  path: "ventas/lista",
  element: (
    <Suspense fallback={<CargandoPagina />}>
      <RutaConPermiso codigoPermiso="VENTAS">
        <PaginaVentas />
      </RutaConPermiso>
    </Suspense>
  ),
},
// ... mismo patrón para ventas/pos, ventas/cotizaciones, ventas/notas

// Clientes
{
  path: "clientes",
  element: (
    <Suspense fallback={<CargandoPagina />}>
      <RutaConPermiso codigoPermiso="CLIENTES">
        <PaginaClientes />
      </RutaConPermiso>
    </Suspense>
  ),
},

// Inventario — todos los path de inventario/*
// Compras — todos los path de compras/* y proveedores/*

// Configuracion
{
  path: "configuracion/empresa",
  element: (
    <Suspense fallback={<CargandoPagina />}>
      <RutaConPermiso codigoPermiso="CONFIGURACION">
        <PaginaEmpresa />
      </RutaConPermiso>
    </Suspense>
  ),
},
// ... mismo patrón para TODOS los path de configuracion/*

// Seguridad — usar RutaProtegida con rolesRequeridos
{
  path: "seguridad/usuarios",
  element: (
    <Suspense fallback={<CargandoPagina />}>
      <RutaProtegida rolesRequeridos={["ADMINISTRADOR"]}>
        <PaginaUsuarios />
      </RutaProtegida>
    </Suspense>
  ),
},
// ... mismo patrón para seguridad/roles y seguridad/trabajadores
```

**El patrón es**: envolver la página hija con `<RutaConPermiso codigoPermiso="CODIGO">`, mantener el `<Suspense>` por fuera.

### Criterio de completitud — Tarea C
- [ ] `PaginaNoAutorizado.tsx` existe con el componente exportado
- [ ] `RutaProtegida.tsx` acepta `codigoPermiso?` y muestra `<PaginaNoAutorizado />` si no tiene permiso
- [ ] `rutas.tsx` tiene `RutaConPermiso` aplicado a: catalogo/*, ventas/*, clientes, inventario/*, compras/*, proveedores/*, configuracion/*
- [ ] Las rutas de Seguridad usan `RutaProtegida` con `rolesRequeridos={["ADMINISTRADOR"]}`
- [ ] `npx tsc --noEmit` → 0 errores

### ⚠️ Trampas comunes — Tarea C
- **`RutaConPermiso` en `rutas.tsx` usa `useAuth`** — esto es un hook en un componente funcional, lo cual es válido. Pero Flash podría intentar usar el hook dentro de `createBrowserRouter` directamente (fuera de un componente), lo que no funciona. `RutaConPermiso` es un componente React que se renderiza dentro del árbol.
- **No eliminar el `<RutaProtegida>` del nivel del layout** (el que envuelve `LayoutPrincipal` en `path: "/"`). Ese sigue manejando la autenticación global.
- **El `<Suspense>` va FUERA de `RutaConPermiso`** para que el spinner aparezca mientras carga, y `RutaConPermiso` decide si mostrar la página o el error 403.
- **No duplicar rutas** — solo modificar las existentes, no agregar nuevas.
- **`PaginaNoAutorizado` se importa con `lazy`** para no romper el patrón de code splitting del archivo.

---

## Tarea D — Backend: Gateway completar mapeo de rutas (Agente 4)

**Tiempo estimado:** 10 minutos
**Puede ejecutarse en paralelo con A, B y C.**

### Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `Codigo/Backend/src/Gateway.API/Program.cs` | MODIFICAR | Completar el mapeo ruta → menuCodigo |

### Contexto

El bloque de mapeo de rutas a `menuCodigo` está en las líneas ~164-183 del middleware. Actualmente estas rutas NO están mapeadas a ningún módulo (cualquier usuario autenticado puede acceder sin check de permisos):
- `/api/ubigeo` → lookup geográfico, debe quedar SIN restricción (es de solo lectura, la usan todos)
- `/api/catalogos` → catálogos SUNAT, debe quedar SIN restricción (readonly)
- `/api/reglasdocumentos` → reglas de documentos SUNAT → `CONFIGURACION`
- `/api/operaciones-sunat` → ya en `CONFIGURACION` (verificar si ya está)
- `/api/reportes` → reportes hub → sin restricción (visible para todos autenticados)

### Especificación

**BUSCAR el bloque de mapeo de menuCodigo (líneas ~164-183):**
```csharp
    string? menuCodigo = null;
    if (pathLower.StartsWith("/api/ventas") || pathLower.StartsWith("/api/cotizaciones") || pathLower.StartsWith("/api/notas"))
        menuCodigo = "VENTAS";
    else if (pathLower.StartsWith("/api/compras") || pathLower.StartsWith("/api/proveedores") || pathLower.StartsWith("/api/ordenes-compra"))
        menuCodigo = "COMPRAS";
    else if (pathLower.StartsWith("/api/inventario"))
        menuCodigo = "INVENTARIO";
    else if (pathLower.StartsWith("/api/clientes"))
        menuCodigo = "CLIENTES";
    else if (pathLower.StartsWith("/api/productos") || pathLower.StartsWith("/api/categorias") || pathLower.StartsWith("/api/marcas") || pathLower.StartsWith("/api/unidades-medida") || pathLower.StartsWith("/api/listas-precios"))
        menuCodigo = "CATALOGO";
    else if (pathLower.StartsWith("/api/configuracion") || pathLower.StartsWith("/api/tablas-generales") || pathLower.StartsWith("/api/metodos-pago") || pathLower.StartsWith("/api/impuestos") || pathLower.StartsWith("/api/empresa") || pathLower.StartsWith("/api/sucursales") || pathLower.StartsWith("/api/series") || pathLower.StartsWith("/api/tipos-comprobante") || pathLower.StartsWith("/api/tipos-documento"))
        menuCodigo = "CONFIGURACION";
    else if (pathLower.StartsWith("/api/contabilidad"))
        menuCodigo = "CONTABILIDAD";
```

**REEMPLAZAR POR** (agregar los prefijos faltantes a sus grupos correspondientes):

```csharp
    string? menuCodigo = null;
    if (pathLower.StartsWith("/api/ventas") || pathLower.StartsWith("/api/cotizaciones") || pathLower.StartsWith("/api/notas"))
        menuCodigo = "VENTAS";
    else if (pathLower.StartsWith("/api/compras") || pathLower.StartsWith("/api/proveedores") || pathLower.StartsWith("/api/ordenes-compra"))
        menuCodigo = "COMPRAS";
    else if (pathLower.StartsWith("/api/inventario"))
        menuCodigo = "INVENTARIO";
    else if (pathLower.StartsWith("/api/clientes"))
        menuCodigo = "CLIENTES";
    else if (pathLower.StartsWith("/api/productos") || pathLower.StartsWith("/api/categorias") || pathLower.StartsWith("/api/marcas") || pathLower.StartsWith("/api/unidades-medida") || pathLower.StartsWith("/api/listas-precios"))
        menuCodigo = "CATALOGO";
    else if (pathLower.StartsWith("/api/configuracion") || pathLower.StartsWith("/api/tablas-generales") || pathLower.StartsWith("/api/metodos-pago") || pathLower.StartsWith("/api/impuestos") || pathLower.StartsWith("/api/empresa") || pathLower.StartsWith("/api/sucursales") || pathLower.StartsWith("/api/series") || pathLower.StartsWith("/api/tipos-comprobante") || pathLower.StartsWith("/api/tipos-documento") || pathLower.StartsWith("/api/reglasdocumentos") || pathLower.StartsWith("/api/operaciones-sunat"))
        menuCodigo = "CONFIGURACION";
    else if (pathLower.StartsWith("/api/contabilidad"))
        menuCodigo = "CONTABILIDAD";
    // /api/ubigeo, /api/catalogos, /api/reportes: sin menuCodigo → acceso libre para autenticados
```

Los cambios son:
1. Agregar `|| pathLower.StartsWith("/api/reglasdocumentos")` al grupo `CONFIGURACION`
2. Agregar `|| pathLower.StartsWith("/api/operaciones-sunat")` al grupo `CONFIGURACION` (si no existe ya)
3. Agregar comentario aclaratorio para las rutas sin restricción

### Criterio de completitud — Tarea D
- [ ] `/api/reglasdocumentos` mapeado a `CONFIGURACION`
- [ ] `/api/operaciones-sunat` mapeado a `CONFIGURACION`
- [ ] `/api/ubigeo` y `/api/catalogos` SIGUEN sin `menuCodigo` (no agregarlos)
- [ ] `dotnet build Gateway.API` → 0 errores
- [ ] No se modificó ninguna otra sección del archivo

### ⚠️ Trampas comunes — Tarea D
- **No agregar `/api/ubigeo` ni `/api/catalogos` a ningún grupo**: son lookups de solo lectura que todos los módulos necesitan (autocompletados de dirección, catálogos SUNAT). Agregarlos rompería formularios de compras, ventas, etc. para usuarios sin permiso de CONFIGURACION.
- **Solo modificar el bloque de `menuCodigo`**, no tocar `authRutaAdmin` ni ninguna otra sección.
- **Verificar si `/api/operaciones-sunat` ya está mapeado** antes de agregarlo — no duplicar.

---

## Dependencias entre Tareas

```
Tarea A ──┐
Tarea B ──┤→ Todas paralelas, sin dependencias entre sí
Tarea C ──┤
Tarea D ──┘
```

Las 4 tareas son completamente independientes. Los agentes de frontend (A, B, C) trabajan en archivos distintos.

**IMPORTANTE para los agentes de frontend**: Las Tareas A, B y C comparten la interfaz `ItemMenu`. Si ejecutan en paralelo, cada agente debe escribir sus cambios asumiendo que la interfaz extendida ya existe (como se especifica en Tarea A). Al integrar, no habrá conflictos porque cada tarea modifica un archivo diferente.

---

## Checklist de Revisión Final (Claude Code)

### Frontend
- [ ] `usePermiso.ts` existe en `src/compartido/hooks/` y exporta 3 funciones
- [ ] `menu.tsx` — todos los ítems padre tienen `codigoPermiso` o `soloAdmin`
- [ ] `Sidebar.tsx` — filtrado usando `puedeVerItem` sin violar reglas de hooks
- [ ] `RutaProtegida.tsx` — acepta `codigoPermiso?` y muestra `PaginaNoAutorizado`
- [ ] `PaginaNoAutorizado.tsx` existe y exporta el componente
- [ ] `rutas.tsx` — rutas sensibles envueltas con `RutaConPermiso`
- [ ] Rutas de seguridad envueltas con `RutaProtegida rolesRequeridos={["ADMINISTRADOR"]}`
- [ ] `npx tsc --noEmit` → 0 errores

### Backend
- [ ] `/api/reglasdocumentos` → mapeado a `"CONFIGURACION"`
- [ ] `/api/operaciones-sunat` → mapeado a `"CONFIGURACION"`
- [ ] `/api/ubigeo` → sin mapeo (pasa libre)
- [ ] `dotnet build Gateway.API` → 0 errores

### Funcional
- [ ] Usuario admin: ve TODOS los menús
- [ ] Usuario vendedor (solo VENTAS:VER): ve solo Ventas, Dashboard, Reportes
- [ ] Usuario sin permisos: navega directamente a `/catalogo/productos` → muestra `PaginaNoAutorizado`
- [ ] Sidebar oculta grupo entero si ningún subítem es visible

---

## Comandos de Verificación

```bash
# Frontend
cd "Codigo/Frontend"
npx tsc --noEmit

# Gateway
cd "Codigo/Backend/src/Gateway.API"
dotnet build

# Verificar que usePermiso existe
ls "Codigo/Frontend/src/compartido/hooks/usePermiso.ts"

# Verificar que PaginaNoAutorizado existe
ls "Codigo/Frontend/src/compartido/componentes/seguridad/PaginaNoAutorizado.tsx"

# Verificar mapeo reglasdocumentos en Gateway
grep -n "reglasdocumentos" "Codigo/Backend/src/Gateway.API/Program.cs"
# Debe retornar 1 línea

# Verificar que Sidebar importa useAuth
grep -n "useAuth" "Codigo/Frontend/src/layouts/LayoutPrincipal/Sidebar.tsx"
# Debe retornar al menos 1 línea

# Verificar que no se llamaron hooks dentro de filter
grep -n "useAuth\|usePermiso" "Codigo/Frontend/src/layouts/LayoutPrincipal/Sidebar.tsx"
# Debe aparecer solo en la línea del destructuring, no dentro de funciones/callbacks
```
