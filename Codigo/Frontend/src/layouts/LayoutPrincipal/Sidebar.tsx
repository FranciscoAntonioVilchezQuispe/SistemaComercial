import { NavLink } from "react-router-dom";
import {
  LayoutDashboard,
  Package,
  ShoppingCart,
  Warehouse,
  ShoppingBag,
  FileText,
  Settings,
  ChevronDown,
} from "lucide-react";
import { cn } from "@/lib/utils";
import { useState } from "react";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from "@/components/ui/collapsible";

interface PropiedadesSidebar {
  abierto: boolean;
  onMouseEnter?: () => void;
  onMouseLeave?: () => void;
}

interface ItemMenu {
  titulo: string;
  icono: React.ReactNode;
  ruta?: string;
  subItems?: ItemMenu[];
}

import { RUTAS_TITULOS } from "@/config/rutasTitulos";

const menuItems: ItemMenu[] = [
  {
    titulo: RUTAS_TITULOS["/dashboard"],
    icono: <LayoutDashboard className="h-5 w-5" />,
    ruta: "/dashboard",
  },
  {
    titulo: "Catálogo",
    icono: <Package className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/catalogo/productos"], icono: null, ruta: "/catalogo/productos" },
      { titulo: RUTAS_TITULOS["/catalogo/categorias"], icono: null, ruta: "/catalogo/categorias" },
      { titulo: RUTAS_TITULOS["/catalogo/marcas"], icono: null, ruta: "/catalogo/marcas" },
      { titulo: RUTAS_TITULOS["/catalogo/unidades-medida"], icono: null, ruta: "/catalogo/unidades-medida" },
      { titulo: RUTAS_TITULOS["/catalogo/listas-precios"], icono: null, ruta: "/catalogo/listas-precios" },
    ],
  },
  {
    titulo: "Ventas",
    icono: <ShoppingCart className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/ventas/pos"], icono: null, ruta: "/ventas/pos" },
      { titulo: RUTAS_TITULOS["/ventas/lista"], icono: null, ruta: "/ventas/lista" },
      { titulo: RUTAS_TITULOS["/ventas/cotizaciones"], icono: null, ruta: "/ventas/cotizaciones" },
      { titulo: RUTAS_TITULOS["/clientes"], icono: null, ruta: "/clientes" },
    ],
  },
  {
    titulo: "Inventario",
    icono: <Warehouse className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/inventario/stock"], icono: null, ruta: "/inventario/stock" },
      { titulo: RUTAS_TITULOS["/inventario/movimientos"], icono: null, ruta: "/inventario/movimientos" },
      { titulo: RUTAS_TITULOS["/inventario/traslados"], icono: null, ruta: "/inventario/traslados" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/reporte"], icono: null, ruta: "/inventario/kardex/reporte" },
      { titulo: RUTAS_TITULOS["/inventario/kardex/periodos"], icono: null, ruta: "/inventario/kardex/periodos" },
      { titulo: RUTAS_TITULOS["/inventario/almacenes"], icono: null, ruta: "/inventario/almacenes" },
    ],
  },
  {
    titulo: "Compras",
    icono: <ShoppingBag className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/proveedores/ordenes"], icono: null, ruta: "/proveedores/ordenes" },
      { titulo: "Compras", icono: null, ruta: "/compras/lista" }, // TODO: Agregar a RUTAS_TITULOS si falta
      { titulo: RUTAS_TITULOS["/proveedores"], icono: null, ruta: "/proveedores" },
    ],
  },
  {
    titulo: RUTAS_TITULOS["/reportes"] || "Reportes",
    icono: <FileText className="h-5 w-5" />,
    ruta: "/reportes",
  },
  {
    titulo: "Configuración",
    icono: <Settings className="h-5 w-5" />,
    subItems: [
      { titulo: RUTAS_TITULOS["/configuracion/usuarios"], icono: null, ruta: "/configuracion/usuarios" },
      { titulo: RUTAS_TITULOS["/configuracion/roles"], icono: null, ruta: "/configuracion/roles" },
      { titulo: RUTAS_TITULOS["/configuracion/empresa"], icono: null, ruta: "/configuracion/empresa" },
      { titulo: RUTAS_TITULOS["/configuracion/sucursales"], icono: null, ruta: "/configuracion/sucursales" },
      { titulo: RUTAS_TITULOS["/configuracion/impuestos"], icono: null, ruta: "/configuracion/impuestos" },
      { titulo: RUTAS_TITULOS["/configuracion/metodos-pago"], icono: null, ruta: "/configuracion/metodos-pago" },
      { titulo: RUTAS_TITULOS["/configuracion/comprobantes"], icono: null, ruta: "/configuracion/comprobantes" },
      { titulo: RUTAS_TITULOS["/configuracion/reglas-sunat"], icono: null, ruta: "/configuracion/reglas-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/operaciones-sunat"], icono: null, ruta: "/configuracion/operaciones-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/matriz-sunat"], icono: null, ruta: "/configuracion/matriz-sunat" },
      { titulo: RUTAS_TITULOS["/configuracion/tablas-generales"], icono: null, ruta: "/configuracion/tablas-generales" },
    ],
  },
];

function ItemMenuSidebar({
  item,
  abierto,
}: {
  item: ItemMenu;
  abierto: boolean;
}) {
  const [expandido, setExpandido] = useState(false);

  // Item con subitems
  if (item.subItems) {
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
            {item.subItems.map((subItem, index) => (
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
