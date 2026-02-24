import { useState } from "react";
import { Plus, Edit2, Trash2, Percent } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { DataTable } from "@/components/ui/DataTable";
import { Badge } from "@/components/ui/badge";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  useImpuestos,
  useCrearImpuesto,
  useActualizarImpuesto,
  useEliminarImpuesto,
} from "../hooks/useImpuestos";
import { Impuesto, ImpuestoFormData } from "../tipos/impuesto.types";
import { ImpuestoForm } from "../componentes/ImpuestoForm";
import { toast } from "sonner";
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

export function PaginaImpuestos() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [registroSeleccionado, setRegistroSeleccionado] =
    useState<Impuesto | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: impuestos, isLoading, error } = useImpuestos();

  const crearMutation = useCrearImpuesto();
  const actualizarMutation = useActualizarImpuesto();
  const eliminarMutation = useEliminarImpuesto();

  const handleCrear = () => {
    setRegistroSeleccionado(null);
    setDialogoOpen(true);
  };

  const handleEditar = (impuesto: Impuesto) => {
    setRegistroSeleccionado(impuesto);
    setDialogoOpen(true);
  };

  // Eliminación via AlertDialog: usar setEliminarId para abrir diálogo

  const handleGuardar = (datos: ImpuestoFormData) => {
    if (registroSeleccionado) {
      actualizarMutation.mutate(
        { id: registroSeleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Impuesto actualizado");
            setDialogoOpen(false);
          },
          onError: (err) => toast.error("Error al actualizar: " + err.message),
        },
      );
    } else {
      crearMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Impuesto creado");
          setDialogoOpen(false);
        },
        onError: (err) => toast.error("Error al crear: " + err.message),
      });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando impuestos..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof Impuesto,
      className: "font-mono font-medium",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof Impuesto,
      className: "font-semibold",
    },
    {
      header: "Porcentaje",
      accessorKey: "porcentaje" as keyof Impuesto,
      cell: (row: Impuesto) => (
        <div className="flex items-center gap-1 font-mono">
          <Percent className="h-3 w-3 text-muted-foreground" />
          <span>{row.porcentaje.toFixed(2)}%</span>
        </div>
      ),
    },
    {
      header: "Es IGV",
      accessorKey: "esIgv" as keyof Impuesto,
      cell: (row: Impuesto) =>
        row.esIgv ? (
          <Badge variant="outline" className="border-blue-500 text-blue-500">
            IGV Principal
          </Badge>
        ) : null,
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Impuesto) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => handleEditar(row)}
            title="Editar"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => setEliminarId(row.id)}
            title="Eliminar"
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
        <h1 className="text-3xl font-bold">Impuestos y Tasas</h1>
        <p className="text-muted-foreground">
          Gestión de impuestos aplicables a ventas y compras (IGV, IVA, etc.).
        </p>
      </div>

      <DataTable
        data={impuestos || []}
        columns={columns}
        actionElement={
          <Button onClick={handleCrear}>
            <Plus className="mr-2 h-4 w-4" /> Nuevo Impuesto
          </Button>
        }
      />

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {registroSeleccionado ? "Editar Impuesto" : "Nuevo Impuesto"}
            </DialogTitle>
          </DialogHeader>
          <ImpuestoForm
            datosIniciales={registroSeleccionado || undefined}
            alEnviar={handleGuardar}
            alCancelar={() => setDialogoOpen(false)}
            cargando={crearMutation.isPending || actualizarMutation.isPending}
          />
        </DialogContent>
      </Dialog>

      <AlertDialog
        open={eliminarId !== null}
        onOpenChange={(open) => !open && setEliminarId(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción no se puede deshacer. El impuesto seleccionado será
              eliminado.
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
                      toast.success("Impuesto eliminado");
                      setEliminarId(null);
                    },
                    onError: () => toast.error("Error al eliminar impuesto"),
                  });
                }
              }}
            >
              {eliminarMutation.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
