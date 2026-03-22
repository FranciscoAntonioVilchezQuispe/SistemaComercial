import { useState } from "react";
import { Plus, Edit2, Trash2, Search } from "lucide-react";
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
import { Input } from "@/components/ui/input";
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
import { Cliente } from "../types/cliente.types";
import { ClienteForm } from "../componentes/ClienteForm";
import { useCatalogo } from "@/features/configuracion/hooks/useCatalogo";
import { useTipoDocumento } from "@/features/configuracion/hooks/useTipoDocumento";

export function PaginaClientes() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [idClienteAEditar, setIdClienteAEditar] = useState<number | null>(null);
  const [filtro, setFiltro] = useState("");
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const { data: clientes, isLoading, error } = useClientes();
  const { data: clienteDetalle, isLoading: cargandoDetalle } = useCliente(idClienteAEditar || 0);
  const eliminarCliente = useEliminarCliente();

  // Cargamos tipos de documento desde configuracion.tipo_documento y
  // tipo cliente desde el catálogo de detalle
  const { data: tiposDocumento } = useTipoDocumento();
  const { data: tiposCliente } = useCatalogo("TIPO_CLIENTE");

  const tabsVentas = [
    { label: RUTAS_TITULOS["/ventas/pos"], to: "/ventas/pos" },
    { label: RUTAS_TITULOS["/ventas/lista"], to: "/ventas/lista" },
    { label: RUTAS_TITULOS["/ventas/cotizaciones"], to: "/ventas/cotizaciones" },
    { label: RUTAS_TITULOS["/clientes"], to: "/clientes" },
  ];

  const handleEliminar = (id: number) => {
    eliminarCliente.mutate(id, {
      onSuccess: () => {
        toast.success("Cliente eliminado correctamente");
        setEliminarId(null);
      },
      onError: () => {
        toast.error("Error al eliminar el cliente");
        setEliminarId(null);
      },
    });
  };

  const clientesFiltrados =
    clientes?.filter(
      (c) =>
        c.razonSocial.toLowerCase().includes(filtro.toLowerCase()) ||
        c.numeroDocumento.includes(filtro),
    ) || [];

  const columnas = [
    {
      header: "Doc.",
      accessorKey: "idTipoDocumento" as keyof Cliente,
      cell: (row: Cliente) => {
        const tipo = tiposDocumento?.find(
          (t: any) => t.id === row.idTipoDocumento,
        );
        return (
          <span className="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold uppercase bg-muted text-muted-foreground border border-muted-foreground/10">
            {tipo?.nombre || tipo?.codigo || row.idTipoDocumento}
          </span>
        );
      },
    },
    {
      header: "Número",
      accessorKey: "numeroDocumento" as keyof Cliente,
      className: "font-mono font-medium",
    },
    {
      header: "Razón Social / Nombres",
      accessorKey: "razonSocial" as keyof Cliente,
      className: "font-semibold min-w-[200px] text-primary",
    },
    {
      header: "Tipo Cliente",
      accessorKey: "idTipoCliente" as keyof Cliente,
      cell: (row: Cliente) => {
        const tipo = tiposCliente?.find((t: any) => t.id === row.idTipoCliente);
        return tipo ? (
          <span className="inline-flex items-center px-2 py-0.5 rounded-md text-[11px] font-medium bg-secondary/50 text-secondary-foreground border border-secondary">
            {tipo.nombre}
          </span>
        ) : (
          "-"
        );
      },
    },
    {
      header: "Email",
      accessorKey: "email" as keyof Cliente,
      className: "text-sm text-muted-foreground",
    },
    {
      header: "Teléfono",
      accessorKey: "telefono" as keyof Cliente,
      className: "text-sm text-muted-foreground",
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Cliente) => (
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

      <div className="rounded-xl border border-muted/20 bg-card shadow-sm overflow-hidden">
        <div className="p-6">
          <div className="flex justify-between items-center mb-6 gap-4 flex-wrap">
            <div className="relative flex-1 max-w-sm">
              <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre o documento..."
                className="pl-9 h-9 bg-muted/20"
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
              />
            </div>
          </div>

          <DataTable data={clientesFiltrados} columns={columnas} />
        </div>
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
