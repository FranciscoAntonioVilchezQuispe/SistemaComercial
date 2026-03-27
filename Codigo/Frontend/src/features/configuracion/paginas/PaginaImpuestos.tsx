import { useState } from "react";
import { Plus, Edit2, Trash2, Percent, CheckCircle } from "lucide-react";
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
  useImpuesto,
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

export function PaginaImpuestos() {
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda, cambiarFiltroActivo } = usePagination();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idRegistroAEditar, setIdRegistroAEditar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data, isLoading, error } = useImpuestos(paginacion);
  const impuestos = data?.datos || [];
  const { data: registroDetalle, isLoading: cargandoDetalle } = useImpuesto(idRegistroAEditar || 0);

  const crearMutation = useCrearImpuesto();
  const actualizarMutation = useActualizarImpuesto();
  const eliminarMutation = useEliminarImpuesto();

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
    setIdRegistroAEditar(null);
    setDialogoOpen(true);
  };

  const handleEditar = (id: number) => {
    setIdRegistroAEditar(id);
    setDialogoOpen(true);
  };

  const handleGuardar = (datos: ImpuestoFormData) => {
    if (idRegistroAEditar) {
      actualizarMutation.mutate(
        { id: idRegistroAEditar, datos },
        {
          onSuccess: () => {
            toast.success("Impuesto actualizado");
            setDialogoOpen(false);
            setIdRegistroAEditar(null);
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
      cell: (row: Impuesto) => (
        <span className="font-mono font-bold bg-muted/50 text-muted-foreground border border-muted/20 px-2 py-0.5 rounded text-[11px]">
          {row.codigo}
        </span>
      ),
    },
    {
      header: "Nombre del Impuesto",
      accessorKey: "nombre" as keyof Impuesto,
      className: "font-semibold text-primary",
    },
    {
      header: "Porcentaje",
      accessorKey: "porcentaje" as keyof Impuesto,
      cell: (row: Impuesto) => (
        <div className="flex items-center gap-1 font-mono font-bold text-blue-600">
          <Percent className="h-3 w-3" />
          <span>{row.porcentaje.toFixed(2)}%</span>
        </div>
      ),
    },
    {
      header: "Estado",
      accessorKey: "esIgv" as keyof Impuesto,
      cell: (row: Impuesto) =>
        row.esIgv ? (
          <Badge variant="default" className="gap-1 bg-blue-500/10 text-blue-600 border-blue-200 hover:bg-blue-500/20 shadow-none text-[11px] h-5">
            <CheckCircle className="h-3 w-3" /> Principal (IGV)
          </Badge>
        ) : (
          <Badge variant="secondary" className="bg-muted/50 text-muted-foreground shadow-none text-[11px] h-5">
            Otros
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Impuesto) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => handleEditar(row.id)}
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
            <CardTitle className="text-lg">Impuestos y Tasas</CardTitle>
            <CardDescription>
              Gestión de impuestos aplicables a ventas y compras (IGV, IVA, etc.).
            </CardDescription>
          </div>
          <Button onClick={handleCrear} size="sm">
            <Plus className="mr-2 h-4 w-4" /> Nuevo Impuesto
          </Button>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable 
            data={impuestos} 
            columns={columns} 
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            onActiveFilterChange={cambiarFiltroActivo}
            isLoading={isLoading}
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {idRegistroAEditar ? "Editar Impuesto" : "Nuevo Impuesto"}
            </DialogTitle>
          </DialogHeader>

          {idRegistroAEditar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle del impuesto..." />
            </div>
          ) : (
            <ImpuestoForm
              key={idRegistroAEditar || "nuevo"}
              datosIniciales={registroDetalle || undefined}
              alEnviar={handleGuardar}
              alCancelar={() => {
                setDialogoOpen(false);
                setIdRegistroAEditar(null);
              }}
              cargando={crearMutation.isPending || actualizarMutation.isPending}
            />
          )}
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
