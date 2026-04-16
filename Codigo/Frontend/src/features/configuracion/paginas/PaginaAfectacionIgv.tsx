import { useState } from "react";
import { Plus, Edit2, Trash2, Database, ShieldCheck, Info } from "lucide-react";
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
  useAfectacionesIgv,
  useAfectacionIgv,
  useCrearAfectacionIgv,
  useActualizarAfectacionIgv,
  useEliminarAfectacionIgv,
  useInicializarAfectacionIgv,
} from "../hooks/useAfectacionIgv";
import { AfectacionIgv, AfectacionIgvFormData } from "../tipos/afectacionIgv.types";
import { AfectacionIgvForm } from "../componentes/AfectacionIgvForm";
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
import { usePagination } from "@/hooks/usePagination";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";

export function PaginaAfectacionIgv() {
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idRegistroAEditar, setIdRegistroAEditar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data, isLoading, error } = useAfectacionesIgv(paginacion);
  const afectaciones = data?.datos || [];
  const { data: registroDetalle, isLoading: cargandoDetalle } = useAfectacionIgv(idRegistroAEditar || 0);

  const trabajarMutation = useCrearAfectacionIgv();
  const actualizarMutation = useActualizarAfectacionIgv();
  const eliminarMutation = useEliminarAfectacionIgv();
  const inicializarMutation = useInicializarAfectacionIgv();

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
    { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
    { label: "Afectación IGV", to: "/configuracion/afectacion-igv" },
    { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
    { label: RUTAS_TITULOS["/configuracion/operaciones-sunat"], to: "/configuracion/operaciones-sunat" },
  ];

  const handleCrear = () => {
    setIdRegistroAEditar(null);
    setDialogoOpen(true);
  };

  const handleEditar = (id: number) => {
    setIdRegistroAEditar(id);
    setDialogoOpen(true);
  };

  const handleGuardar = (datos: AfectacionIgvFormData) => {
    if (idRegistroAEditar) {
      actualizarMutation.mutate(
        { id: idRegistroAEditar, datos },
        {
          onSuccess: () => {
            toast.success("Afectación actualizada");
            setDialogoOpen(false);
            setIdRegistroAEditar(null);
          },
          onError: (err) => toast.error("Error al actualizar: " + err.message),
        },
      );
    } else {
      trabajarMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Afectación creada");
          setDialogoOpen(false);
        },
        onError: (err) => toast.error("Error al crear: " + err.message),
      });
    }
  };

  const handleInicializar = () => {
    inicializarMutation.mutate(undefined, {
      onSuccess: () => toast.success("Catálogo inicializado con éxito"),
      onError: (err) => toast.error("Error al inicializar: " + err.message),
    });
  };

  if (isLoading) return <Loading mensaje="Cargando afectaciones..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Cód. SUNAT",
      accessorKey: "codigo" as keyof AfectacionIgv,
      cell: (row: AfectacionIgv) => (
        <span className="font-mono font-bold text-primary bg-primary/5 border border-primary/20 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Descripción",
      accessorKey: "descripcion" as keyof AfectacionIgv,
      className: "font-medium",
    },
    {
      header: "Clasificación",
      cell: (row: AfectacionIgv) => (
        <div className="flex gap-1 flex-wrap">
          {row.esGravado && <Badge variant="default" className="bg-green-500/10 text-green-700 border-green-200">Gravado</Badge>}
          {row.esExonerado && <Badge variant="secondary">Exonerado</Badge>}
          {row.esInafecto && <Badge variant="outline">Inafecto</Badge>}
          {row.esGratuito && <Badge className="bg-amber-500/10 text-amber-700 border-amber-200">Gratuito</Badge>}
        </div>
      ),
    },
    {
      header: "Tributo Defecto",
      cell: (row: AfectacionIgv) => (
        <div className="flex flex-col text-[10px] leading-tight text-muted-foreground">
          <span className="font-bold">{row.nombreTributoDefault}</span>
          <span className="font-mono">{row.codigoTributoDefault}</span>
        </div>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: AfectacionIgv) => (
        <div className="flex justify-end gap-1">
          <Button variant="ghost" size="sm" onClick={() => handleEditar(row.id)} title="Editar" className="h-8 w-8 p-0">
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button variant="ghost" size="sm" className="text-destructive h-8 w-8 p-0 hover:text-destructive hover:bg-destructive/10" onClick={() => setEliminarId(row.id)} title="Eliminar">
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      {afectaciones.length === 0 && (
        <Alert variant="default" className="bg-blue-50/50 border-blue-200">
          <Info className="h-4 w-4 text-blue-600" />
          <AlertTitle className="text-blue-700">Catálogo vacío</AlertTitle>
          <AlertDescription className="text-blue-600/80 flex flex-col gap-3">
            Parece que aún no tienes configurados los tipos de afectación de SUNAT.
            <Button onClick={handleInicializar} disabled={inicializarMutation.isPending} size="sm" className="w-fit bg-blue-600 hover:bg-blue-700">
               <Database className="mr-2 h-4 w-4" /> Cargar Catálogo Estándar (Recomendado)
            </Button>
          </AlertDescription>
        </Alert>
      )}

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4 flex flex-row items-center justify-between space-y-0">
          <div className="space-y-1">
            <CardTitle className="text-lg flex items-center gap-2">
              <ShieldCheck className="h-5 w-5 text-primary" />
              Tipos de Afectación IGV
            </CardTitle>
            <CardDescription>
              Catálogo No. 07 de SUNAT para determinar el comportamiento fiscal de los productos.
            </CardDescription>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" size="sm" onClick={handleInicializar} disabled={inicializarMutation.isPending}>
              {inicializarMutation.isPending ? "Cargando..." : "Sincronizar SUNAT"}
            </Button>
            <Button onClick={handleCrear} size="sm">
              <Plus className="mr-2 h-4 w-4" /> Nuevo Código
            </Button>
          </div>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable 
            data={afectaciones} 
            columns={columns} 
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            isLoading={isLoading}
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>
              {idRegistroAEditar ? "Editar Afectación" : "Nueva Afectación SUNAT"}
            </DialogTitle>
          </DialogHeader>

          {idRegistroAEditar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center font-medium text-muted-foreground animate-pulse">
              Cargando detalle...
            </div>
          ) : (
            <AfectacionIgvForm
              key={idRegistroAEditar || "nuevo"}
              datosIniciales={registroDetalle || undefined}
              alEnviar={handleGuardar}
              alCancelar={() => {
                setDialogoOpen(false);
                setIdRegistroAEditar(null);
              }}
              cargando={trabajarMutation.isPending || actualizarMutation.isPending}
            />
          )}
        </DialogContent>
      </Dialog>

      <AlertDialog open={eliminarId !== null} onOpenChange={(open) => !open && setEliminarId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Confirmar eliminación?</AlertDialogTitle>
            <AlertDialogDescription>
              Se eliminará el código de afectación. Esto podría afectar a los productos que lo tengan asignado en el futuro.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction className="bg-destructive text-destructive-foreground hover:bg-destructive/90" onClick={() => {
              if (eliminarId) {
                eliminarMutation.mutate(eliminarId, {
                  onSuccess: () => {
                    toast.success("Eliminado correctamente");
                    setEliminarId(null);
                  },
                  onError: () => toast.error("Error al eliminar"),
                });
              }
            }}>
              {eliminarMutation.isPending ? "Eliminando..." : "Eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
