import { useState } from "react";
import { Plus, Edit2, Trash2, Link, CheckCircle, XCircle } from "lucide-react";
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
import { toast } from "sonner";
import { ReglaDocumento } from "@configuracion/services/reglasDocumentoService";
import {
  useReglasDocumentosCRUD,
  useGuardarRegla,
  useEliminarRegla,
  useActualizarRelaciones,
  useConfiguracionReglas,
} from "@configuracion/hooks/useReglasDocumentosCRUD";

import { useTiposComprobante } from "../hooks/useTiposComprobante";
import { ReglaDocumentoForm } from "../componentes/ReglaDocumentoForm";
import { Checkbox } from "@/components/ui/checkbox";
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
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaReglasDocumento() {
  const [dialogoReglaOpen, setDialogoReglaOpen] = useState(false);
  const [reglaSeleccionada, setReglaSeleccionada] =
    useState<ReglaDocumento | null>(null);

  const [dialogoRelacionesOpen, setDialogoRelacionesOpen] = useState(false);
  const [docParaRelacion, setDocParaRelacion] = useState<string | null>(null);
  const [relacionesTemporales, setRelacionesTemporales] = useState<number[]>(
    [],
  );

  // Hooks
  const { data: reglas, isLoading, error } = useReglasDocumentosCRUD();
  const { data: config } = useConfiguracionReglas();
  const { data: tiposComprobante } = useTiposComprobante();
  const guardarRegla = useGuardarRegla();
  const eliminarRegla = useEliminarRegla();
  const actualizarRelaciones = useActualizarRelaciones();
  const [eliminarId, setEliminarId] = useState<number | null>(null);

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

  const handleGuardarRegla = (datos: any) => {
    guardarRegla.mutate(datos, {
      onSuccess: () => {
        toast.success("Regla guardada correctamente");
        setDialogoReglaOpen(false);
      },
      onError: (e: any) =>
        toast.error(
          "Error: " +
            (e.response?.data?.message || e.message || "Error desconocido"),
        ),
    });
  };

  const handleOpenRelaciones = (regla: ReglaDocumento) => {
    setDocParaRelacion(regla.codigo);
    // Cargar relaciones actuales
    const actuales =
      config?.relaciones
        .filter((r) => r.codigoDocumento === regla.codigo)
        .map((r) => r.idTipoComprobante) || [];
    setRelacionesTemporales(actuales);
    setDialogoRelacionesOpen(true);
  };

  const toggleRelacion = (idTipo: number) => {
    setRelacionesTemporales((prev) =>
      prev.includes(idTipo)
        ? prev.filter((id) => id !== idTipo)
        : [...prev, idTipo],
    );
  };

  const handleGuardarRelaciones = () => {
    if (!docParaRelacion) return;
    actualizarRelaciones.mutate(
      {
        codigoDocumento: docParaRelacion,
        idsTiposComprobante: relacionesTemporales,
      },
      {
        onSuccess: () => {
          toast.success("Relaciones actualizadas");
          setDialogoRelacionesOpen(false);
        },
        onError: () => toast.error("Error al actualizar relaciones"),
      },
    );
  };

  const columnas: any[] = [
    {
      header: "Código SUNAT",
      accessorKey: "codigo",
      cell: (row: ReglaDocumento) => (
        <span className="font-mono font-bold bg-muted/50 text-muted-foreground border border-muted/20 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre",
      accessorKey: "nombre",
      className: "font-semibold text-primary",
    },
    {
      header: "Longitud",
      accessorKey: "longitud",
      className: "text-muted-foreground font-mono text-center",
    },
    {
      header: "Tipo",
      accessorKey: "esNumerico",
      cell: (row: ReglaDocumento) => (
        <span className="text-xs">{row.esNumerico ? "Numérico" : "Alfanumérico"}</span>
      ),
    },
    {
      header: "Estado",
      accessorKey: "activado",
      cell: (row: ReglaDocumento) => (
        row.activado ? (
          <Badge variant="default" className="gap-1 bg-green-500/10 text-green-600 border-green-200 hover:bg-green-500/20 shadow-none text-[11px] h-5">
            <CheckCircle className="h-3 w-3" /> Activo
          </Badge>
        ) : (
          <Badge variant="secondary" className="gap-1 bg-muted/50 text-muted-foreground shadow-none text-[11px] h-5">
            <XCircle className="h-3 w-3" /> Inactivo
          </Badge>
        )
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: ReglaDocumento) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            title="Gestionar Comprobantes Permitidos"
            onClick={() => handleOpenRelaciones(row)}
            className="h-8 w-8 p-0"
          >
            <Link className="h-4 w-4 text-primary" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => {
              setReglaSeleccionada(row);
              setDialogoReglaOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="text-destructive h-8 w-8 p-0 hover:text-destructive hover:bg-destructive/10"
            onClick={() => setEliminarId(row.id ?? null)}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  if (isLoading) return <Loading mensaje="Cargando reglas de SUNAT..." />;
  if (error)
    return <MensajeError mensaje="Error al cargar las reglas de documentos" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4 flex flex-row items-center justify-between space-y-0">
          <div className="space-y-1">
            <CardTitle className="text-lg">Tipos de Documento (Identidad)</CardTitle>
            <CardDescription>
              Mantenimiento de documentos de identidad permitidos (DNI, RUC, etc.).
            </CardDescription>
          </div>
          <Button
            size="sm"
            onClick={() => {
              setReglaSeleccionada(null);
              setDialogoReglaOpen(true);
            }}
          >
            <Plus className="mr-2 h-4 w-4" /> Nuevo Tipo
          </Button>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable data={(reglas || []) as any[]} columns={columnas} />
        </CardContent>
      </Card>

      {/* Diálogo de Edición de Regla */}
      <Dialog open={dialogoReglaOpen} onOpenChange={setDialogoReglaOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {reglaSeleccionada ? "Editar Regla" : "Nueva Regla de Documento"}
            </DialogTitle>
          </DialogHeader>
          <ReglaDocumentoForm
            datosIniciales={reglaSeleccionada || undefined}
            alEnviar={handleGuardarRegla}
            alCancelar={() => setDialogoReglaOpen(false)}
            cargando={guardarRegla.isPending}
          />
        </DialogContent>
      </Dialog>

      {/* Diálogo de Gestión de Relaciones */}
      <Dialog
        open={dialogoRelacionesOpen}
        onOpenChange={setDialogoRelacionesOpen}
      >
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Comprobantes Permitidos</DialogTitle>
            <CardDescription>
              Seleccione los comprobantes que se pueden emitir/recibir con el
              documento: <b className="text-primary">{docParaRelacion}</b>
            </CardDescription>
          </DialogHeader>

          <div className="space-y-4 py-4">
            <div className="grid grid-cols-1 gap-1 border border-muted/20 rounded-lg p-2 max-h-[300px] overflow-y-auto bg-muted/5">
              {tiposComprobante?.map((tipo) => (
                <div
                  key={tipo.id}
                  className="flex items-center space-x-3 p-2 hover:bg-muted/20 rounded-md transition-colors cursor-pointer"
                  onClick={() => toggleRelacion(tipo.id)}
                >
                  <Checkbox
                    id={`tipo-${tipo.id}`}
                    checked={relacionesTemporales.includes(tipo.id)}
                    onCheckedChange={() => toggleRelacion(tipo.id)}
                  />
                  <label
                    htmlFor={`tipo-${tipo.id}`}
                    className="text-sm font-medium leading-none cursor-pointer flex-1"
                  >
                    <span className="font-mono text-[11px] text-muted-foreground mr-2">{tipo.codigo}</span>
                    {tipo.nombre}
                  </label>
                </div>
              ))}
            </div>
          </div>

          <div className="flex justify-end gap-2 pt-4 border-t">
            <Button
              variant="outline"
              size="sm"
              onClick={() => setDialogoRelacionesOpen(false)}
            >
              Cancelar
            </Button>
            <Button
              size="sm"
              onClick={handleGuardarRelaciones}
              disabled={actualizarRelaciones.isPending}
            >
              {actualizarRelaciones.isPending
                ? "Guardando..."
                : "Actualizar Relaciones"}
            </Button>
          </div>
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
              Esta acción no se puede deshacer. La regla de documento será
              eliminada.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarRegla.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Regla eliminada");
                      setEliminarId(null);
                    },
                    onError: (e: any) => {
                      toast.error(
                        "Error: " +
                          (e.response?.data?.message || e.message || "Error desconocido"),
                      );
                    },
                  });
                }
              }}
            >
              {eliminarRegla.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
