import { useState } from "react";
import { Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { menuService } from "../servicios/servicioMenu";
import type { Menu } from "@/types/permisos.types";
import { MenuTree } from "../components/menus/MenuTree";
import { MenuForm } from "../components/menus/MenuForm";
import { toast } from "sonner";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";

export function PaginaMenus() {
  const queryClient = useQueryClient();
  const [showForm, setShowForm] = useState(false);
  const [menuSeleccionado, setMenuSeleccionado] = useState<Menu | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: menus, isLoading, error } = useQuery<Menu[], any>({
    queryKey: ["menusJerarquicos"],
    queryFn: () => menuService.obtenerMenusJerarquicos(),
  });

  const eliminarMutation = useMutation({
    mutationFn: (id: number) => menuService.eliminarMenu(id),
    onSuccess: () => {
      toast.success("Menú eliminado exitosamente");
      queryClient.invalidateQueries({ queryKey: ["menusJerarquicos"] });
    },
    onError: (e: any) => {
      console.error("Error al eliminar menú:", e);
      toast.error("Error al eliminar el menú");
    },
  });

  const handleNuevoMenu = () => {
    setMenuSeleccionado(null);
    setShowForm(true);
  };

  const handleEditarMenu = (menu: Menu) => {
    setMenuSeleccionado(menu);
    setShowForm(true);
  };

  const handleEliminarMenu = async (id: number) => {
    setEliminarId(id);
  };

  const handleGuardarMenu = async () => {
    setShowForm(false);
    setMenuSeleccionado(null);
    toast.success(
      menuSeleccionado ? "Menú actualizado exitosamente" : "Menú creado exitosamente",
    );
    queryClient.invalidateQueries({ queryKey: ["menusJerarquicos"] });
  };

  const handleCancelar = () => {
    setShowForm(false);
    setMenuSeleccionado(null);
  };

  return (
    <div className="container mx-auto py-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Gestión de Menús</h1>
          <p className="text-muted-foreground mt-1">
            Administra los menús del sistema y su estructura jerárquica
          </p>
        </div>
        <Button onClick={handleNuevoMenu}>
          <Plus className="mr-2 h-4 w-4" />
          Nuevo Menú
        </Button>
      </div>

      {/* Contenido */}
      {isLoading ? (
        <Loading mensaje="Cargando menús..." />
      ) : error ? (
        <MensajeError mensaje="Error al cargar menús" />
      ) : showForm ? (
        <MenuForm
          menu={menuSeleccionado}
          menusDisponibles={menus || []}
          onGuardar={handleGuardarMenu}
          onCancelar={handleCancelar}
        />
      ) : (
        <MenuTree
          menus={menus || []}
          onEditar={handleEditarMenu}
          onEliminar={handleEliminarMenu}
        />
      )}

      <AlertDialog open={eliminarId !== null} onOpenChange={(open) => !open && setEliminarId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción eliminará el menú seleccionado. No se puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarMutation.mutate(eliminarId);
                }
                setEliminarId(null);
              }}
            >
              Sí, eliminar
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
