import { useState } from "react";
import { Plus, Edit2, Trash2, List } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
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
import { usePagination } from "@/hooks/usePagination";
import { TablaGeneralForm } from "../componentes/TablaGeneralForm";
import { TablaGeneralDetallesManager } from "../componentes/TablaGeneralDetallesManager";
import {
  useTablasGenerales,
  useCrearTabla,
  useActualizarTabla,
  useEliminarTabla,
} from "../hooks/useTablaGeneral";
import {
  TablaGeneral,
  TablaGeneralFormData,
} from "../tipos/tablaGeneral.types";
import { Loading } from "@compartido/componentes/feedback/Loading";
import { MensajeError } from "@compartido/componentes/feedback/MensajeError";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaTablasGenerales() {
  const [tablaDialogoOpen, setTablaDialogoOpen] = useState(false);
  const [detalleDialogoOpen, setDetalleDialogoOpen] = useState(false);

  const [tablaSeleccionada, setTablaSeleccionada] =
    useState<TablaGeneral | null>(null); // For Edit Table or View Details
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda } =
    usePagination();
  const { data, isLoading, error } = useTablasGenerales(paginacion);

  const crearTabla = useCrearTabla();
  const actualizarTabla = useActualizarTabla();
  const eliminarTabla = useEliminarTabla();

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
    setTablaSeleccionada(null);
    setTablaDialogoOpen(true);
  };

  const handleEditar = (tabla: TablaGeneral) => {
    setTablaSeleccionada(tabla);
    setTablaDialogoOpen(true);
  };

  const handleVerDetalles = (tabla: TablaGeneral) => {
    setTablaSeleccionada(tabla);
    setDetalleDialogoOpen(true);
  };

  const handleEliminar = (tabla: TablaGeneral) => {
    setEliminarId(tabla.id);
  };

  const handleGuardarTabla = (datos: TablaGeneralFormData) => {
    if (tablaSeleccionada) {
      actualizarTabla.mutate(
        { id: tablaSeleccionada.id, datos },
        {
          onSuccess: () => {
            toast.success("Tabla actualizada");
            setTablaDialogoOpen(false);
          },
          onError: (e: any) => toast.error("Error: " + e.message),
        },
      );
    } else {
      crearTabla.mutate(datos, {
        onSuccess: () => {
          toast.success("Tabla creada");
          setTablaDialogoOpen(false);
        },
        onError: (e: any) => toast.error("Error: " + e.message),
      });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando Tablas Generales..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const tablas = data?.datos || [];

  const columns = [
    {
      header: "Código",
      accessorKey: "codigo" as keyof TablaGeneral,
      className: "font-mono font-medium text-[11px]",
    },
    {
      header: "Nombre",
      accessorKey: "nombre" as keyof TablaGeneral,
      className: "font-bold text-primary",
    },
    { 
      header: "Descripción", 
      accessorKey: "descripcion" as keyof TablaGeneral,
      className: "text-muted-foreground",
    },
    {
      header: "Valores",
      accessorKey: "cantidadValores" as keyof TablaGeneral,
      cell: (row: TablaGeneral) => (
        <Badge variant="secondary" className="bg-muted/50 text-[11px] h-5 shadow-none">{row.cantidadValores}</Badge>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: TablaGeneral) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="outline"
            size="sm"
            className="h-8 px-2 text-[11px]"
            onClick={() => handleVerDetalles(row)}
            title="Gestionar Valores"
          >
            <List className="h-3.5 w-3.5 mr-1" /> Valores
          </Button>
          <Button
            variant="ghost"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => handleEditar(row)}
            title="Editar Tabla"
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          {!row.esSistema && (
            <Button
              variant="ghost"
              size="sm"
              className="h-8 w-8 p-0 text-destructive hover:text-destructive hover:bg-destructive/10"
              onClick={() => handleEliminar(row)}
              title="Eliminar Tabla"
            >
              <Trash2 className="h-4 w-4" />
            </Button>
          )}
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsConfig} />

      <Card className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <CardHeader className="bg-muted/5 border-b pb-4">
          <CardTitle className="text-lg">Tablas Generales</CardTitle>
          <CardDescription>
            Gestión de catálogos y tablas maestras del sistema.
          </CardDescription>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable
            data={tablas}
            columns={columns}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            searchPlaceholder="Buscar tablas..."
            actionElement={
              <Button size="sm" onClick={handleCrear}>
                <Plus className="mr-2 h-4 w-4" /> Nueva Tabla
              </Button>
            }
          />
        </CardContent>
      </Card>

      {/* Dialogo CREAR/EDITAR TABLA */}
      <Dialog open={tablaDialogoOpen} onOpenChange={setTablaDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {tablaSeleccionada ? "Editar Tabla" : "Nueva Tabla General"}
            </DialogTitle>
          </DialogHeader>
          <TablaGeneralForm
            datosIniciales={tablaSeleccionada || undefined}
            alEnviar={handleGuardarTabla}
            alCancelar={() => setTablaDialogoOpen(false)}
            cargando={crearTabla.isPending || actualizarTabla.isPending}
          />
        </DialogContent>
      </Dialog>

      <AlertDialog open={eliminarId !== null} onOpenChange={(open) => !open && setEliminarId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción eliminará la tabla y sus valores asociados. No se
              puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarTabla.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Tabla eliminada");
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

      {/* Dialogo GESTIONAR DETALLES */}
      <Dialog open={detalleDialogoOpen} onOpenChange={setDetalleDialogoOpen}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>
              Valores: {tablaSeleccionada?.nombre} ({tablaSeleccionada?.codigo})
            </DialogTitle>
          </DialogHeader>
          {tablaSeleccionada && (
            <TablaGeneralDetallesManager tabla={tablaSeleccionada} />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
