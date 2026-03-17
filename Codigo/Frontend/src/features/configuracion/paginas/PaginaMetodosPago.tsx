import { useState } from "react";
import { Plus, Edit2, Trash2, Banknote, CreditCard, CheckCircle, XCircle } from "lucide-react";
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
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export function PaginaMetodosPago() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [registroSeleccionado, setRegistroSeleccionado] =
    useState<MetodoPago | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: metodos, isLoading, error } = useMetodosPago();

  const crearMutation = useCrearMetodoPago();
  const actualizarMutation = useActualizarMetodoPago();
  const eliminarMutation = useEliminarMetodoPago();

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
    { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
    { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
    { label: RUTAS_TITULOS["/configuracion/reglas-sunat"], to: "/configuracion/reglas-sunat" },
    { label: RUTAS_TITULOS["/configuracion/operaciones-sunat"], to: "/configuracion/operaciones-sunat" },
    { label: RUTAS_TITULOS["/configuracion/matriz-sunat"], to: "/configuracion/matriz-sunat" },
    { label: RUTAS_TITULOS["/configuracion/tablas-generales"], to: "/configuracion/tablas-generales" },
  ];

  const handleCrear = () => {
    setRegistroSeleccionado(null);
    setDialogoOpen(true);
  };

  const handleEditar = (metodo: MetodoPago) => {
    setRegistroSeleccionado(metodo);
    setDialogoOpen(true);
  };

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
      cell: (row: MetodoPago) => (
        <span className="font-mono font-bold bg-muted/50 text-muted-foreground border border-muted/20 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre del Método",
      accessorKey: "nombre" as keyof MetodoPago,
      className: "font-semibold text-primary",
    },
    {
      header: "Tipo",
      accessorKey: "esEfectivo" as keyof MetodoPago,
      cell: (row: MetodoPago) => (
        row.esEfectivo ? (
          <Badge variant="outline" className="gap-1 bg-green-500/10 text-green-600 border-green-200 hover:bg-green-500/20 shadow-none text-[11px] h-5">
            <Banknote className="h-3 w-3" /> Efectivo
          </Badge>
        ) : (
          <Badge variant="outline" className="gap-1 bg-blue-500/10 text-blue-600 border-blue-200 hover:bg-blue-500/20 shadow-none text-[11px] h-5">
            <CreditCard className="h-3 w-3" /> Digital / Otros
          </Badge>
        )
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: MetodoPago) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => handleEditar(row)}
            title="Editar"
            className="h-8 w-8 p-0"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="text-destructive h-8 w-8 p-0 hover:text-destructive hover:bg-destructive/10"
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
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4 flex flex-row items-center justify-between space-y-0">
          <div className="space-y-1">
            <CardTitle className="text-lg">Métodos de Pago</CardTitle>
            <CardDescription>
              Gestión de formas de cobro (Efectivo, Tarjeta, Transferencia, Yape, etc.).
            </CardDescription>
          </div>
          <Button onClick={handleCrear} size="sm">
            <Plus className="mr-2 h-4 w-4" /> Nuevo Método
          </Button>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable data={metodos || []} columns={columns} />
        </CardContent>
      </Card>

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
