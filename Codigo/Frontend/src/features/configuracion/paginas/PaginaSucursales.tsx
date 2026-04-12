import { useState } from "react";
import { Plus, Edit2, Trash2, MapPin, CheckCircle } from "lucide-react";
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
  useSucursales,
  useCrearSucursal,
  useActualizarSucursal,
  useEliminarSucursal,
} from "../hooks/useSucursales";
import { Sucursal, SucursalFormData } from "../tipos/sucursal.types";
import { SucursalForm } from "../componentes/SucursalForm";
import { toast } from "sonner";
import { useEmpresa } from "../hooks/useEmpresa";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";
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

import { usePagination } from "@/hooks/usePagination";

export function PaginaSucursales() {
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda, cambiarFiltroActivo } = usePagination();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [registroSeleccionado, setRegistroSeleccionado] =
    useState<Sucursal | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data, isLoading, error } = useSucursales(paginacion);
  const sucursales = data?.datos || [];
  const { data: empresa } = useEmpresa(); // Needed to set default idEmpresa

  const crearMutation = useCrearSucursal();
  const actualizarMutation = useActualizarSucursal();
  const eliminarMutation = useEliminarSucursal();

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

  const handleEditar = (sucursal: Sucursal) => {
    setRegistroSeleccionado(sucursal);
    setDialogoOpen(true);
  };

  const handleGuardar = (datos: SucursalFormData) => {
    if (!datos.idEmpresa && empresa) {
      datos.idEmpresa = empresa.id;
    }

    if (registroSeleccionado) {
      actualizarMutation.mutate(
        { id: registroSeleccionado.id, datos },
        {
          onSuccess: () => {
            toast.success("Sucursal actualizada");
            setDialogoOpen(false);
          },
          onError: (err) => console.error("Error al actualizar:", err),
        },
      );
    } else {
      crearMutation.mutate(datos, {
        onSuccess: () => {
          toast.success("Sucursal creada");
          setDialogoOpen(false);
        },
        onError: (err) => console.error("Error al crear:", err),
      });
    }
  };

  if (isLoading) return <Loading mensaje="Cargando sucursales..." />;
  if (error) return <MensajeError mensaje={error.message} />;

  const columns = [
    {
      header: "Nombre",
      accessorKey: "nombreSucursal" as keyof Sucursal,
      className: "font-semibold text-primary",
    },
    {
      header: "Dirección",
      accessorKey: "direccion" as keyof Sucursal,
      cell: (row: Sucursal) => (
        <div className="flex items-center gap-1 text-muted-foreground">
          <MapPin className="h-3 w-3" />
          <span className="text-sm">{row.direccion || "-"}</span>
        </div>
      ),
    },
    { 
      header: "Teléfono", 
      accessorKey: "telefono" as keyof Sucursal,
      className: "font-mono text-xs",
    },
    {
      header: "Estado",
      accessorKey: "esPrincipal" as keyof Sucursal,
      cell: (row: Sucursal) =>
        row.esPrincipal ? (
          <Badge variant="default" className="gap-1 bg-blue-500/10 text-blue-600 border-blue-200 hover:bg-blue-500/20 shadow-none text-[11px] h-5">
            <CheckCircle className="h-3 w-3" /> Principal
          </Badge>
        ) : (
          <Badge variant="secondary" className="bg-muted/50 text-muted-foreground shadow-none text-[11px] h-5">
            Secundaria
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Sucursal) => (
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
            <CardTitle className="text-lg">Sucursales y Locales</CardTitle>
            <CardDescription>
              Gestión de tiendas, almacenes y puntos de venta de la empresa.
            </CardDescription>
          </div>
          <Button onClick={handleCrear} size="sm">
            <Plus className="mr-2 h-4 w-4" /> Nueva Sucursal
          </Button>
        </CardHeader>
        <CardContent className="p-6">
          <DataTable 
            data={sucursales} 
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
              {registroSeleccionado ? "Editar Sucursal" : "Nueva Sucursal"}
            </DialogTitle>
          </DialogHeader>
          <SucursalForm
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
              Esta acción no se puede deshacer. La sucursal seleccionada será
              eliminada.
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
                      toast.success("Sucursal eliminada");
                      setEliminarId(null);
                    },
                    onError: (err) => {
                      console.error("Error al eliminar sucursal:", err);
                      setEliminarId(null);
                    },
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
