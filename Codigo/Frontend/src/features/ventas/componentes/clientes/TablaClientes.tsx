import { Edit, Trash2, User, Phone, Mail } from "lucide-react";
import { Cliente } from "../../tipos/ventas.types";
import { TablaPaginada } from "@/compartido/componentes/tablas/TablaPaginada";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { formatearMoneda } from "@compartido/utilidades";

interface Props {
  clientes: Cliente[];
  isLoading: boolean;
  onEditar: (cliente: Cliente) => void;
  onEliminar: (cliente: Cliente) => void;
}

export function TablaClientes({
  clientes,
  isLoading,
  onEditar,
  onEliminar,
}: Props) {
  const columnas = [
    {
      clave: "nombres",
      titulo: "Cliente",
      renderizar: (cliente: Cliente) => (
        <div className="flex items-center gap-3">
          <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
            <User className="h-4 w-4 text-primary" />
          </div>
          <div className="flex flex-col">
            <span className="font-medium">
              {cliente.razonSocial ||
                `${cliente.nombres} ${cliente.apellidos || ""}`}
            </span>
            <span className="text-xs text-muted-foreground">
              {cliente.tipoDocumento}: {cliente.numeroDocumento}
            </span>
          </div>
        </div>
      ),
    },
    {
      clave: "telefono",
      titulo: "Contacto",
      renderizar: (cliente: Cliente) => (
        <div className="flex flex-col gap-1">
          {cliente.telefono && (
            <div className="flex items-center text-xs">
              <Phone className="mr-1 h-3 w-3" /> {cliente.telefono}
            </div>
          )}
          {cliente.email && (
            <div className="flex items-center text-xs">
              <Mail className="mr-1 h-3 w-3" /> {cliente.email}
            </div>
          )}
        </div>
      ),
    },
    {
      clave: "tipoCliente",
      titulo: "Tipo",
      renderizar: (cliente: Cliente) => (
        <Badge variant="outline">{cliente.tipoCliente || "Regular"}</Badge>
      ),
    },
    {
      clave: "creditoDisponible",
      titulo: "Crédito Disp.",
      renderizar: (cliente: Cliente) => (
        <span
          className={cliente.creditoDisponible < 0 ? "text-destructive" : ""}
        >
          {formatearMoneda(cliente.creditoDisponible)}
        </span>
      ),
    },
    {
      clave: "activo",
      titulo: "Estado",
      renderizar: (cliente: Cliente) => (
        <Badge variant={cliente.activo ? "default" : "secondary"}>
          {cliente.activo ? "Activo" : "Inactivo"}
        </Badge>
      ),
    },
    {
      clave: "acciones",
      titulo: "Acciones",
      renderizar: (cliente: Cliente) => (
        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => onEditar(cliente)}
            title="Editar cliente"
          >
            <Edit className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="text-destructive hover:text-destructive"
            onClick={() => onEliminar(cliente)}
            title="Eliminar cliente"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  return (
    <TablaPaginada datos={clientes} columnas={columnas} cargando={isLoading} />
  );
}
