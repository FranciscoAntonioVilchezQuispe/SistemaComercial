import { useState } from "react";
import {
  ChevronRight,
  ChevronDown,
  Edit,
  Trash2,
  FolderTree,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import type { Menu } from "@/types/permisos.types";
import { cn } from "@/lib/utils";

interface MenuTreeProps {
  menus: Menu[];
  onEditar: (menu: Menu) => void;
  onEliminar: (id: number) => void;
}

interface MenuItemProps {
  menu: Menu;
  nivel: number;
  onEditar: (menu: Menu) => void;
  onEliminar: (id: number) => void;
}

function MenuItem({ menu, nivel, onEditar, onEliminar }: MenuItemProps) {
  const [expandido, setExpandido] = useState(true);
  const tieneHijos = menu.subMenus && menu.subMenus.length > 0;

  return (
    <div className="space-y-1">
      <Card
        className={cn(
          "p-3 hover:bg-accent/50 transition-colors",
          nivel > 0 && "ml-6",
        )}
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 flex-1">
            {/* Botón expandir/contraer */}
            {tieneHijos ? (
              <Button
                variant="ghost"
                size="sm"
                className="h-6 w-6 p-0"
                onClick={() => setExpandido(!expandido)}
              >
                {expandido ? (
                  <ChevronDown className="h-4 w-4" />
                ) : (
                  <ChevronRight className="h-4 w-4" />
                )}
              </Button>
            ) : (
              <div className="w-6" />
            )}

            {/* Icono del menú */}
            <div className="flex items-center justify-center w-8 h-8 rounded bg-primary/10 text-primary">
              <FolderTree className="h-4 w-4" />
            </div>

            {/* Información del menú */}
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <span className="font-semibold">{menu.nombre}</span>
                <span className="text-xs text-muted-foreground bg-muted px-2 py-0.5 rounded">
                  {menu.codigo}
                </span>
              </div>
              {menu.descripcion && (
                <p className="text-sm text-muted-foreground">
                  {menu.descripcion}
                </p>
              )}
              {menu.ruta && (
                <p className="text-xs text-muted-foreground font-mono">
                  {menu.ruta}
                </p>
              )}
            </div>

            {/* Orden */}
            <div className="text-sm text-muted-foreground">
              Orden: {menu.orden}
            </div>
          </div>

          {/* Acciones */}
          <div className="flex items-center gap-1">
            <Button variant="ghost" size="sm" onClick={() => onEditar(menu)}>
              <Edit className="h-4 w-4" />
            </Button>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => onEliminar(menu.id)}
            >
              <Trash2 className="h-4 w-4 text-destructive" />
            </Button>
          </div>
        </div>
      </Card>

      {/* Submenús */}
      {tieneHijos && expandido && (
        <div className="space-y-1">
          {menu.subMenus!.map((submenu) => (
            <MenuItem
              key={submenu.id}
              menu={submenu}
              nivel={nivel + 1}
              onEditar={onEditar}
              onEliminar={onEliminar}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export function MenuTree({ menus, onEditar, onEliminar }: MenuTreeProps) {
  if (menus.length === 0) {
    return (
      <Card className="p-12 text-center">
        <FolderTree className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
        <h3 className="text-lg font-semibold mb-2">
          No hay menús configurados
        </h3>
        <p className="text-muted-foreground">
          Comienza creando tu primer menú del sistema
        </p>
      </Card>
    );
  }

  return (
    <div className="space-y-2">
      {menus.map((menu) => (
        <MenuItem
          key={menu.id}
          menu={menu}
          nivel={0}
          onEditar={onEditar}
          onEliminar={onEliminar}
        />
      ))}
    </div>
  );
}
