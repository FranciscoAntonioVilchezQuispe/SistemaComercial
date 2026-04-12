import { useState } from "react";
import { Plus, Edit2, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
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
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import { DataTable } from "@/components/ui/DataTable";
import { toast } from "sonner";
import { UnidadMedida } from "../tipos/catalogo.types";
import {
  useUnidadesMedida,
  useEliminarUnidadMedida,
} from "../hooks/useUnidadesMedida";
import { UnidadMedidaForm } from "../componentes/unidades-medida/UnidadMedidaForm";

export function PaginaUnidadesMedida() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [unidadSeleccionada, setUnidadSeleccionada] =
    useState<UnidadMedida | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: unidades, isLoading } = useUnidadesMedida();
  const eliminarMutation = useEliminarUnidadMedida();

  const handleNuevo = () => {
    setUnidadSeleccionada(null);
    setDialogoOpen(true);
  };

  const handleEditar = (unidad: UnidadMedida) => {
    setUnidadSeleccionada(unidad);
    setDialogoOpen(true);
  };

  const handleEliminar = async (unidad: UnidadMedida) => {
    setEliminarId(unidad.id);
  };

  const columnas = [
    { header: "Código", accessorKey: "codigo" as keyof UnidadMedida },
    { header: "Nombre", accessorKey: "nombre" as keyof UnidadMedida },
    { header: "Símbolo", accessorKey: "simbolo" as keyof UnidadMedida },
    {
      header: "Estado",
      accessorKey: "activo" as keyof UnidadMedida,
      cell: (row: UnidadMedida) => (
        <span className={row.activo ? "text-green-600" : "text-gray-400"}>
          {row.activo ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: UnidadMedida) => (
        <div className="flex justify-end gap-2">
          <Button variant="ghost" size="icon" onClick={() => handleEditar(row)}>
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminar(row)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  const tabsCatalogo = [
    { label: RUTAS_TITULOS["/catalogo/productos"], to: "/catalogo/productos" },
    { label: RUTAS_TITULOS["/catalogo/categorias"], to: "/catalogo/categorias" },
    { label: RUTAS_TITULOS["/catalogo/marcas"], to: "/catalogo/marcas" },
    { label: RUTAS_TITULOS["/catalogo/unidades-medida"], to: "/catalogo/unidades-medida" },
    { label: RUTAS_TITULOS["/catalogo/listas-precios"], to: "/catalogo/listas-precios" },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsCatalogo} />

      <div className="flex justify-end mb-2">
        <Button onClick={handleNuevo} size="sm">
          <Plus className="mr-2 h-4 w-4" /> Nueva Unidad
        </Button>
      </div>

      <DataTable
        data={unidades?.datos || []}
        columns={columnas}
        isLoading={isLoading}
        searchPlaceholder="Buscar unidad..."
      />

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {unidadSeleccionada ? "Editar Unidad" : "Nueva Unidad"}
            </DialogTitle>
          </DialogHeader>
          <UnidadMedidaForm
            unidad={unidadSeleccionada}
            onSuccess={() => {
              setDialogoOpen(false);
              toast.success(
                unidadSeleccionada ? "Unidad actualizada" : "Unidad creada",
              );
            }}
            onCancel={() => setDialogoOpen(false)}
          />
        </DialogContent>
      </Dialog>
      <AlertDialog open={eliminarId !== null} onOpenChange={(open) => !open && setEliminarId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción eliminará la unidad seleccionada. No se puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarMutation.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Unidad eliminada");
                      setEliminarId(null);
                    },
                    onError: (e: any) => {
                      console.error("Error al eliminar unidad:", e);
                      setEliminarId(null);
                    },
                  });
                }
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


