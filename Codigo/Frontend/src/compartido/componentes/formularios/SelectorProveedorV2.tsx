import React from "react";
import { Check, Plus, Search } from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  CommandList,
} from "@/components/ui/command";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import { toast } from "sonner";
import { SelectorTipoDocumento } from "./SelectorTipoDocumento";
import { useCrearProveedor } from "@/features/compras/proveedores/hooks/useProveedores";
import { useReglasDocumentos } from "@/configuracion/hooks/useReglasDocumentos";
import { limpiarSoloNumeros } from "@/lib/i18n";

interface SelectorProveedorProps {
  value: number;
  onChange: (proveedor: any) => void;
  proveedores: any[];
  onSearch: (term: string) => void;
}

export const SelectorProveedorV2: React.FC<SelectorProveedorProps> = ({
  value,
  onChange,
  proveedores = [],
  onSearch,
}) => {
  const [open, setOpen] = React.useState(false);
  const [tipoDoc, setTipoDoc] = React.useState("1"); // 1: DNI
  const [numDoc, setNumDoc] = React.useState("");
  const [razonSocial, setRazonSocial] = React.useState("");

  const crearProveedor = useCrearProveedor();
  const { data: configReglas } = useReglasDocumentos();

  const reglasMap = React.useMemo(() => {
    if (!configReglas?.reglas) return {};
    return configReglas.reglas.reduce((acc: any, curr) => {
      acc[curr.codigo] = curr;
      return acc;
    }, {});
  }, [configReglas]);

  // Sincronizar campos cuando se selecciona un proveedor existente
  React.useEffect(() => {
    if (value && proveedores.length > 0) {
      const p = proveedores.find((p) => p.id === value);
      if (p) {
        setTipoDoc(p.idTipoDocumento.toString());
        setNumDoc(p.numeroDocumento);
        setRazonSocial(p.razonSocial);
      }
    }
  }, [value, proveedores]);

  const regla = reglasMap[tipoDoc];

  const handleCrearRapido = () => {
    if (!numDoc || !razonSocial) {
      toast.error("Debe ingresar Documento y Razón Social");
      return;
    }

    if (regla && numDoc.length !== regla.longitud) {
      toast.error(`${regla.nombre} debe tener ${regla.longitud} caracteres`);
      return;
    }

    const existe = proveedores.find((p) => p.numeroDocumento === numDoc);
    if (existe) {
      toast.warning(
        `El proveedor con ${regla?.nombre || "documento"} ${numDoc} ya existe: ${existe.razonSocial}`,
      );
      onChange(existe);
      return;
    }

    crearProveedor.mutate(
      {
        idTipoDocumento: Number(tipoDoc),
        numeroDocumento: numDoc,
        razonSocial: razonSocial,
        activado: true,
      },
      {
        onSuccess: (nuevo) => {
          toast.success("Proveedor registrado y seleccionado");
          onChange(nuevo);
          setOpen(false);
        },
      },
    );
  };

  return (
    <div className="flex flex-col gap-2 w-full">
      <div className="flex gap-2 items-end">
        <div className="w-16">
          <SelectorTipoDocumento
            value={tipoDoc}
            onChange={(val: string) => {
              setTipoDoc(val);
              setNumDoc("");
            }}
            hideLabel
          />
        </div>

        <div className="w-40">
          <Input
            placeholder="Nº Documento"
            value={numDoc}
            onChange={(e) => {
              const val = regla?.esNumerico
                ? limpiarSoloNumeros(e.target.value)
                : e.target.value;
              if (regla && val.length <= regla.longitud) {
                setNumDoc(val);
              } else if (!regla) {
                setNumDoc(val);
              }
            }}
            className="text-center font-mono"
          />
        </div>

        <div className="flex-1 relative">
          <Popover open={open} onOpenChange={setOpen}>
            <PopoverTrigger asChild>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Razón Social o Buscar..."
                  value={razonSocial}
                  onChange={(e) => {
                    const val = e.target.value;
                    setRazonSocial(val);
                    onSearch(val);
                    if (val.length >= 3) setOpen(true);
                    if (!val) {
                      onChange(null);
                      setNumDoc("");
                    }
                  }}
                  className="pl-9"
                />
              </div>
            </PopoverTrigger>
            <PopoverContent className="w-[500px] p-0" align="start">
              <Command shouldFilter={false}>
                <CommandList>
                  <CommandEmpty>No se encontraron resultados.</CommandEmpty>
                  <CommandGroup heading="Proveedores Existentes">
                    {proveedores.map((p) => (
                      <CommandItem
                        key={p.id}
                        onSelect={() => {
                          onChange(p);
                          setOpen(false);
                        }}
                      >
                        <Check
                          className={cn(
                            "mr-2 h-4 w-4",
                            value === p.id ? "opacity-100" : "opacity-0",
                          )}
                        />
                        <div className="flex flex-col">
                          <span className="font-semibold">{p.razonSocial}</span>
                          <span className="text-xs text-muted-foreground">
                            {p.numeroDocumento}
                          </span>
                        </div>
                      </CommandItem>
                    ))}
                  </CommandGroup>
                </CommandList>
              </Command>
            </PopoverContent>
          </Popover>
        </div>

        <div className="flex items-center gap-1">
          <TooltipProvider>
            <Tooltip>
              <TooltipTrigger asChild>
                <Button
                  type="button"
                  variant="secondary"
                  size="icon"
                  className="h-9 w-9"
                  onClick={handleCrearRapido}
                  disabled={crearProveedor.isPending}
                >
                  <Plus className="h-5 w-5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>
                <p>Registrar nuevo proveedor con los datos ingresados</p>
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </div>
      </div>
    </div>
  );
};
