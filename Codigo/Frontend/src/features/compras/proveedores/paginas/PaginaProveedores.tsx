import { useState } from "react";
import { Plus, Edit2, Trash2 } from "lucide-react";
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
import { useProveedores, useProveedor, useEliminarProveedor } from "../hooks/useProveedores";
import { Proveedor } from "../types/proveedor.types";
import { usePagination } from "@/hooks/usePagination";
import { ProveedorForm } from "../componentes/ProveedorForm";
import { useTipoDocumento } from "@/features/configuracion/hooks/useTipoDocumento";
import { ModuleTabBar } from "@/componentes/shared/ModuleTabBar";
import { RUTAS_TITULOS } from "@/config/rutasTitulos";

export default function PaginaProveedores() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idProveedorAEditar, setIdProveedorAEditar] = useState<number | null>(null);
  
  const {
    paginacion,
    cambiarPagina,
    cambiarPageSize,
    cambiarBusqueda,
    cambiarFiltroActivo,
  } = usePagination();

  const { data, isLoading, error } = useProveedores(paginacion);
  const { data: proveedorDetalle, isLoading: cargandoDetalle } = useProveedor(idProveedorAEditar || 0);
  const eliminarProveedor = useEliminarProveedor();
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const proveedores = data?.datos || [];

  // Tipos de documento desde configuracion.tipo_documento
  const { data: tiposDocumento } = useTipoDocumento();

  const tabsCompras = [
    { label: RUTAS_TITULOS["/proveedores/ordenes"], to: "/proveedores/ordenes" },
    { label: RUTAS_TITULOS["/compras/lista"], to: "/compras/lista" },
    { label: RUTAS_TITULOS["/proveedores"], to: "/proveedores" },
  ];


// ... columnas ...
  const columnas = [
    {
      header: "Doc.",
      accessorKey: "idTipoDocumento" as keyof Proveedor,
      cell: (row: Proveedor) => {
        const tipo = tiposDocumento?.find(
          (t: any) => t.id === row.idTipoDocumento,
        );
        return (
          <span className="inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-bold uppercase bg-muted text-muted-foreground">
            {tipo?.nombre || tipo?.codigo || row.idTipoDocumento}
          </span>
        );
      },
    },
    {
      header: "Número",
      accessorKey: "numeroDocumento" as keyof Proveedor,
      className: "font-mono",
    },
    {
      header: "Razón Social",
      accessorKey: "razonSocial" as keyof Proveedor,
      className: "font-semibold min-w-[200px]",
    },
    {
      header: "Email",
      accessorKey: "email" as keyof Proveedor,
    },
    {
      header: "Teléfono",
      accessorKey: "telefono" as keyof Proveedor,
    },
    {
      header: "Web",
      accessorKey: "paginaWeb" as keyof Proveedor,
      cell: (row: Proveedor) =>
        row.paginaWeb ? (
          <a
            href={row.paginaWeb}
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-600 hover:underline"
          >
            {row.paginaWeb}
          </a>
        ) : (
          "-"
        ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Proveedor) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setIdProveedorAEditar(row.id);
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

  if (isLoading) return <Loading mensaje="Cargando proveedores..." />;
  if (error) return <MensajeError mensaje="Error al cargar proveedores" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsCompras} />

      <Card className="shadow-none border-muted/20">
        <CardContent className="pt-6">
          <DataTable
            data={proveedores}
            columns={columnas}
            pagination={data}
            onPageChange={cambiarPagina}
            onPageSizeChange={cambiarPageSize}
            onSearchChange={cambiarBusqueda}
            onActiveFilterChange={cambiarFiltroActivo}
            searchPlaceholder="Buscar por razón social o documento..."
            isLoading={isLoading}
            actionElement={
              <Button
                onClick={() => {
                  setIdProveedorAEditar(null);
                  setDialogoOpen(true);
                }}
                size="sm"
              >
                <Plus className="mr-2 h-4 w-4" /> Nuevo Proveedor
              </Button>
            }
          />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>
              {idProveedorAEditar
                ? "Editar Proveedor"
                : "Registrar Nuevo Proveedor"}
            </DialogTitle>
          </DialogHeader>

          {idProveedorAEditar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle del proveedor..." />
            </div>
          ) : (
            <ProveedorForm
              key={idProveedorAEditar || "nuevo"}
              proveedor={proveedorDetalle || undefined}
              onSuccess={() => {
                toast.success(
                  idProveedorAEditar
                    ? "Proveedor actualizado"
                    : "Proveedor creado",
                );
                setDialogoOpen(false);
                setIdProveedorAEditar(null);
              }}
              onCancel={() => {
                setDialogoOpen(false);
                setIdProveedorAEditar(null);
              }}
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
              Esta acción no se puede deshacer. Se eliminará al proveedor
              seleccionado.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => {
                if (eliminarId) {
                  eliminarProveedor.mutate(eliminarId, {
                    onSuccess: () => {
                      toast.success("Proveedor eliminado correctamente");
                      setEliminarId(null);
                    },
                    onError: () =>
                      toast.error("Error al eliminar el proveedor"),
                  });
                }
              }}
            >
              {eliminarProveedor.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
