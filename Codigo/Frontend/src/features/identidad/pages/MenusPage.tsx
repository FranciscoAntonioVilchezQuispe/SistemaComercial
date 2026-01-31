import { useState, useEffect } from "react";
import { Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { menuService } from "../servicios/servicioMenu";
import type { Menu } from "@/types/permisos.types";
import { MenuTree } from "../components/menus/MenuTree";
import { MenuForm } from "../components/menus/MenuForm";
import { toast } from "sonner";

export function MenusPage() {
  const [menus, setMenus] = useState<Menu[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [menuSeleccionado, setMenuSeleccionado] = useState<Menu | null>(null);

  const cargarMenus = async () => {
    try {
      setLoading(true);
      const data = await menuService.obtenerMenusJerarquicos();
      setMenus(data);
    } catch (error) {
      console.error("Error al cargar menús:", error);
      toast.error("Error al cargar los menús");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    cargarMenus();
  }, []);

  const handleNuevoMenu = () => {
    setMenuSeleccionado(null);
    setShowForm(true);
  };

  const handleEditarMenu = (menu: Menu) => {
    setMenuSeleccionado(menu);
    setShowForm(true);
  };

  const handleEliminarMenu = async (id: number) => {
    if (!confirm("¿Está seguro de eliminar este menú?")) return;

    try {
      await menuService.eliminarMenu(id);
      toast.success("Menú eliminado exitosamente");
      cargarMenus();
    } catch (error) {
      console.error("Error al eliminar menú:", error);
      toast.error("Error al eliminar el menú");
    }
  };

  const handleGuardarMenu = async () => {
    setShowForm(false);
    setMenuSeleccionado(null);
    toast.success(
      menuSeleccionado
        ? "Menú actualizado exitosamente"
        : "Menú creado exitosamente",
    );
    cargarMenus();
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
      {loading ? (
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
        </div>
      ) : showForm ? (
        <MenuForm
          menu={menuSeleccionado}
          menusDisponibles={menus}
          onGuardar={handleGuardarMenu}
          onCancelar={handleCancelar}
        />
      ) : (
        <MenuTree
          menus={menus}
          onEditar={handleEditarMenu}
          onEliminar={handleEliminarMenu}
        />
      )}
    </div>
  );
}
