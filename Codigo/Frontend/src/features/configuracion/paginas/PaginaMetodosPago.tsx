import { useState } from "react";
import { Plus, Edit2, Trash2, Banknote, CreditCard } from "lucide-react";
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
  useMetodosPago,
  useCrearMetodoPago,
  useActualizarMetodoPago,
  useEliminarMetodoPago,
} from "../hooks/useMetodosPago";
import { MetodoPago, MetodoPagoFormData } from "../tipos/metodoPago.types";
import { MetodoPagoForm } from "../componentes/MetodoPagoForm";
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

export function PaginaMetodosPago() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [registroSeleccionado, setRegistroSeleccionado] =
    useState<MetodoPago | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: metodos, isLoading, error } = useMetodosPago();

  const crearMutation = useCrearMetodoPago();
  const actualizarMutation = useActualizarMetodoPago();
  const eliminarMutation = useEliminarMetodoPago();

  const handleCrear = () => {
    setRegistroSeleccionado(null);
    setDialogoOpen(true);
  };

  const handleEditar = (metodo: MetodoPago) => {
    setRegistroSeleccionado(metodo);
    setDialogoOpen(true);
  };

  // Eliminación ahora via AlertDialog: setEliminarId para abrir diálogo

  const handleGuardar = (datos: MetodoPagoFormData) => {
    if (registroSeleccionado) {
      actualizarMutation.mutate(
        { id: registroSeleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Método actualizado");
            setDialogoOpen(false);
          },
          onError: (err) => toast.error("Error al actualizar: " + err.message),
        },
      );
    } else {
      crearMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Método creado");
          setDialogoOpen(false);
        },
        onError: (err) => toast.error("Error al crear: " + err.message),
      });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando métodos de pago..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof MetodoPago,
      className: "font-mono font-medium",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof MetodoPago,
      className: "font-semibold",
    },
    {
      header: "Tipo",
      accessorKey: "esEfectivo" as keyof MetodoPago,
      cell: (row: MetodoPago) => (
        <div className="flex items-center gap-2">
          {row.esEfectivo ? (
            <div className="flex items-center text-green-600">
              <Banknote className="h-4 w-4 mr-1" /> Efectivo
            </div>
          ) : (
            <div className="flex items-center text-blue-600">
              <CreditCard className="h-4 w-4 mr-1" /> Otros
            </div>
          )}
        </div>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: MetodoPago) => (
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
        <h1 className="text-3xl font-bold">Métodos de Pago</h1>
        <p className="text-muted-foreground">
          Gestión de formas de cobro (Efectivo, Tarjeta, Transferencia, Yape,
          etc.).
        </p>
      </div>

      <DataTable
        data={metodos || []}
        columns={columns}
        actionElement={
          <Button onClick={handleCrear}>
            <Plus className="mr-2 h-4 w-4" /> Nuevo Método
          </Button>
        }
      />

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {registroSeleccionado ? "Editar Método" : "Nuevo Método de Pago"}
            </DialogTitle>
          </DialogHeader>
          <MetodoPagoForm
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
              Esta acción no se puede deshacer. Se eliminará el método de pago
              seleccionado.
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
                      toast.success("Método eliminado");
                      setEliminarId(null);
                    },
                    onError: () => toast.error("Error al eliminar método"),
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
