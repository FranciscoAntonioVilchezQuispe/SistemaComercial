import React from "react";
import { Check, Plus, Search, Trash2 } from "lucide-react";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { toast } from "sonner";
import {
  Popover,
  PopoverContent,
  PopoverAnchor,
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
// import { toast } from "sonner";
import { SelectorTipoDocumento } from "./SelectorTipoDocumento";
import { useCrearProveedor } from "@/features/compras/proveedores/hooks/useProveedores";
import { useReglasDocumentos } from "@/configuracion/hooks/useReglasDocumentos";
import { limpiarSoloNumeros } from "@compartido/utilidades";

interface SelectorProveedorProps {
  value: number;
  onChange: (proveedor: any) => void;
  proveedores: any[];
  onSearch: (term: string) => void;
  onTipoDocChange?: (codigo: string) => void;
  disabled?: boolean;
}

export const SelectorProveedorV2: React.FC<SelectorProveedorProps> = ({
  value,
  onChange,
  proveedores = [],
  onSearch,
  onTipoDocChange,
  disabled = false,
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
      if (curr.id) acc[curr.id.toString()] = curr;
      return acc;
    }, {});
  }, [configReglas]);

  // Sincronizar campos cuando se selecciona un proveedor existente
  React.useEffect(() => {
    if (value && proveedores.length > 0) {
      const p = proveedores.find((p) => p.id === value);
      if (p) {
        setTipoDoc(p.idTipoDocumento?.toString() || "1");
        setNumDoc(p.numeroDocumento || "");
        setRazonSocial(p.razonSocial || "");

        // Notificar el código si existe
        if (onTipoDocChange && configReglas?.reglas) {
          const r = configReglas.reglas.find(
            (reg) => reg.id === p.idTipoDocumento,
          );
          if (r) onTipoDocChange(r.codigo);
        }
      }
    }
  }, [value, proveedores, configReglas, onTipoDocChange]);

  const regla = reglasMap[tipoDoc];

  const handleCrearRapido = async () => {
    const largoMinimo = regla?.longitud || 0;
    const largoMaximo = regla?.longitudMaxima || regla?.longitud || 0;

    if (!numDoc || !razonSocial) {
      toast.error("Complete el documento y razón social");
      return;
    }

    if (numDoc.length < largoMinimo) {
      toast.error(`El número de documento debe tener al menos ${largoMinimo} caracteres`);
      return;
    }

    if (largoMaximo > 0 && numDoc.length > largoMaximo) {
      toast.error(`El número de documento no puede exceder los ${largoMaximo} caracteres`);
      return;
    }

    try {
      const nuevo = await crearProveedor.mutateAsync({
        idTipoDocumento: Number(tipoDoc),
        numeroDocumento: numDoc,
        razonSocial: razonSocial,
        nombreComercial: razonSocial,
        direccion: "Sin dirección",
        email: "proveedor@ejemplo.com",
        telefono: "",
        activado: true,
        esAgenteRetencion: false,
        esBuenContribuyente: false,
        esAgentePercepcion: false,
      });

      if (nuevo) {
        // Manejar respuesta envuelta en ToReturn o directa
        const proveedorFinal = (nuevo as any).datos || nuevo;
        onChange(proveedorFinal);
        toast.success("Proveedor registrado y seleccionado");
      }
    } catch (error: any) {
      console.error(error);
      toast.error("Error al registrar proveedor rápido");
    }
  };

  const handleClear = () => {
    onChange(null);
    setRazonSocial("");
    setNumDoc("");
    setTipoDoc("1"); // Reset a DNI
    if (onTipoDocChange) onTipoDocChange("");
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") {
      if (open) return;
      e.preventDefault();
      onSearch(razonSocial);
      setOpen(true);
    }
  };

  return (
    <div className="flex flex-col gap-2 w-full">
      <div className="flex gap-2 items-end">
        <div className="w-40">
          <SelectorTipoDocumento
            value={tipoDoc}
            onChange={(val: string) => {
              setTipoDoc(val);
              setNumDoc("");
              if (onTipoDocChange && configReglas?.reglas) {
                const r = configReglas.reglas.find(
                  (reg) => reg.id === Number(val),
                );
                if (r) onTipoDocChange(r.codigo);
              }
            }}
            hideLabel
            hideMessage={true}
            disabled={disabled}
          />
        </div>

        <div className="w-40">
          <Input
            placeholder="Nº Documento"
            value={numDoc}
            maxLength={regla?.longitudMaxima || regla?.longitud}
            onChange={(e) => {
              const val = regla?.esNumerico
                ? limpiarSoloNumeros(e.target.value)
                : e.target.value;
              setNumDoc(val);
            }}
            className="text-center font-mono"
            disabled={disabled}
          />
        </div>

        <div className="flex-1">
          <Command className="overflow-visible bg-transparent font-normal" shouldFilter={false}>
            <Popover open={open} onOpenChange={setOpen}>
              <div className="relative w-full">
                <PopoverAnchor asChild>
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      placeholder="Buscar proveedor (Enter)..."
                      value={razonSocial}
                      onChange={(e) => {
                        const val = e.target.value;
                        setRazonSocial(val);
                        if (val === "") {
                          onChange(null);
                          setOpen(false);
                        }
                      }}
                      onKeyDown={handleKeyDown}
                      className="pl-9 pr-10"
                      disabled={disabled}
                    />
                    {razonSocial && !disabled && (
                      <Button
                        type="button"
                        variant="ghost"
                        size="icon"
                        className="absolute right-0 top-0 h-9 w-9 text-muted-foreground hover:text-foreground"
                        onClick={handleClear}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </PopoverAnchor>
                <PopoverContent 
                  className="w-[500px] p-0" 
                  align="start"
                  onOpenAutoFocus={(e) => e.preventDefault()}
                >
                  <CommandList className="max-h-[300px] overflow-y-auto">
                    <CommandEmpty>Presiona Enter para buscar.</CommandEmpty>
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
                              {p.numeroDocumento} - {p.nombreComercial}
                            </span>
                          </div>
                        </CommandItem>
                      ))}
                    </CommandGroup>
                  </CommandList>
                </PopoverContent>
              </div>
            </Popover>
          </Command>
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
                  disabled={crearProveedor.isPending || disabled}
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
