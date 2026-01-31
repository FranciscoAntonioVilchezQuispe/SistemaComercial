import { useState } from "react";
import { Search, UserPlus, Filter } from "lucide-react";
import { useClientes } from "../hooks/useClientes";
import { TablaClientes } from "../componentes/clientes/TablaClientes";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ClienteFiltros, Cliente } from "../tipos/ventas.types";
import { ModalConfirmacion } from "@/compartido/componentes/feedback/ModalConfirmacion";
import { toast } from "sonner";

export function PaginaClientes() {
  const [filtros, setFiltros] = useState<ClienteFiltros>({});
  const [clienteAEliminar, setClienteAEliminar] = useState<Cliente | null>(
    null,
  );
  const [modalEliminarAbierto, setModalEliminarAbierto] = useState(false);

  const { data, isLoading } = useClientes(filtros, 1, 100);

  const handleNuevoCliente = () => {
    console.log("Nuevo cliente");
  };

  const handleEditar = (cliente: Cliente) => {
    console.log("Editar cliente:", cliente);
  };

  const handleConfirmarEliminar = (cliente: Cliente) => {
    setClienteAEliminar(cliente);
    setModalEliminarAbierto(true);
  };

  const handleEliminar = async () => {
    if (!clienteAEliminar) return;

    try {
      console.log("Eliminando cliente:", clienteAEliminar.id);
      toast.success("Cliente eliminado correctamente");
    } catch (error) {
      toast.error("Error al eliminar el cliente");
    } finally {
      setModalEliminarAbierto(false);
      setClienteAEliminar(null);
    }
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
          <CardTitle>Búsqueda y Filtros</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex gap-4">
            <div className="relative flex-1">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre, documento o RUC..."
                className="pl-8"
                value={filtros.busqueda || ""}
                onChange={(e) =>
                  setFiltros({ ...filtros, busqueda: e.target.value })
                }
              />
            </div>
            <Button variant="outline">
              <Filter className="mr-2 h-4 w-4" />
              Filtros
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardContent className="pt-6">
          <TablaClientes
            clientes={data?.datos || []}
            isLoading={isLoading}
            onEditar={handleEditar}
            onEliminar={handleConfirmarEliminar}
          />
        </CardContent>
      </Card>

      <ModalConfirmacion
        abierto={modalEliminarAbierto}
        alCambiarAbierto={setModalEliminarAbierto}
        titulo="Eliminar Cliente"
        descripcion={`¿Estás seguro que deseas eliminar al cliente "${clienteAEliminar?.nombres || ""}"? esta acción no se puede deshacer.`}
        alConfirmar={handleEliminar}
        variante="destructive"
      />
    </div>
  );
}
