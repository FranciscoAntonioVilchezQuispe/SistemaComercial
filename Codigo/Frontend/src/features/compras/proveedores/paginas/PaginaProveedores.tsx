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

import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
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

import { useProveedores, useEliminarProveedor } from "../hooks/useProveedores";
import { Proveedor } from "../types/proveedor.types";
import { ProveedorForm } from "../componentes/ProveedorForm";
import { useTipoDocumento } from "@/features/configuracion/hooks/useTipoDocumento";

export default function PaginaProveedores() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [proveedorSeleccionado, setProveedorSeleccionado] =
    useState<Proveedor | null>(null);
  const [filtro, setFiltro] = useState("");

  const { data: proveedores, isLoading, error } = useProveedores();
  const eliminarProveedor = useEliminarProveedor();
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  // Tipos de documento desde configuracion.tipo_documento
  const { data: tiposDocumento } = useTipoDocumento();

  // Eliminación ahora mediante AlertDialog: abrir con setEliminarId

  const proveedoresFiltrados =
    proveedores?.filter(
      (p) =>
        p.razonSocial.toLowerCase().includes(filtro.toLowerCase()) ||
        p.numeroDocumento.includes(filtro),
    ) || [];

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
              setProveedorSeleccionado(row);
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
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Gestión de Proveedores</h1>
        <p className="text-muted-foreground">
          Directorio de proveedores y gestión de compras.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Directorio</CardTitle>
          <CardDescription>
            Lista completa de proveedores registrados.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            data={proveedoresFiltrados}
            columns={columnas}
            onSearchChange={setFiltro}
            searchPlaceholder="Buscar por razón social o documento..."
            actionElement={
              <Button
                onClick={() => {
                  setProveedorSeleccionado(null);
                  setDialogoOpen(true);
                }}
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
              {proveedorSeleccionado
                ? "Editar Proveedor"
                : "Registrar Nuevo Proveedor"}
            </DialogTitle>
          </DialogHeader>
          <ProveedorForm
            proveedor={proveedorSeleccionado || undefined}
            onSuccess={() => {
              toast.success(
                proveedorSeleccionado
                  ? "Proveedor actualizado"
                  : "Proveedor creado",
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
