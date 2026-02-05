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
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { toast } from "sonner";

import { useClientes, useEliminarCliente } from "../hooks/useClientes";
import { Cliente } from "../types/cliente.types";
import { ClienteForm } from "../componentes/ClienteForm";
import { useCatalogo } from "@/features/configuracion/hooks/useCatalogo";

export function PaginaClientes() {
  const [dialogoOpen, setDialogoOpen] = useState(false);
  const [clienteSeleccionado, setClienteSeleccionado] =
    useState<Cliente | null>(null);
  const [filtro, setFiltro] = useState("");

  const { data: clientes, isLoading, error } = useClientes();
  const eliminarCliente = useEliminarCliente();

  // Cargamos catalogos para mostrar nombres en la tabla
  // "TIPO_DOCUMENTO", "TIPO_CLIENTE"
  const { data: tiposDocumento } = useCatalogo("TIPO_DOCUMENTO");
  const { data: tiposCliente } = useCatalogo("TIPO_CLIENTE");

  const handleEliminar = (cliente: Cliente) => {
    if (confirm(`¿Estás seguro de eliminar a ${cliente.razonSocial}?`)) {
      eliminarCliente.mutate(cliente.id, {
        onSuccess: () => toast.success("Cliente eliminado correctamente"),
        onError: () => toast.error("Error al eliminar el cliente"),
      });
    }
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
          <span className="text-xs font-medium text-muted-foreground">
            {tipo?.nombre || row.idTipoDocumento}
          </span>
        );
      },
    },
    {
      header: "Número",
      accessorKey: "numeroDocumento" as keyof Cliente,
      className: "font-mono",
    },
    {
      header: "Razón Social / Nombres",
      accessorKey: "razonSocial" as keyof Cliente,
      className: "font-semibold min-w-[200px]",
    },
    {
      header: "Tipo Cliente",
      accessorKey: "idTipoCliente" as keyof Cliente,
      cell: (row: Cliente) => {
        const tipo = tiposCliente?.find((t: any) => t.id === row.idTipoCliente);
        return tipo ? (
          <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-secondary text-secondary-foreground">
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
    },
    {
      header: "Teléfono",
      accessorKey: "telefono" as keyof Cliente,
    },
    {
      header: "Acciones",
      className: "text-right",
      cell: (row: Cliente) => (
        <div className="flex justify-end gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              setClienteSeleccionado(row);
              setDialogoOpen(true);
            }}
          >
            <Edit2 className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive"
            onClick={() => handleEliminar(row)}
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
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Gestión de Clientes</h1>
        <p className="text-muted-foreground">
          Directorio de clientes, historial y gestión de crédito.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Directorio</CardTitle>
          <CardDescription>
            Lista completa de clientes registrados.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex justify-between items-center mb-4 gap-4 flex-wrap">
            <div className="relative flex-1 max-w-sm">
              <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre o documento..."
                className="pl-8"
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
              />
            </div>
            <Button
              onClick={() => {
                setClienteSeleccionado(null);
                setDialogoOpen(true);
              }}
            >
              <Plus className="mr-2 h-4 w-4" /> Nuevo Cliente
            </Button>
          </div>

          <DataTable data={clientesFiltrados} columns={columnas} />
        </CardContent>
      </Card>

      <Dialog open={dialogoOpen} onOpenChange={setDialogoOpen}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>
              {clienteSeleccionado
                ? "Editar Cliente"
                : "Registrar Nuevo Cliente"}
            </DialogTitle>
          </DialogHeader>
          <ClienteForm
            cliente={clienteSeleccionado || undefined}
            onSuccess={() => {
              toast.success(
                clienteSeleccionado ? "Cliente actualizado" : "Cliente creado",
              );
              setDialogoOpen(false);
            }}
            onCancel={() => setDialogoOpen(false)}
          />
        </DialogContent>
      </Dialog>
    </div>
  );
}
