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

function ItemMenuSidebar({
  item,
  abierto,
}: {
  item: ItemMenu;
  abierto: boolean;
}) {
  const { roles, permisos } = useAuth();
  const [expandido, setExpandido] = useState(false);

  const esAdmin = roles.includes("ADMINISTRADOR");

  // Función normal (no hook) como closure para validar visibilidad
  const puedeVerItem = (i: ItemMenu): boolean => {

    // 2. Solo Admin
    if (i.soloAdmin && !esAdmin) return false;

    // 3. Sin restricción de permiso
    if (!i.codigoPermiso) return true;

    // 4. Con código de permiso (verificar :VER o COMODIN_:VER)
    const codigo = i.codigoPermiso.toUpperCase();
    const tienePermisoExacto = permisos.includes(`${codigo}:VER`);
    const tienePermisoPatron = permisos.some(
      (p) => p.startsWith(`${codigo}_`) && p.endsWith(":VER")
    );

    return tienePermisoExacto || tienePermisoPatron;
  };

  // Validar el ítem actual
  if (!puedeVerItem(item)) return null;

  // Filtrar sub-ítems si existen
  const subItemsVisibles = item.subItems?.filter(puedeVerItem) || [];

  // Si tiene declarados sub-ítems pero ninguno es visible, ocultamos el padre también
  if (item.subItems && subItemsVisibles.length === 0) return null;

  // Item con subitems
  if (item.subItems) {
    return (
      <Collapsible open={expandido} onOpenChange={setExpandido}>
        <CollapsibleTrigger className="w-full">
          <div
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2 text-muted-foreground transition-all hover:text-primary hover:bg-accent",
              !abierto && "justify-center"
            )}
          >
            {item.icono}
            {abierto && (
              <>
                <span className="flex-1 text-left">{item.titulo}</span>
                <ChevronDown
                  className={cn(
                    "h-4 w-4 transition-transform",
                    expandido && "rotate-180"
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
                    isActive && "bg-accent text-primary font-medium"
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
          !abierto && "justify-center"
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
        abierto ? "w-64" : "w-16"
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
