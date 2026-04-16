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

import { useClientes, useCliente, useEliminarCliente } from "../hooks/useClientes";
import { ClienteResumen, ClienteDetalle } from "../types/cliente.types";
import { ClienteForm } from "../componentes/ClienteForm";
import { usePagination } from "@/hooks/usePagination";

export function PaginaClientes() {
  const { paginacion, cambiarPagina, cambiarPageSize, cambiarBusqueda, cambiarFiltroActivo } = usePagination();
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idClienteAEditar, setIdClienteAEditar] = useState<number | null>(null);
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data, isLoading, error } = useClientes(paginacion);
  const clientes = data?.datos || [];
  const { data: respDetalle, isLoading: cargandoDetalle } = useCliente(idClienteAEditar || 0);
  const clienteDetalle = respDetalle as ClienteDetalle;
  const eliminarCliente = useEliminarCliente();

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/notas"], to: "/ventas/notas" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];
  const handleEliminar = (id: number) => {
    eliminarCliente.mutate(id, {
      onSuccess: () => {
        toast.success("Cliente eliminado correctamente");
        setEliminarId(null);
      },
      onError: (error) => {
        console.error("Error al eliminar el cliente:", error);
        setEliminarId(null);
      },
    });
  };

  const columnas = [
    {
      header: "Doc.",
      accessorKey: "tipoDocumentoNombre" as keyof ClienteResumen,
      cell: (row: ClienteResumen) => (
        <span className="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold uppercase bg-muted text-muted-foreground border border-muted-foreground/10">
          {row.tipoDocumentoNombre}
        </span>
      ),
    },
    {
      header: "Número",
      accessorKey: "numeroDocumento" as keyof ClienteResumen,
      className: "font-mono font-medium",
    },
    {
      header: "Razón Social / Nombres",
      accessorKey: "razonSocial" as keyof ClienteResumen,
      className: "font-semibold min-w-[200px] text-primary",
    },
    {
      header: "Condición SUNAT",
      accessorKey: "condicionSunat" as keyof ClienteResumen,
      cell: (row: ClienteResumen) => (
        <span className="text-[11px] font-medium text-muted-foreground">
          {row.condicionSunat || "-"}
        </span>
      ),
    },
    {
      header: "Estado",
      accessorKey: "activado" as keyof ClienteResumen,
      cell: (row: ClienteResumen) => (
        <span
          className={`px-2 py-1 rounded text-xs font-medium ${
            row.activado
              ? "bg-green-100 text-green-800"
              : "bg-red-100 text-red-800"
          }`}
        >
          {row.activado ? "Activo" : "Inactivo"}
        </span>
      ),
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: ClienteResumen) => (
        <div className="flex justify-end gap-1">
          <Button
            variant="ghost"
            size="sm"
            className="h-8 w-8 p-0"
            onClick={() => {
              setIdClienteAEditar(row.id);
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

  if (isLoading) return <Loading mensaje="Cargando clientes..." />;
  if (error) return <MensajeError mensaje="Error al cargar clientes" />;

  return (
    <div className="space-y-4">
      <ModuleTabBar tabs={tabsVentas} />

      <div className="flex justify-end mb-2">
        <Button
          size="sm"
          onClick={() => {
            setIdClienteAEditar(null);
            setDialogoOpen(true);
          }}
        >
          <Plus className="mr-2 h-4 w-4" /> Nuevo Cliente
        </Button>
      </div>

      <div className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden p-6">
        <DataTable 
          data={clientes} 
          columns={columnas} 
          pagination={data}
          onPageChange={cambiarPagina}
          onPageSizeChange={cambiarPageSize}
          onSearchChange={cambiarBusqueda}
          onActiveFilterChange={cambiarFiltroActivo}
          searchValue={paginacion.search}
          isLoading={isLoading}
          searchPlaceholder="Buscar por nombre o documento..."
        />
      </div>

      {/* AlertDialog eliminar */}
      <AlertDialog
        open={eliminarId !== null}
        onOpenChange={(open) => !open && setEliminarId(null)}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>
              Esta acción eliminará permanentemente al cliente y todos sus datos
              asociados. No se puede deshacer.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              onClick={() => eliminarId && handleEliminar(eliminarId)}
              disabled={eliminarCliente.isPending}
            >
              {eliminarCliente.isPending ? "Eliminando..." : "Sí, eliminar"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>
              {idClienteAEditar
                ? "Editar Cliente"
                : "Registrar Nuevo Cliente"}
            </DialogTitle>
          </DialogHeader>
          
          {idClienteAEditar && cargandoDetalle ? (
            <div className="py-20 flex justify-center items-center">
              <Loading mensaje="Cargando detalle del cliente..." />
            </div>
          ) : (
            <ClienteForm
              key={idClienteAEditar || "nuevo"}
              cliente={clienteDetalle || undefined}
              onSuccess={() => {
                toast.success(
                  idClienteAEditar ? "Cliente actualizado" : "Cliente creado",
                );
                setDialogoOpen(false);
                setIdClienteAEditar(null);
              }}
              onCancel={() => {
                setDialogoOpen(false);
                setIdClienteAEditar(null);
              }}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}
