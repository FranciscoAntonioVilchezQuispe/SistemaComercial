import { useState } from "react";
import { UserPlus, Edit, Trash2 } from "lucide-react";
import { useClientes, useEliminarCliente } from "../hooks/useClientes";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ClienteFiltros, Cliente } from "../tipos/ventas.types";
import { DataTable } from "@/components/ui/DataTable";
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

export function PaginaClientes() {
  const [filtros, setFiltros] = useState<ClienteFiltros>({});
  const { data, isLoading } = useClientes(filtros, 1, 100);
  const eliminarCliente = useEliminarCliente();
  const [eliminarId, setEliminarId] = useState<number | null>(null);

  const handleNuevoCliente = () => {
    toast.info("Próximamente");
  };

  const handleEditar = (_cliente: Cliente) => {
    toast.info("Próximamente");
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Clientes</h1>
          <p className="text-muted-foreground">
            Administra la base de datos de tus clientes y sus líneas de crédito.
          </p>
        </div>
        <Button onClick={handleNuevoCliente}>
          <UserPlus className="mr-2 h-4 w-4" />
          Nuevo Cliente
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Clientes</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={data?.datos || []}
            columns={[
              {
                header: "Cliente",
                cell: (cliente: Cliente) => (
                  <div className="flex items-center gap-3">
                    <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
                      <UserPlus className="h-4 w-4 text-primary" />
                    </div>
                    <div className="flex flex-col">
                      <span className="font-medium">{cliente.razonSocial || cliente.nombreComercial || "Sin Nombre"}</span>
                      <span className="text-xs text-muted-foreground">Documento: {cliente.numeroDocumento}</span>
                    </div>
                  </div>
                ),
              },
              {
                header: "Contacto",
                cell: (cliente: Cliente) => (
                  <div className="flex flex-col gap-1">
                    {cliente.telefono && <div className="flex items-center text-xs">{cliente.telefono}</div>}
                    {cliente.email && <div className="flex items-center text-xs">{cliente.email}</div>}
                  </div>
                ),
              },
              {
                header: "Tipo",
                cell: (cliente: Cliente) => (
                  <div className="inline-block px-2 py-1 text-xs rounded-md border">{cliente.idTipoCliente === 1 ? "Persona" : "Empresa"}</div>
                ),
              },
              {
                header: "Estado",
                cell: (cliente: Cliente) => (
                  <div className="text-xs">{cliente.activado ? "Activo" : "Inactivo"}</div>
                ),
              },
              {
                header: "Acciones",
                cell: (cliente: Cliente) => (
                  <div className="flex items-center gap-2 justify-end">
                    <Button variant="ghost" size="icon" onClick={() => handleEditar(cliente)} title="Editar cliente">
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" className="text-destructive" onClick={() => setEliminarId(cliente.id)} title="Eliminar cliente">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                ),
              },
            ]}
            onSearchChange={(s) => setFiltros({ ...filtros, busqueda: s })}
            searchPlaceholder="Buscar por nombre o documento..."
            isLoading={isLoading}
            actionElement={<Button onClick={handleNuevoCliente}><UserPlus className="mr-2 h-4 w-4" /> Nuevo Cliente</Button>}
          />
        </CardContent>
      </Card>

      <AlertDialog open={eliminarId !== null} onOpenChange={(open) => !open && setEliminarId(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>¿Está absolutamente seguro?</AlertDialogTitle>
            <AlertDialogDescription>Esta acción no se puede deshacer. El cliente será eliminado.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Cancelar</AlertDialogCancel>
            <AlertDialogAction className="bg-destructive text-destructive-foreground hover:bg-destructive/90" onClick={() => {
              if (eliminarId) {
                eliminarCliente.mutate(eliminarId, {
                  onSuccess: () => { setEliminarId(null); toast.success("Cliente eliminado correctamente"); },
                  onError: () => toast.error("Error al eliminar el cliente"),
                });
              }
            }}>{eliminarCliente.isPending ? "Eliminando..." : "Sí, eliminar"}</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
