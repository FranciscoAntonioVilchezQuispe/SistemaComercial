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
import { ListaPrecio } from "../tipos/catalogo.types";
import {
  useListasPrecios,
  useEliminarListaPrecio,
} from "../hooks/useListasPrecios";
import { ListaPrecioForm } from "../componentes/listas-precios/ListaPrecioForm";

export function PaginaListasPrecios() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [listaSeleccionada, setListaSeleccionada] =
    useState<ListaPrecio | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: listas, isLoading } = useListasPrecios();
  const eliminarMutation = useEliminarListaPrecio();

  const handleNuevo = () => {
    setListaSeleccionada(null);
    setDialogoOpen(true);
  };

  const handleEditar = (lista: ListaPrecio) => {
    setListaSeleccionada(lista);
    setDialogoOpen(true);
  };

  const handleEliminar = async (lista: ListaPrecio) => {
    setEliminarId(lista.id);
  };

  const columnas = [
    { header: "Código", accessorKey: "codigo" as keyof ListaPrecio },
    { header: "Nombre", accessorKey: "nombre" as keyof ListaPrecio },
    { header: "Descripción", accessorKey: "descripcion" as keyof ListaPrecio },
    {
      header: "Estado",
      accessorKey: "activo" as keyof ListaPrecio,
      cell: (row: ListaPrecio) => (
        <span className={row.activo ? "text-green-600" : "text-gray-400"}>
          {row.activo ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: ListaPrecio) => (
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
          <Plus className="mr-2 h-4 w-4" /> Nueva Lista
        </Button>
      </div>

      <DataTable
        data={listas?.datos || []}
        columns={columnas}
        isLoading={isLoading}
        searchPlaceholder="Buscar lista..."
      />

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {listaSeleccionada
                ? "Editar Lista de Precios"
                : "Nueva Lista de Precios"}
            </DialogTitle>
          </DialogHeader>
          <ListaPrecioForm
            lista={listaSeleccionada}
            onSuccess={() => {
              setDialogoOpen(false);
              toast.success(
                listaSeleccionada ? "Lista actualizada" : "Lista creada",
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
              Esta acción eliminará la lista de precios seleccionada y no se
              podrá deshacer.
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
                      toast.success("Lista eliminada");
                      setEliminarId(null);
                    },
                    onError: (e: any) => {
                      console.error("Error al eliminar lista:", e);
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


