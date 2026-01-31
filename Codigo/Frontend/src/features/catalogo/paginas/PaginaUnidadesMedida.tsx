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
import { UnidadMedida } from "../tipos/catalogo.types";
import { CatalogoHeader } from "../componentes/comunes/CatalogoHeader";
import {
  useUnidadesMedida,
  useEliminarUnidadMedida,
} from "../hooks/useUnidadesMedida";
import { UnidadMedidaForm } from "../componentes/unidades-medida/UnidadMedidaForm";

export function PaginaUnidadesMedida() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [unidadSeleccionada, setUnidadSeleccionada] =
    useState<UnidadMedida | null>(null);

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
    if (confirm(`¿Está seguro de eliminar la unidad "${unidad.nombre}"?`)) {
      eliminarMutation.mutate(unidad.id);
    }
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

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Unidades de Medida</h1>
        <p className="text-muted-foreground">
          Gestiona las unidades de medida para tus productos
        </p>
      </div>

      <CatalogoHeader />

      <DataTable
        data={unidades?.datos || []}
        columns={columnas}
        isLoading={isLoading}
        searchPlaceholder="Buscar unidad..."
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
    </div>
  );
}

export default PaginaUnidadesMedida;
