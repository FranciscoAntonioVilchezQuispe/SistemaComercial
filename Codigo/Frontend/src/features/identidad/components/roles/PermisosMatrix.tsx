import { useState, useEffect } from "react";
import { Card } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import { Button } from "@/components/ui/button";
import { Plus, Trash2 } from "lucide-react";
import { menuService } from "../../servicios/servicioMenu";
import { rolMenuService } from "../../servicios/servicioRolMenu";
import type { Menu, RolMenu, TipoPermiso } from "@/types/permisos.types";
import { toast } from "sonner";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

interface Rol {
  id: number;
  nombreRol: string;
}

interface PermisosMatrixProps {
  rol: Rol;
  rolesMenus: RolMenu[];
  tiposPermiso: TipoPermiso[];
  onActualizar: () => void;
}

interface MenuConPermisos {
  menu: Menu;
  rolMenu: RolMenu | null;
  permisosActivos: Set<number>;
}

export function PermisosMatrix({
  rol,
  rolesMenus,
  tiposPermiso,
  onActualizar,
}: PermisosMatrixProps) {
  const [menusDisponibles, setMenusDisponibles] = useState<Menu[]>([]);
  const [menusConPermisos, setMenusConPermisos] = useState<MenuConPermisos[]>(
    [],
  );
  const [loading, setLoading] = useState(true);
  const [showAgregarMenu, setShowAgregarMenu] = useState(false);

  useEffect(() => {
    cargarMenus();
  }, []);

  useEffect(() => {
    procesarMenusConPermisos();
  }, [menusDisponibles, rolesMenus]);

  const cargarMenus = async () => {
    try {
      const menus = await menuService.obtenerMenus();
      setMenusDisponibles(menus);
    } catch (error) {
      console.error("Error al cargar menús:", error);
      toast.error("Error al cargar los menús");
    } finally {
      setLoading(false);
    }
  };

  const procesarMenusConPermisos = () => {
    const menusAsignados = rolesMenus
      .map((rm) => {
        const menu = menusDisponibles.find((m) => m.id === rm.idMenu);
        if (!menu) return null;

        const permisosActivos = new Set<number>(
          rm.permisos?.map((p) => p.idTipoPermiso) || [],
        );

        return {
          menu,
          rolMenu: rm,
          permisosActivos,
        };
      })
      .filter((m) => m !== null) as MenuConPermisos[];

    setMenusConPermisos(menusAsignados);
  };

  const handleAgregarMenu = async (idMenu: number) => {
    try {
      await rolMenuService.asignarMenuARol({ idRol: rol.id, idMenu });
      toast.success("Menú asignado al rol");
      onActualizar();
      setShowAgregarMenu(false);
    } catch (error) {
      console.error("Error al asignar menú:", error);
      toast.error("Error al asignar el menú");
    }
  };

  const handleQuitarMenu = async (idRolMenu: number) => {
    if (!confirm("¿Está seguro de quitar este menú del rol?")) return;

    try {
      await rolMenuService.quitarMenuDeRol(rol.id, idRolMenu);
      toast.success("Menú quitado del rol");
      onActualizar();
    } catch (error) {
      console.error("Error al quitar menú:", error);
      toast.error("Error al quitar el menú");
    }
  };

  const handleTogglePermiso = async (
    menuConPermisos: MenuConPermisos,
    tipoPermiso: TipoPermiso,
  ) => {
    if (!menuConPermisos.rolMenu) return;

    const tienePermiso = menuConPermisos.permisosActivos.has(tipoPermiso.id);

    try {
      if (tienePermiso) {
        // Quitar permiso (necesitaría endpoint específico)
        toast.info("Funcionalidad de quitar permiso en desarrollo");
      } else {
        // Agregar permiso
        await rolMenuService.asignarPermisoARolMenu(
          rol.id,
          menuConPermisos.menu.id,
          { idTipoPermiso: tipoPermiso.id },
        );
        toast.success(`Permiso ${tipoPermiso.nombre} asignado`);
        onActualizar();
      }
    } catch (error) {
      console.error("Error al cambiar permiso:", error);
      toast.error("Error al cambiar el permiso");
    }
  };

  const menusNoAsignados = menusDisponibles.filter(
    (menu) => !rolesMenus.some((rm) => rm.idMenu === menu.id),
  );

  if (loading) {
    return (
      <Card className="p-12 text-center">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto"></div>
      </Card>
    );
  }

  return (
    <Card className="p-6">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h3 className="text-xl font-semibold">
            Permisos del Rol: {rol.nombreRol}
          </h3>
          <p className="text-sm text-muted-foreground">
            Gestiona los menús y permisos asignados a este rol
          </p>
        </div>

        <Dialog open={showAgregarMenu} onOpenChange={setShowAgregarMenu}>
          <DialogTrigger asChild>
            <Button>
              <Plus className="mr-2 h-4 w-4" />
              Agregar Menú
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Agregar Menú al Rol</DialogTitle>
              <DialogDescription>
                Selecciona un menú para asignar al rol {rol.nombreRol}
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-2 max-h-96 overflow-y-auto">
              {menusNoAsignados.length === 0 ? (
                <p className="text-center text-muted-foreground py-4">
                  Todos los menús ya están asignados
                </p>
              ) : (
                menusNoAsignados.map((menu) => (
                  <Button
                    key={menu.id}
                    variant="outline"
                    className="w-full justify-start"
                    onClick={() => handleAgregarMenu(menu.id)}
                  >
                    <div>
                      <div className="font-medium">{menu.nombre}</div>
                      <div className="text-xs text-muted-foreground">
                        {menu.codigo}
                      </div>
                    </div>
                  </Button>
                ))
              )}
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {menusConPermisos.length === 0 ? (
        <div className="text-center py-12">
          <p className="text-muted-foreground">
            No hay menús asignados a este rol
          </p>
          <p className="text-sm text-muted-foreground mt-2">
            Haz clic en "Agregar Menú" para comenzar
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {menusConPermisos.map((menuConPermisos) => (
            <Card key={menuConPermisos.menu.id} className="p-4">
              <div className="flex items-start justify-between mb-4">
                <div>
                  <h4 className="font-semibold">
                    {menuConPermisos.menu.nombre}
                  </h4>
                  <p className="text-sm text-muted-foreground">
                    {menuConPermisos.menu.codigo}
                  </p>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => handleQuitarMenu(menuConPermisos.rolMenu!.id)}
                >
                  <Trash2 className="h-4 w-4 text-destructive" />
                </Button>
              </div>

              <div className="flex flex-wrap gap-4">
                {tiposPermiso.map((tipo) => {
                  const tienePermiso = menuConPermisos.permisosActivos.has(
                    tipo.id,
                  );
                  return (
                    <div key={tipo.id} className="flex items-center space-x-2">
                      <Checkbox
                        id={`${menuConPermisos.menu.id}-${tipo.id}`}
                        checked={tienePermiso}
                        onCheckedChange={() =>
                          handleTogglePermiso(menuConPermisos, tipo)
                        }
                      />
                      <label
                        htmlFor={`${menuConPermisos.menu.id}-${tipo.id}`}
                        className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer"
                      >
                        {tipo.nombre}
                      </label>
                    </div>
                  );
                })}
              </div>
            </Card>
          ))}
        </div>
      )}
    </Card>
  );
}
