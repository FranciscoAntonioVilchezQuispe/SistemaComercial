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
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

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
    activado: datosIniciales?.activado ?? true,
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
            className="font-mono h-9"
          />
        </div>
        <div className="col-span-2 space-y-1">
          <Label htmlFor="nombre">Nombre</Label>
          <Input
            id="nombre"
            value={form.nombre}
            onChange={(e) => setForm((p) => ({ ...p, nombre: e.target.value }))}
            placeholder="ej. Venta Interna"
            className="h-9"
          />
        </div>
      </div>
      <div className="flex items-center gap-3 py-2">
        <Switch
          id="activado"
          checked={form.activado}
          onCheckedChange={(v) => setForm((p) => ({ ...p, activado: v }))}
        />
        <Label htmlFor="activado" className="text-sm font-medium cursor-pointer">Activo</Label>
      </div>
      <div className="flex justify-end gap-2 pt-4 border-t">
        <Button variant="outline" size="sm" onClick={alCancelar} className="px-4 h-9">
          Cancelar
        </Button>
        <Button disabled={cargando} size="sm" onClick={() => alEnviar(form)} className="px-6 h-9">
          {cargando ? "Guardando..." : "Guardar Operación"}
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
        <span className="font-mono font-bold bg-muted/50 text-muted-foreground border border-muted/20 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre de la Operación",
      accessorKey: "nombre" as keyof TipoOperacionSunat,
      className: "font-semibold text-primary",
    },
    {
      header: "Estado",
      accessorKey: "activado" as keyof TipoOperacionSunat,
      cell: (row: TipoOperacionSunat) =>
        row.activado ? (
          <Badge variant="default" className="gap-1 bg-green-500/10 text-green-600 border-green-200 hover:bg-green-500/20 shadow-none text-[11px] h-5">
            <CheckCircle className="h-3 w-3" /> Activo
          </Badge>
        ) : (
          <Badge variant="secondary" className="gap-1 bg-muted/50 text-muted-foreground shadow-none text-[11px] h-5">
            <XCircle className="h-3 w-3" /> Inactivo
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TipoOperacionSunat) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => {
              setSeleccionado(row);
              setDialogoOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="h-8 w-8 p-0 text-destructive hover:text-destructive hover:bg-destructive/10"
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
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4">
          <CardTitle className="text-lg">Catálogo de Operaciones</CardTitle>
          <CardDescription>
            Cada operación tiene un código de 2 dígitos definido por SUNAT
            (Tabla 12).
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable
            data={operaciones || []}
            columns={columnas}
            actionElement={
              <Button
                size="sm"
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
