import { useState } from "react";
import { Plus, Edit2, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { toast } from "sonner";
import { ListaPrecio } from "../tipos/catalogo.types";
import { CatalogoHeader } from "../componentes/comunes/CatalogoHeader";
import {
  useListasPrecios,
  useEliminarListaPrecio,
} from "../hooks/useListasPrecios";
import { ListaPrecioForm } from "../componentes/listas-precios/ListaPrecioForm";

export function PaginaListasPrecios() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [listaSeleccionada, setListaSeleccionada] =
    useState<ListaPrecio | null>(null);

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
    if (confirm(`¿Está seguro de eliminar la lista "${lista.nombre}"?`)) {
      eliminarMutation.mutate(lista.id);
    }
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

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold flex items-center gap-2">
          Listas de Precios
        </h1>
        <p className="text-muted-foreground">
          Define diferentes niveles de precios para tus productos
        </p>
      </div>

      <CatalogoHeader />

      <DataTable
        data={listas?.datos || []}
        columns={columnas}
        isLoading={isLoading}
        searchPlaceholder="Buscar lista..."
        actionElement={
          <Button
            onClick={handleNuevo}
            className="bg-blue-600 hover:bg-blue-700 text-white rounded-full px-6"
          >
            <Plus className="mr-2 h-4 w-4" />
            Nuevo
          </Button>
        }
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
    </div>
  );
}

export default PaginaListasPrecios;
