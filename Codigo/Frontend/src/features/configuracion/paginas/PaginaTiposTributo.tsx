import { useState } from "react";
import { Plus, Edit2, Trash2, Database, Calculator, Gavel } from "lucide-react";
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
  useTiposTributo,
  useTipoTributo,
  useCrearTipoTributo,
  useActualizarTipoTributo,
  useEliminarTipoTributo,
  useInicializarTipoTributo,
} from "../hooks/useTipoTributo";
import { TipoTributo, TipoTributoFormData } from "../tipos/tipoTributo.types";
import { TipoTributoForm } from "../componentes/TipoTributoForm";
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

export function PaginaTiposTributo() {
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } = usePagination();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idRegistroAEditar, setIdRegistroAEditar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data, isLoading, error } = useTiposTributo(paginacion);
  const tributos = data?.datos || [];
  const { data: registroDetalle, isLoading: cargandoDetalle } = useTipoTributo(idRegistroAEditar || 0);

  const trabajarMutation = useCrearTipoTributo();
  const actualizarMutation = useActualizarTipoTributo();
  const eliminarMutation = useEliminarTipoTributo();
  const inicializarMutation = useInicializarTipoTributo();

  const tabsConfig = [
    { label: RUTAS_TITULOS["/configuracion/empresa"], to: "/configuracion/empresa" },
    { label: RUTAS_TITULOS["/configuracion/sucursales"], to: "/configuracion/sucursales" },
    { label: RUTAS_TITULOS["/configuracion/impuestos"], to: "/configuracion/impuestos" },
    { label: "Afectación IGV", to: "/configuracion/afectacion-igv" },
    { label: "Tipos de Tributo", to: "/configuracion/tipos-tributo" },
    { label: RUTAS_TITULOS["/configuracion/metodos-pago"], to: "/configuracion/metodos-pago" },
    { label: RUTAS_TITULOS["/configuracion/comprobantes"], to: "/configuracion/comprobantes" },
  ];

  const handleCrear = () => {
    setIdRegistroAEditar(null);
    setDialogoOpen(true);
  };

  const handleEditar = (id: number) => {
    setIdRegistroAEditar(id);
    setDialogoOpen(true);
  };

  const handleGuardar = (datos: TipoTributoFormData) => {
    if (idRegistroAEditar) {
      actualizarMutation.mutate(
        { id: idRegistroAEditar, datos },
        {
          onSuccess: () => {
            toast.success("Tributo actualizado");
            setDialogoOpen(false);
            setIdRegistroAEditar(null);
          },
          onError: (err) => toast.error("Error al actualizar: " + err.message),
        },
      );
    } else {
      trabajarMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Tributo creado");
          setDialogoOpen(false);
        },
        onError: (err) => toast.error("Error al crear: " + err.message),
      });
    }
  };

  const handleInicializar = () => {
    inicializarMutation.mutate(undefined, {
      onSuccess: () => toast.success("Catálogo de tributos inicializado"),
      onError: (err) => toast.error("Error al inicializar: " + err.message),
    });
  };

  if (isLoading) return <Loading mensaje="Cargando tributos..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Cód. SUNAT",
      accessorKey: "codigo" as keyof TipoTributo,
      cell: (row: TipoTributo) => (
        <span className="font-mono font-bold text-amber-600 bg-amber-50 border border-amber-200 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof TipoTributo,
      className: "font-bold text-primary",
    },
    {
      header: "Cód. Internacional",
      accessorKey: "codigoInternacional" as keyof TipoTributo,
      cell: (row: TipoTributo) => (
        <span className="text-muted-foreground italic text-[12px]">{row.codigoInternacional}</span>
      ),
    },
    {
      header: "Descripción",
      accessorKey: "descripcion" as keyof TipoTributo,
      className: "text-muted-foreground text-sm",
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TipoTributo) => (
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

      {tributos.length === 0 && (
        <Alert variant="default" className="bg-amber-50/50 border-amber-200">
          <Calculator className="h-4 w-4 text-amber-600" />
          <AlertTitle className="text-amber-700">Tributos no configurados</AlertTitle>
          <AlertDescription className="text-amber-600/80 flex flex-col gap-3">
            Para la facturación electrónica es necesario definir los códigos de tributos oficiales de SUNAT.
            <Button onClick={handleInicializar} disabled={inicializarMutation.isPending} size="sm" className="w-fit bg-amber-600 hover:bg-amber-700">
               <Database className="mr-2 h-4 w-4" /> Cargar Catálogo Tributario (Cat. 05)
            </Button>
          </AlertDescription>
        </Alert>
      )}

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4 flex flex-row items-center justify-between space-y-0">
          <div className="space-y-1">
            <CardTitle className="text-lg flex items-center gap-2">
              <Gavel className="h-5 w-5 text-amber-600" />
              Catálogo de Tributos (Cat. 05)
            </CardTitle>
            <CardDescription>
              Definición de impuestos y contribuciones (IGV, ISC, ICBPER) según normativa UBL 2.1.
            </CardDescription>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" size="sm" onClick={handleInicializar} disabled={inicializarMutation.isPending}>
               Sincronizar SUNAT
            </Button>
            <Button onClick={handleCrear} size="sm">
              <Plus className="mr-2 h-4 w-4" /> Nuevo Tributo
            </Button>
          </div>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable 
            data={tributos} 
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
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>
              {idRegistroAEditar ? "Editar Tributo" : "Nuevo Tributo SUNAT"}
            </DialogTitle>
          </DialogHeader>

          {idRegistroAEditar && cargandoDetalle ? (
            <div className="py-10 flex justify-center">
              <Loading mensaje="Cargando..." />
            </div>
          ) : (
            <TipoTributoForm
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
              Esta acción eliminará la definición del tributo. Asegúrese de que ningún impuesto dependa de este código.
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
