import { useState } from "react";
import { Search, UserPlus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useClientes } from "@/features/clientes/hooks/useClientes";
import { Cliente } from "@/features/clientes/types/cliente.types";

interface SelectorClienteProps {
  onSeleccionar: (cliente: Cliente | null) => void;
  clienteSeleccionado?: Cliente | null;
}

export function SelectorCliente({
  onSeleccionar,
  clienteSeleccionado,
}: SelectorClienteProps) {
  const [open, setOpen] = useState(false);
  const [busqueda, setBusqueda] = useState("");

  const { data: clientes } = useClientes();

  const clientesFiltrados =
    clientes?.filter(
      (c) =>
        c.razonSocial.toLowerCase().includes(busqueda.toLowerCase()) ||
        c.numeroDocumento.includes(busqueda),
    ) || [];

  const handleSeleccionar = (cliente: Cliente) => {
    onSeleccionar(cliente);
    setOpen(false);
    setBusqueda("");
  };

  const clientePorDefecto: Cliente = {
    id: 0,
    razonSocial: "Público General",
    numeroDocumento: "00000000",
    idTipoDocumento: 1,
    idTipoCliente: 1,
    email: "",
    telefono: "",
    direccion: "",
    activado: true,
  };

  const clienteActual = clienteSeleccionado || clientePorDefecto;

  return (
    <div className="space-y-2">
      <label className="text-sm font-medium">Cliente</label>
      <Popover open={open} onOpenChange={setOpen}>
        <PopoverTrigger asChild>
          <Button
            variant="outline"
            role="combobox"
            aria-expanded={open}
            className="w-full justify-between"
          >
            <div className="flex items-center gap-2 truncate">
              <span className="truncate">{clienteActual.razonSocial}</span>
              {clienteActual.id !== 0 && (
                <span className="text-xs text-muted-foreground">
                  ({clienteActual.numeroDocumento})
                </span>
              )}
            </div>
            <Search className="ml-2 h-4 w-4 shrink-0 opacity-50" />
          </Button>
        </PopoverTrigger>
        <PopoverContent className="w-[400px] p-0" align="start">
          <div className="p-2 border-b">
            <div className="relative">
              <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Buscar por nombre o documento..."
                value={busqueda}
                onChange={(e) => setBusqueda(e.target.value)}
                className="pl-8"
              />
            </div>
          </div>
          <ScrollArea className="h-[300px]">
            <div className="p-2 space-y-1">
              {/* Cliente por defecto */}
              <Button
                variant="ghost"
                className="w-full justify-start"
                onClick={() => handleSeleccionar(clientePorDefecto)}
              >
                <div className="flex flex-col items-start">
                  <span className="font-medium">Público General</span>
                  <span className="text-xs text-muted-foreground">
                    Cliente por defecto
                  </span>
                </div>
              </Button>

              {/* Clientes filtrados */}
              {clientesFiltrados.map((cliente) => (
                <Button
                  key={cliente.id}
                  variant="ghost"
                  className="w-full justify-start"
                  onClick={() => handleSeleccionar(cliente)}
                >
                  <div className="flex flex-col items-start">
                    <span className="font-medium">{cliente.razonSocial}</span>
                    <span className="text-xs text-muted-foreground">
                      {cliente.numeroDocumento}
                    </span>
                  </div>
                </Button>
              ))}

              {clientesFiltrados.length === 0 && busqueda && (
                <div className="p-4 text-center text-sm text-muted-foreground">
                  No se encontraron clientes
                </div>
              )}
            </div>
          </ScrollArea>
          <div className="p-2 border-t">
            <Button variant="outline" className="w-full" size="sm">
              <UserPlus className="mr-2 h-4 w-4" />
              Nuevo Cliente
            </Button>
          </div>
        </PopoverContent>
      </Popover>
    </div>
  );
}
