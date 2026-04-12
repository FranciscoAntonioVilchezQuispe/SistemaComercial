import { useState } from "react";
import { Plus, Edit2, Trash2, Store } from "lucide-react";
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
import { Card, CardContent } from "@/components/ui/card";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
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
import { useAlmacenes, useEliminarAlmacen } from "../hooks/useAlmacenes";
import { usePagination } from "@/hooks/usePagination";
import { useSucursales } from "@/features/configuracion/hooks/useSucursales";
import { Almacen } from "../types/almacen.types";
import { AlmacenForm } from "../componentes/AlmacenForm";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export function PaginaAlmacenes() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [almacenSeleccionado, setAlmacenSeleccionado] =
    useState<Almacen | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);
  
  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useAlmacenes(paginacion);
  const { data: sucursales } = useSucursales();
  const eliminarAlmacen = useEliminarAlmacen();

  const tabsInventario = [
    { label: RUTAS_TITULOS["/inventario/stock"], to: "/inventario/stock" },
    { label: RUTAS_TITULOS["/inventario/movimientos"], to: "/inventario/movimientos" },
    { label: RUTAS_TITULOS["/inventario/traslados"], to: "/inventario/traslados" },
    { label: RUTAS_TITULOS["/inventario/kardex/reporte"], to: "/inventario/kardex/reporte" },
    { label: RUTAS_TITULOS["/inventario/kardex/periodos"], to: "/inventario/kardex/periodos" },
    { label: RUTAS_TITULOS["/inventario/almacenes"], to: "/inventario/almacenes" },
  ];

  const almacenes = data?.datos || [];

// ... columnas ...
  const columnas = [
    {
      header: "Nombre",
      accessorKey: "nombreAlmacen" as keyof Almacen,
      className: "font-semibold",
      cell: (row: Almacen) => (
        <div className="flex items-center gap-2">
          <Store className="h-4 w-4 text-muted-foreground" />
          <span>{row.nombreAlmacen}</span>
          {row.esPrincipal && (
            <Badge variant="default" className="ml-2 text-[10px] px-1 py-0 h-4">
              Principal
            </Badge>
          )}
        </div>
      ),
    },
    {
      header: "Sucursal",
      accessorKey: "idSucursal" as keyof Almacen,
      cell: (row: Almacen) => {
        const sucursal = sucursales?.datos?.find((s) => s.id === row.idSucursal);
        return (
          <span>{sucursal?.nombreSucursal || `ID: ${row.idSucursal}`}</span>
        );
      },
    },
    {
      header: "Dirección",
      accessorKey: "direccion" as keyof Almacen,
    },
    {
      header: "Estado",
      accessorKey: "activado" as keyof Almacen,
      cell: (row: Almacen) =>
        row.activado === true ? (
          <Badge
            variant="outline"
            className="bg-green-50 text-green-700 border-green-200"
          >
            Activo
          </Badge>
        ) : (
          <Badge
            variant="outline"
            className="bg-red-50 text-red-700 border-red-200"
          >
            Inactivo
          </Badge>
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Almacen) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setAlmacenSeleccionado(row);
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

  if (isLoading) return <Loading mensaje="Cargando almacenes..." />;
  if (error) return <MensajeError mensaje="Error al cargar almacenes" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsInventario} />

      <div className="flex justify-end gap-2 mb-2">
        <Button
          onClick={() => {
            setAlmacenSeleccionado(null);
            setDialogoOpen(true);
          }}
          size="sm"
        >
          <Plus className="mr-2 h-4 w-4" /> Nuevo Almacén
        </Button>
      </div>

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <DataTable
            data={almacenes}
            columns={columnas}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            onActiveFilterChange={cambiarFiltroActivo}
            searchPlaceholder="Buscar por nombre..."
            isLoading={isLoading}
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="sm:max-w-[425px]">
          <DialogHeader>
            <DialogTitle>
              {almacenSeleccionado ? "Editar Almacén" : "Registrar Almacén"}
            </DialogTitle>
          </DialogHeader>
          <AlmacenForm
            almacen={almacenSeleccionado || undefined}
            onSuccess={() => {
              toast.success(
                almacenSeleccionado ? "Almacén actualizado" : "Almacén creado",
              );
              setDialogoOpen(false);
            }}
            onCancel={() => setDialogoOpen(false)}
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
              Esta acción no se puede deshacer. El almacén y sus valores
              asociados serán eliminados.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarAlmacen.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Almacén eliminado correctamente");
                      setEliminarId(null);
                    },
                    onError: (error) => {
                      console.error("Error al eliminar el almacén:", error);
                      setEliminarId(null);
                    },
                  });
                }
              }}
            >
              {eliminarAlmacen.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
