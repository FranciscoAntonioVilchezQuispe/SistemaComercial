import { useState } from "react";
import { Plus, Edit2, Trash2, Store } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";

import { useAlmacenes, useEliminarAlmacen } from "../hooks/useAlmacenes";
import { Almacen } from "../types/almacen.types";
import { AlmacenForm } from "../componentes/AlmacenForm";

export default function PaginaAlmacenes() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [almacenSeleccionado, setAlmacenSeleccionado] =
    useState<Almacen | null>(null);
  const [filtro, setFiltro] = useState("");

  const { data: almacenes, isLoading, error } = useAlmacenes();
  const eliminarAlmacen = useEliminarAlmacen();
 
  const handleEliminar = (almacen: Almacen) => {
    if (
      confirm(`¿Estás seguro de eliminar el almacén ${almacen.nombreAlmacen}?`)
    ) {
      eliminarAlmacen.mutate(almacen.id, {
        onSuccess: () => toast.success("Almacén eliminado correctamente"),
        onError: () => toast.error("Error al eliminar el almacén"),
      });
    }
  };

  const almacenesFiltrados =
    almacenes?.filter((a) =>
      a.nombreAlmacen.toLowerCase().includes(filtro.toLowerCase()),
    ) || [];

  const columnas = [
    {
      header: "Nombre",
      accessorKey: "nombreAlmacen" as keyof Almacen,
      className: "font-semibold",
      cell: (row: Almacen) => (
        <div className="flex items-center gap-2">
          <Store className="h-4 w-4 text-muted-foreground" />
          <span>{row.nombreAlmacen}</span>
          {row.esPrincipal && (
            <Badge variant="default" className="ml-2 text-[10px] px-1 py-0 h-4">
              Principal
            </Badge>
          )}
        </div>
      ),
    },
    {
      header: "Dirección",
      accessorKey: "direccion" as keyof Almacen,
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof Almacen,
      cell: (row: Almacen) =>
        row.activado  === true ? (
          <Badge
            variant="outline"
            className="bg-green-50 text-green-700 border-green-200"
          >
            Activo
          </Badge>
        ) : (
          <Badge
            variant="outline"
            className="bg-red-50 text-red-700 border-red-200"
          >
            Inactivo
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Almacen) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setAlmacenSeleccionado(row);
              setDialogoOpen(true);
            }}
          >
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

  if (isLoading) return <Loading mensaje="Cargando almacenes..." />;
  if (error) return <MensajeError mensaje="Error al cargar almacenes" />;

  return (
    <div className="space-y-6">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
          <div>
            <CardTitle className="text-2xl font-bold">
              Gestión de Almacenes
            </CardTitle>
            <CardDescription>
              Administre las ubicaciones donde se gestiona el inventario.
            </CardDescription>
          </div>
          <Button
            onClick={() => {
              setAlmacenSeleccionado(null);
              setDialogoOpen(true);
            }}
            className="shadow-sm"
          >
            <Plus className="mr-2 h-4 w-4" /> Nuevo Almacén
          </Button>
        </CardHeader>
        <CardContent>
          <DataTable
            data={almacenesFiltrados}
            columns={columnas}
            onSearchChange={setFiltro}
            searchPlaceholder="Buscar por nombre..."
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>
              {almacenSeleccionado ? "Editar Almacén" : "Registrar Almacén"}
            </DialogTitle>
          </DialogHeader>
          <AlmacenForm
            almacen={almacenSeleccionado || undefined}
            onSuccess={() => {
              toast.success(
                almacenSeleccionado ? "Almacén actualizado" : "Almacén creado",
              );
              setDialogoOpen(false);
            }}
            onCancel={() => setDialogoOpen(false)}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
