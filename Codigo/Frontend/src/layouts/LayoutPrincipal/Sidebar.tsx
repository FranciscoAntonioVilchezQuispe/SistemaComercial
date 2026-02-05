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

const menuItems: ItemMenu[] = [
  {
    titulo: "Dashboard",
    icono: <LayoutDashboard className="h-5 w-5" />,
    ruta: "/dashboard",
  },
  {
    titulo: "Catálogo",
    icono: <Package className="h-5 w-5" />,
    subItems: [
      { titulo: "Productos", icono: null, ruta: "/catalogo/productos" },
      { titulo: "Categorías", icono: null, ruta: "/catalogo/categorias" },
      { titulo: "Marcas", icono: null, ruta: "/catalogo/marcas" },
      {
        titulo: "Unidades de Medida",
        icono: null,
        ruta: "/catalogo/unidades-medida",
      },
      {
        titulo: "Listas de Precios",
        icono: null,
        ruta: "/catalogo/listas-precios",
      },
    ],
  },
  {
    titulo: "Ventas",
    icono: <ShoppingCart className="h-5 w-5" />,
    subItems: [
      { titulo: "POS", icono: null, ruta: "/ventas/pos" },
      { titulo: "Ventas", icono: null, ruta: "/ventas/lista" },
      { titulo: "Cotizaciones", icono: null, ruta: "/ventas/cotizaciones" },
      { titulo: "Clientes", icono: null, ruta: "/clientes" },
    ],
  },
  {
    titulo: "Inventario",
    icono: <Warehouse className="h-5 w-5" />,
    subItems: [
      { titulo: "Stock", icono: null, ruta: "/inventario/stock" },
      { titulo: "Movimientos", icono: null, ruta: "/inventario/movimientos" },
      { titulo: "Almacenes", icono: null, ruta: "/inventario/almacenes" },
    ],
  },
  {
    titulo: "Compras",
    icono: <ShoppingBag className="h-5 w-5" />,
    subItems: [
      { titulo: "Órdenes de Compra", icono: null, ruta: "/compras/ordenes-compra" },
      { titulo: "Compras", icono: null, ruta: "/compras/lista" },
      { titulo: "Proveedores", icono: null, ruta: "/compras/proveedores" },
    ],
  },
  {
    titulo: "Reportes",
    icono: <FileText className="h-5 w-5" />,
    ruta: "/reportes",
  },
  {
    titulo: "Configuración",
    icono: <Settings className="h-5 w-5" />,
    subItems: [
      { titulo: "Usuarios", icono: null, ruta: "/configuracion/usuarios" },
      { titulo: "Roles", icono: null, ruta: "/configuracion/roles" },
      { titulo: "Empresa", icono: null, ruta: "/configuracion/empresa" },
      {
        titulo: "Tablas Generales",
        icono: null,
        ruta: "/configuracion/tablas-generales",
      },
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

export function Sidebar({ abierto, onMouseEnter, onMouseLeave }: PropiedadesSidebar) {
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
