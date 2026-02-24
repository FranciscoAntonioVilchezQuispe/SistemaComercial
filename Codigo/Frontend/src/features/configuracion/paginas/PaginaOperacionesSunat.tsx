import { useState } from "react";
import { Plus, Edit2, Trash2, CheckCircle, XCircle } from "lucide-react";
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
import { DataTable } from "@/components/ui/DataTable";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { toast } from "sonner";
import {
  useTiposOperacion,
  useCrearTipoOperacion,
  useActualizarTipoOperacion,
  useEliminarTipoOperacion,
} from "../hooks/useTiposOperacion";
import {
  TipoOperacionSunat,
  TipoOperacionSunatFormData,
} from "../tipos/tipoOperacion.types";

function FormularioOperacion({
  datosIniciales,
  alEnviar,
  alCancelar,
  cargando,
}: {
  datosIniciales?: TipoOperacionSunat;
  alEnviar: (datos: TipoOperacionSunatFormData) => void;
  alCancelar: () => void;
  cargando: boolean;
}) {
  const [form, setForm] = useState<TipoOperacionSunatFormData>({
    codigo: datosIniciales?.codigo ?? "",
    nombre: datosIniciales?.nombre ?? "",
    activo: datosIniciales?.activo ?? true,
  });

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-3 gap-4">
        <div className="space-y-1">
          <Label htmlFor="codigo">Código SUNAT</Label>
          <Input
            id="codigo"
            value={form.codigo}
            maxLength={2}
            onChange={(e) =>
              setForm((p) => ({ ...p, codigo: e.target.value.toUpperCase() }))
            }
            placeholder="ej. 01"
            className="font-mono"
          />
        </div>
        <div className="col-span-2 space-y-1">
          <Label htmlFor="nombre">Nombre</Label>
          <Input
            id="nombre"
            value={form.nombre}
            onChange={(e) => setForm((p) => ({ ...p, nombre: e.target.value }))}
            placeholder="ej. Venta Interna"
          />
        </div>
      </div>
      <div className="flex items-center gap-3">
        <Switch
          id="activo"
          checked={form.activo}
          onCheckedChange={(v) => setForm((p) => ({ ...p, activo: v }))}
        />
        <Label htmlFor="activo">Activo</Label>
      </div>
      <div className="flex justify-end gap-2 pt-2">
        <Button variant="outline" onClick={alCancelar}>
          Cancelar
        </Button>
        <Button disabled={cargando} onClick={() => alEnviar(form)}>
          {cargando ? "Guardando..." : "Guardar"}
        </Button>
      </div>
    </div>
  );
}

export function PaginaOperacionesSunat() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [seleccionado, setSeleccionado] = useState<TipoOperacionSunat | null>(
    null,
  );
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: operaciones, isLoading, error } = useTiposOperacion();
  const crear = useCrearTipoOperacion();
  const actualizar = useActualizarTipoOperacion();
  const eliminar = useEliminarTipoOperacion();

  const handleGuardar = (datos: TipoOperacionSunatFormData) => {
    if (seleccionado) {
      actualizar.mutate(
        { id: seleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Operación actualizada");
            setDialogoOpen(false);
          },
          onError: (e) => toast.error("Error: " + e.message),
        },
      );
    } else {
      crear.mutate(datos, {
        onSuccess: () => {
          toast.success("Operación creada");
          setDialogoOpen(false);
        },
        onError: (e) => toast.error("Error: " + e.message),
      });
    }
  };

  const columnas = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof TipoOperacionSunat,
      cell: (row: TipoOperacionSunat) => (
        <span className="font-mono font-bold bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded text-sm">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre de la Operación",
      accessorKey: "nombre" as keyof TipoOperacionSunat,
      className: "font-medium",
    },
    {
      header: "Estado",
      accessorKey: "activo" as keyof TipoOperacionSunat,
      cell: (row: TipoOperacionSunat) =>
        row.activo ? (
          <Badge variant="default" className="gap-1">
            <CheckCircle className="h-3 w-3" /> Activo
          </Badge>
        ) : (
          <Badge variant="secondary" className="gap-1">
            <XCircle className="h-3 w-3" /> Inactivo
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TipoOperacionSunat) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setSeleccionado(row);
              setDialogoOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => setEliminarId(row.id)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando operaciones SUNAT..." />;
  if (error) return <MensajeError mensaje="Error al cargar las operaciones" />;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Operaciones SUNAT</h1>
        <p className="text-muted-foreground mt-1">
          Catálogo de tipos de operación que define el contexto de cada
          comprobante (ej. Venta Interna, Exportación).
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Catálogo de Operaciones</CardTitle>
          <CardDescription>
            Cada operación tiene un código de 2 dígitos definido por SUNAT
            (Tabla 12).
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            data={operaciones || []}
            columns={columnas}
            actionElement={
              <Button
                onClick={() => {
                  setSeleccionado(null);
                  setDialogoOpen(true);
                }}
              >
                <Plus className="mr-2 h-4 w-4" /> Nueva Operación
              </Button>
            }
          />
        </CardContent>
      </Card>

      {/* Diálogo */}
      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {seleccionado ? "Editar Operación" : "Nueva Operación SUNAT"}
            </DialogTitle>
          </DialogHeader>
          <FormularioOperacion
            datosIniciales={seleccionado || undefined}
            alEnviar={handleGuardar}
            alCancelar={() => setDialogoOpen(false)}
            cargando={crear.isPending || actualizar.isPending}
          />
        </DialogContent>
      </Dialog>

      {/* Confirmación de eliminación */}
      <AlertDialog
        open={eliminarId !== null}
        onOpenChange={(open) => !open && setEliminarId(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Eliminar esta operación?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción eliminará la operación SUNAT. Verifique que no esté
              usada en la Matriz de Reglas antes de continuar.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminar.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Operación eliminada");
                      setEliminarId(null);
                    },
                    onError: (e: any) => {
                      toast.error("Error: " + e.message);
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
